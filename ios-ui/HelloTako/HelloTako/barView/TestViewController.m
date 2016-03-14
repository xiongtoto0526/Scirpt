//
//  FirstViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "TestViewController.h"
#import "TableViewCell.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "ShareEntity.h"
#import "UIHelper.h"
#import "App.h"
#import "DownloadWorker.h"
#import "Constant.h"
#import "Server.h"
#import "MJRefresh.h"
#import "DownloadQueue.h"
#import "UIImageView+WebCache.h"
#import "DownloadViewController.h"
#import "SWTableViewCell.h"

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate,SWTableViewCellDelegate>

@end


TestViewController* shareTest = nil;
@implementation TestViewController


+(TestViewController*)share{
    return shareTest;
}

#pragma mark view生命周期

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (![XHTUIHelper isLogined]) {
        [self presentViewController:[LoginViewController new] animated:NO completion:^{
            NSLog(@"should login first, will enter login view");
        }];
    }
    
    BOOL isLogined = [XHTUIHelper isLogined];
    [self.tableview setHidden:!isLogined];
    if (isLogined && [self.listData count]==0) {
        [self loadMoreData];
    }
    
    [self.tableview reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareTest = self;
    
    // 设置底部bar图片
    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"icon_test_unselected"];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_test_selected"];
    
    // 表格的源数据
    self.listData =[NSMutableArray new];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    
    // 添加下载进度监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadProgressNotification:) name:XHT_DOWNLOAD_PROGERSS_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadFinishNotification:) name:XHT_DOWNLOAD_FINISH_NOTIFICATION object:nil];
    
    
    // 未登录时不显示tableview
    [self.tableview setHidden:![XHTUIHelper isLogined]];
    
    // 初始化刷新控制器
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataWhenRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.refreshControl endRefreshing];    // 初始化时隐藏刷新控件
    [self.tableview addSubview:self.refreshControl];
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"fTablecell"];
    
    // 注册 "加载更多"
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    if ([XHTUIHelper isLogined]) {
        [self loadMoreData];
    }
    
}

#pragma mark cell上的点击事件

// 接收到cell的下载按钮点击事件
-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 区别1：两次监听中，只有一个是合法的。
    BOOL isValid = cell.tag == CELL_FOR_TEST_PAGE_KEY;
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
}



#pragma mark tableview的delegate


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}



//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 点击单元格，暂时关闭该页面。如需激活该方法，需要修改cell中设置。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
    // 数据绑定
    TakoApp* app = (TakoApp*)[self.listData objectAtIndex:indexPath.row];
    cell.appName.text=app.appname;
    cell.appVersion.text = app.version;
    cell.otherInfo.text = [NSString stringWithFormat:@"%@  %@",app.firstcreated,app.size];
    
    [cell.appImage sd_setImageWithURL:[NSURL URLWithString:app.logourl]
                     placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    
    [super updateApp:app cell:cell status:app.status];
    
    cell.textDownload.text = app.progress;
    cell.progressControl.progress = app.progressValue;
    
    
    // 标记当前cell
    cell.tag = CELL_FOR_TEST_PAGE_KEY;
    
    // 添加扩展按钮
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtons];
    
#ifdef DEBUG
//    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
#endif
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark  download的回调
// 下载结束回调
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
    NSLog(@"收到回调通知：文件下载完成。");
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    
    // 找到对应的cell,app
    for (int i=0; i<[self.listData count]; i++) {
        app = (TakoApp*)[self.listData objectAtIndex:i];
        if ([app.appid isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    if (isSuccess) {
        [super updateApp:app cell:cell status:DOWNLOADED];
    }else {
        [super saveCurrentAppStatus:DOWNLOADED_FAILED tag:app.appid];
        [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
    }
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
    
    // 找到对应的cell
    for (int i=0; i<[self.listData count]; i++) {
        app = (TakoApp*)[self.listData objectAtIndex:i];
        if ([app.appid isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    // 更新cell
    [cell.progressControl setProgress:prg];
    cell.textDownload.text = percent;
    cell.downloadSpeed.text = speed;
    
    // 更新app
    app.progress = percent;
    app.progressValue = prg;
    
    
    // 更新downloadpage的app,若新增了app，需要向管理页面添加新的item
    if ([DownloadViewController share].listData == nil) {
        return;
    }
    
    // todo: 待优化，可提前加入app。
    NSMutableArray* downloadApps = [[DownloadViewController share].listData objectAtIndex:1];
    BOOL isNew = YES;
    for (int i=0; i<[downloadApps count]; i++) {
        TakoApp* temp = [downloadApps objectAtIndex:i];
        if ([app.appid isEqualToString:temp.appid]) {
            isNew = NO;
            break;
        }
    }
    if (isNew) {
        [downloadApps addObject:app];
    }
    
}


#pragma mark view的其他私有方法
- (void)loadMoreData
{
    // 从server端拉取数据
    NSArray* newdata = [self fetchDataFromServer];
    
    // 没有新数据提示
    if ([newdata count]==0) {
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 检查历史下载记录
    NSDictionary* dict =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    NSLog(@"start dict is:%@",dict);
    
    // 存在历史下载记录
    if (dict!=nil) {
        
        for(int i=0;i<[newdata count];i++){
            TakoApp* app = (TakoApp*)[newdata objectAtIndex:i];
            
            BOOL isExist = NO;
            if ([DownloadViewController share].listData!=nil) {
                // 重新加载时，若存在下载管理页，直接从下载管理页的实例中获取最新的appProgress信息
                isExist = [self updateApp:app withDownloadPage:[DownloadViewController share].listData];
            }
            
            // 如果拿到，不再读取userdefault
            if (isExist) {
                continue;
            }
            
            for (NSString* key in dict) {
                NSDictionary* d = (NSDictionary*)[dict objectForKey:key];
                DownloadHistory* info = [[DownloadHistory shareInstance] initWithDictionary:d];
                info.download_appid = key;
                
                // 根据历史信息，再更新app的部分字段
                if([app.appid isEqualToString:info.download_appid])
                {
                    app = [self updateApp:app withHis:info];
                }
            }
            
        }
    }
    
    
    [self.listData addObjectsFromArray:newdata];
    [self.tableview reloadData];
    [self.tableview.mj_footer endRefreshing];
    
    // 更新游标
    self.cursor = [NSString stringWithFormat:@"%lu",(unsigned long)[self.listData count]];
}


-(NSMutableArray*)fetchDataFromServer{
    if (self.cursor==nil) {
        self.cursor=@"0";
    }
    
    NSMutableArray* data = [TakoServer fetchApp:self.cursor];
    return data;
}



// todo: 当下载管理中的cell下载进度更新时，需要重新加载本页面。
- (void)reloadDataWhenRefresh
{
    [self.tableview reloadData];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd,hh:mm a"];
        NSString *title = [NSString stringWithFormat:@"松开刷新，上次更新时间: %@", [formatter stringFromDate:[NSDate date]]];
        
        // 黑色字体
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        // 隐藏刷新栏
        [self.refreshControl endRefreshing];
    }
}


// 根据历史信息，部分字段需要回填app
-(TakoApp*) updateApp:(TakoApp*)app withHis:(DownloadHistory*)info{
    
    int status = [info.download_status intValue];
    
    // 如果已经下载成功了，且发现新版本，则更新app的状态
    if ([info.download_success_flag isEqualToString:@"1"] && ![app.versionId isEqualToString:info.download_app_version]) {
        app.status = TOBE_UPDATE;
        app.isNeedUpdate = YES;
    }
    
    // 已下载 或 安装失败
    else if (status == DOWNLOADED || status == INSTALLING || status == INSTALL_FAILED) {
        app.status = DOWNLOADED;
    }
    
    // 尚未下载完
    else if(status == STARTED || status == PAUSED){
        app.status = PAUSED;
        float currentL = [info.download_current_length floatValue];
        float totalL = [info.download_total_length floatValue];
        app.progressValue = (float)currentL/totalL;
        
        NSString* finishStr = [XHTUIHelper formatByteCount:currentL];
        NSString* totalStr = [XHTUIHelper formatByteCount:totalL];
        NSString* percent = [NSString stringWithFormat:@"%@/%@",finishStr,totalStr];
        app.progress = percent;
    }
    
    // 下载失败
    else if(status == INSTALLED){
        app.status = INSTALLED;
    }
    
    // 未更新前，需要使用旧的password,版本id和版本name。
    app.downloadPassword = info.download_password;
    app.versionId = info.download_app_version;
    app.version = info.download_app_version_name;
    
    return app;
}


-(BOOL)updateApp:(TakoApp*)app withDownloadPage:(NSArray*)listdata{
    BOOL isExist = NO;
    NSArray* temp = [listdata objectAtIndex:1];
    for (int i=0; i<[temp count]; i++) {
        TakoApp* tempApp = [temp objectAtIndex:i];
        if ([app.appid isEqualToString:tempApp.appid]) {
            app = tempApp;
            isExist = YES;
            break;
        }
    }
    return isExist;
}

// 返回NO，可以解决两侧的扩展按钮，整体出现的问题。
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



// 允许滑动
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat{
    NSLog(@"ok");
}



@end
