//
//  DownloadViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 16/3/4.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "DownloadViewController.h"
#import "TableViewCell.h"
#import "UIHelper.h"
#import "Constant.h"
#import "Server.h"
#import "UIImageView+WebCache.h"
#import "DownloadQueue.h"
#import "TestViewController.h"

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate,MGSwipeTableCellDelegate>
@property  NSMutableArray* sectionTitleArray;
@end

DownloadViewController* share = nil;
@implementation DownloadViewController

+(DownloadViewController*)share{
    return share;
}

#pragma mark view生命周期

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self migrateItemIfneed];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    share = self;
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 添加按钮点击监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    // 添加下载进度监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadProgressNotification:) name:XHT_DOWNLOAD_PROGERSS_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadFinishNotification:) name:XHT_DOWNLOAD_FINISH_NOTIFICATION object:nil];
    
    
    // 加载 listData
    self.listData = [NSMutableArray new];
    NSMutableArray* downloadedList = [NSMutableArray new];
    NSMutableArray* downloadingList = [NSMutableArray new];
    self.sectionTitleArray = [NSMutableArray new];
    NSDictionary* dict =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if (dict==nil) {
        self.sectionTitleArray = [[NSMutableArray alloc]initWithObjects:@"已下载(0)",@"下载中(0)",nil];
        [self.listData addObject:downloadedList];
        [self.listData addObject:downloadingList];
        return;
    }
    
    for (NSString* key in dict) {
        NSDictionary* d = (NSDictionary*)[dict objectForKey:key];
        DownloadHistory* info = [[DownloadHistory shareInstance] initWithDictionary:d];
        
        TakoApp* app = nil;
        // 首次加载时，必须从外层刷controller里面的listdata中，拿到最新的appprogress信息
        NSArray* temp = [TestViewController share].listData;
        for (int i=0; i<[[TestViewController share].listData count]; i++) {
            TakoApp* tempApp = [temp objectAtIndex:i];
            if ([info.download_appid isEqualToString:tempApp.appid]) {
                app = tempApp;
                break;
            }
        }
        if (app == nil) {
            app = [TakoServer fetchAppWithid:info.download_appid];
        }
        
        // 根据状态分别加载两个list
        int status = [info.download_status intValue];
        if (status == DOWNLOADED) {
            [downloadedList addObject:app];
        }else if(status == STARTED || status == PAUSED){
            [downloadingList addObject:app];
        }
    }
    
    
    [self.listData addObject:downloadedList];
    [self.listData addObject:downloadingList];
    
    
    // 设置section title
    NSString* title1 = [NSString stringWithFormat:@"已下载(%lu)",(unsigned long)[downloadedList count]];
    NSString* title2 = [NSString stringWithFormat:@"下载中(%lu)",(unsigned long)[downloadingList count]];
    [self.sectionTitleArray addObject:title1];
    [self.sectionTitleArray addObject:title2];
    
    
}

#pragma mark tableview的delegate

//section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitleArray objectAtIndex:section];
}


// 改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


// section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitleArray count];
}

// section中的cell数目
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.listData count] == 0 || [self.listData objectAtIndex:section] ==nil) {
        return 0;
    }
    return [[self.listData objectAtIndex:section] count];
}

// 加载单元格
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
    
    TakoApp* app = [(NSArray*)[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.appName.text = app.appname;
    cell.appVersion.text = app.version;
    cell.otherInfo.text = [NSString stringWithFormat:@"%@  %@",app.firstcreated,app.size];
    
   
    [cell.appImage sd_setImageWithURL:[NSURL URLWithString:app.logourl]
                         placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    
    
    [super updateApp:app cell:cell status:app.status];
    cell.textDownload.text = app.progress;
    cell.progressControl.progress = app.progressValue;
    
    
    cell.delegate = self;
    
    return cell;
}

// 增加间距，否则，无下载次数时section会重叠。
-(UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark 点击事件

// 接收到cell的下载按钮点击事件, 调用父类方法处理。
-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 区别1：两次监听中，只有一个是合法的。
    BOOL isValid = NO;
    isValid = [[cell superview] superview] == self.tableview;
    if (!isValid) {
        return;
    }
    
    // 区别2：两个controller的数据源维度不一样。
    TakoApp* app = nil;
    NSIndexPath* indexPath = [self.tableview indexPathForCell:cell];
    app = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    self.currentApp = app;
    self.currentCell = cell;
    
    [super receiveClickDownloadNotification:notice];
}


// 接收到cell的取消按钮点击事件, 调用父类方法处理。
-(void)receiveCancelDownloadNotification:(NSNotification*)notice{
    
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 区别1：两次监听中，只有一个是合法的。
    BOOL isValid = NO;
    isValid = [[cell superview] superview] == self.tableview;
    if (!isValid) {
        return;
    }
    
    // 区别2：两个controller的数据源维度不一样。
    TakoApp* app = nil;
    NSIndexPath* indexPath = [self.tableview indexPathForCell:cell];
    if (indexPath.section==1) {
        app = [[self.listData objectAtIndex:1] objectAtIndex:indexPath.row];
    }else{
        app = [self.listData objectAtIndex:indexPath.row];
    }
    
    self.currentApp = app;
    self.currentCell = cell;
    
    [super receiveCancelDownloadNotification:notice];
    
}

#pragma mark view的其他私有方法

// 更新下载数量
-(void)refreshTableTitle{
    NSMutableArray* downloadingList = [self.listData objectAtIndex:1];
    NSMutableArray* downloadedList = [self.listData objectAtIndex:0];
    
    // 设置section title
    NSString* title1 = [NSString stringWithFormat:@"已下载(%lu)",(unsigned long)[downloadedList count]];
    NSString* title2 = [NSString stringWithFormat:@"下载中(%lu)",(unsigned long)[downloadingList count]];
    
    [self.sectionTitleArray replaceObjectAtIndex:0 withObject:title1];
    [self.sectionTitleArray replaceObjectAtIndex:1 withObject:title2];
    [self.sectionTitleArray objectAtIndex:1];
}

// 更新已下载状态数
-(void)migrateItemIfneed{
    NSMutableArray* downloadingList = [self.listData objectAtIndex:1];
    NSMutableArray* downloadedList = [self.listData objectAtIndex:0];
    if (downloadingList != nil) {
        for (int i=0; i<[downloadingList count]; i++) {
            TakoApp* temp = [downloadingList objectAtIndex:i];
            if (temp.status == DOWNLOADED) {
                [downloadedList addObject:temp];
                [downloadingList removeObject:temp];
            }
        }
    }
    [self refreshTableTitle];
    [self.tableview reloadData];
}


#pragma mark  下载回调

// 下载结束回调
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
    NSLog(@"收到回调通知：文件下载完成。");
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    
    // 只遍历第二个section
    NSArray* cellList = [self.listData objectAtIndex:1];
    
    // 找到对应的cell,app
    for (int i=0; i< [cellList count]; i++) {
        app = (TakoApp*)[cellList objectAtIndex:i];
        if ([app.appid isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    if (isSuccess) {
        [super updateApp:app cell:cell status:DOWNLOADED];
        [super saveCurrentAppStatus:DOWNLOADED tag:app.appid];
    }else {
        [super updateApp:app cell:cell status:DOWNLOADED_FAILED];
        [super saveCurrentAppStatus:DOWNLOADED_FAILED tag:app.appid];
        [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
    }
    [self migrateItemIfneed];
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize speed:(NSString *)speed tag:(NSString *)tag{
    

    float prg = (float)finishSize/totalSize;
//    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    NSString* finishStr = [XHTUIHelper formatByteCount:finishSize];
    NSString* totalStr = [XHTUIHelper formatByteCount:totalSize];
    NSString* percent = [NSString stringWithFormat:@"%@/%@",finishStr,totalStr];
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    
    // 只遍历第二个section
    NSArray* cellList = [self.listData objectAtIndex:1];
    
    // 找到对应的cell
    for (int i=0; i< [cellList count]; i++) {
        app = (TakoApp*)[cellList objectAtIndex:i];
        if ([app.appid isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    // 更新cell
    [cell.progressControl setProgress:prg];
    cell.textDownload.text = percent;
    cell.downloadSpeed.text = speed;
    
    // 更新app
    app.progressValue = prg;
}

@end
