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

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate>
@property  NSMutableArray* sectionTitleArray;
@end

DownloadViewController* share = nil;
@implementation DownloadViewController

+(DownloadViewController*)share{
    return share;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];// 重新刷新cell
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    share = self;
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];

    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    // 加载 listData
    self.listData = [NSMutableArray new];
    self.sectionTitleArray = [NSMutableArray new];
    NSDictionary* dict =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if (dict==nil) {
        self.sectionTitleArray = [[NSMutableArray alloc]initWithObjects:@"已下载(0)",@"下载中(0)",nil];
        return;
    }
    
    NSMutableArray* downloadedList = [NSMutableArray new];
    NSMutableArray* downloadingList = [NSMutableArray new];
    for (NSString* key in dict) {
        DownloadHistoryInfo* info = [DownloadHistoryInfo new];
        NSDictionary* d = (NSDictionary*)[dict objectForKey:key];
        info.currentLength = [d objectForKey:DOWNLOAD_CURRENT_LENGTH_KEY];
        info.TotalLength = [d objectForKey:DOWNLOAD_TOTAL_LENGTH_KEY];
        info.status = [d objectForKey:DOWNLOAD_STATUS_KEY];
        info.appid = [d objectForKey:DOWNLOAD_APPID_KEY];
        
        TakoApp* app = nil;
        // 首次加载时，必须从外层刷controller里面的listdata中，拿到最新的appprogress信息
        NSArray* temp = [TestViewController share].listData;
        for (int i=0; i<[[TestViewController share].listData count]; i++) {
            TakoApp* tempApp = [temp objectAtIndex:i];
            if ([info.appid isEqualToString:tempApp.appid]) {
                app = tempApp;
                break;
            }
        }
        if (app == nil) {
            app = [TakoServer fetchAppWithid:info.appid];
        }
        
        int status = [info.status intValue];
        if (status == DOWNLOAD_FINISH_SUCCESS) {
            [downloadedList addObject:app];
        }else if(status == DOWNLOAD_START || status == DOWNLOAD_PAUSE){
            [downloadingList addObject:app];
            
//            // 首次加载时，必须从外层刷controller里面的listdata中，拿到最新的appprogress信息
//            NSArray* temp = [TestViewController share].listData;
//            for (int i=0; i<[[TestViewController share].listData count]; i++) {
//                TakoApp* tempApp = [temp objectAtIndex:i];
//                if ([app.versionId isEqualToString:tempApp.versionId]) {
//                    app.progress = tempApp.progress;
//                    app.progressValue = tempApp.progressValue;
//                    break;
//                }
//            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitleArray objectAtIndex:section];
}


// 改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
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
    
    
    UIImage* image = nil;
    if(app.logourl==nil || app.logourl.length==0){
        image = [UIImage imageNamed:@"ic_defaultapp"];// 没有logourl时，显示默认logo
        cell.appImage.image = image;
    }else{
        [cell.appImage sd_setImageWithURL:[NSURL URLWithString:app.logourl]
                         placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    }

    
    if (indexPath.section == 0) {
        [XHTUIHelper disableDownloadButton:cell.button];
        [self hideProgressUI:YES cell:cell];
    }else{
        [cell.button setTitle:@"继续" forState:UIControlStateNormal];
        [self hideProgressUI:NO cell:cell];//todo:暂时无法获取第一次的进度
    }
    
    cell.textDownload.text = app.progress;
    cell.progressControl.progress = app.progressValue;
    
    return cell;
}

// 增加间距，否则，无下载次数时section会重叠。
-(UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}



// 接收到cell的下载按钮点击事件
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
    if (indexPath.section==1) {
        app = [[self.listData objectAtIndex:1] objectAtIndex:indexPath.row];
    }else{
        app = [self.listData objectAtIndex:indexPath.row];
    }
    
    self.currentApp = app;
    self.currentCell = cell;
    
    [super receiveClickDownloadNotification:notice];
    
//    // 更新testviewController的app
//    NSArray* testApps = [TestViewController share].listData;
//    for (int i=0; i<[testApps count]; i++) {
//        TakoApp* temp = [testApps objectAtIndex:i];
//        if ([app.versionId isEqualToString:temp.versionId]) {
//            temp.isStarted = app.isStarted;
//            temp.isPaused = app.isPaused;
//            break;
//        }
//    }
}


// 接收到cell的取消按钮点击事件
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
    
//    // 更新testviewController的app
//    NSArray* testApps = [TestViewController share].listData;
//    for (int i=0; i<[testApps count]; i++) {
//        TakoApp* temp = [testApps objectAtIndex:i];
//        if ([app.versionId isEqualToString:temp.versionId]) {
//            temp.isStarted = app.isStarted;
//            temp.isPaused = app.isPaused;
//            temp.isSuccessed = app.isSuccessed;
//            temp.progress = app.progress;
//            temp.progressValue = app.progressValue;
//            break;
//        }
//    }
}


#pragma mark  下载回调
// 下载结束回调
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
    NSLog(@"收到回调通知：文件下载完成。");
    
    // 获取到button对应的cell
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSString* value = isSuccess? @"1":@"0";
    [dict setObject:value forKey:DOWNLOAD_RESULT_KEY];
    [dict setObject:tag forKey:DOWNLOAD_TAG_KEY];
    
//    // 发送事件
//    NSNotification *notification =[NSNotification notificationWithName:DOWNLAOD_MANAGE_PAGE_FINISH_NOTIFICATION object:nil userInfo:dict];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    
    // 只遍历第二个section
    NSArray* cellList = [self.listData objectAtIndex:1];
    
    // 找到对应的cell,app
    for (int i=0; i< [cellList count]; i++) {
        app = (TakoApp*)[cellList objectAtIndex:i];
        if ([app.versionId isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    if (isSuccess) {
        
        // 更新cell
        [XHTUIHelper disableDownloadButton:cell.button];
        // 记录已下载情况
        NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_VERSION_KEY];//userDefault只允许返回NSDictionary
        if (downloadAppDict==nil) {
            downloadAppDict = [NSDictionary new];
        }
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:downloadAppDict];
        [newDict setValue:@"1" forKey:app.versionId];
        [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_VERSION_KEY withObject:newDict];
    }else {
        [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
        [cell.button setTitle:@"重下载" forState:UIControlStateNormal];
        
        // 更新app
        app.isStarted=NO;
    }
    
    // 更新cell
    [self hideProgressUI:YES cell:cell];
    // 更新app
    app.progress = @"100%";
    app.isSuccessed=isSuccess;
    
   
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
    float prg = (float)finishSize/totalSize;
    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    // 只遍历第二个section
    NSArray* cellList = [self.listData objectAtIndex:1];
    
    // 找到对应的cell
    for (int i=0; i< [cellList count]; i++) {
             app = (TakoApp*)[cellList objectAtIndex:i];
        if ([app.versionId isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    // 更新cell
    [cell.progressControl setProgress:prg];
    NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
    progress = [NSString stringWithFormat:@"当前进度:%@%%",progress];
    cell.textDownload.text = progress;
    
    // 更新app
    app.progress = progress;
    app.progressValue = prg;

//    // 更新testController的app
//    NSArray* testApps = [TestViewController share].listData;
//    for (int i=0; i<[testApps count]; i++) {
//        TakoApp* temp = [testApps objectAtIndex:i];
//        if ([app.versionId isEqualToString:temp.versionId]) {
//            temp.progress = app.progress;
//            temp.progressValue = app.progressValue;
//            break;
//        }
//    }
}

@end
