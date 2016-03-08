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

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate>

@end


TestViewController* shareTest = nil;
@implementation TestViewController


+(TestViewController*)share{
    return shareTest;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.tableview reloadData];
    // t:此处不能模态alter窗口,否则崩溃。
    if (![XHTUIHelper isLogined]) {
        [self presentViewController:[LoginViewController new] animated:NO completion:^{
            NSLog(@"enter login view");
        }];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)receiveLoginBackNotification{
    BOOL isLogined = [XHTUIHelper isLogined];
    [self.tableview setHidden:!isLogined];
    if (isLogined && [self.listData count]==0) {
        [self loadMoreData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareTest = self;
    
    // 设置底部bar图片
    self.tabBarItem.image = [UIImage imageNamed:@"icon_test_unselected"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_test_selected"];
    
    // 表格的源数据
    self.listData =[NSMutableArray new];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginBackNotification) name:LOGIN_BACK_TO_TEST_NOTIFICATION object:nil];
    
    
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



#pragma mark 上拉加载更多数据
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
    if (dict!=nil) {
        // 初始化其他属性
        for(int i=0;i<[newdata count];i++){
            TakoApp* app = (TakoApp*)[newdata objectAtIndex:i];
            
            // 重新加载时，若存在下载管理页，直接从下载管理页的实例中获取最新的appProgress信息
            BOOL isExist = NO;
            if ([DownloadViewController share].listData!=nil) {
                NSArray* temp = [[DownloadViewController share].listData objectAtIndex:1];
                for (int i=0; i<[temp count]; i++) {
                    TakoApp* tempApp = [temp objectAtIndex:i];
                    if ([app.appid isEqualToString:tempApp.appid]) {
                        app = tempApp;
                        isExist = YES;
                        break;
                    }
                }
            }
            
            // 如果拿到，不再读取userdefault
            if (isExist) {
                continue;
            }
            
            for (NSString* key in dict) {
                DownloadHistoryInfo* info = [DownloadHistoryInfo new];
                NSDictionary* d = (NSDictionary*)[dict objectForKey:key];
                info.appid = key;
                if([app.appid isEqualToString:info.appid])
                {
                    info.currentLength = [d objectForKey:DOWNLOAD_CURRENT_LENGTH_KEY];
                    info.TotalLength = [d objectForKey:DOWNLOAD_TOTAL_LENGTH_KEY];
                    info.status = [d objectForKey:DOWNLOAD_STATUS_KEY];
                    int status = [info.status intValue];
                    if (status == DOWNLOADED || status == INSTALLING) {
                        app.status = DOWNLOADED;
                    }else if(status == STARTED || status == PAUSED){
                        app.status = PAUSED;
                        float currentL = [info.currentLength floatValue];
                        float totalL = [info.TotalLength floatValue];
                        app.progressValue = (float)currentL/totalL;
                        NSString* progress = [NSString stringWithFormat:@"%.1lf",app.progressValue*100];
                        app.progress = [NSString stringWithFormat:@"当前进度:%@%%",progress];
                    }else if(status == INSTALLED){
                        app.status = INSTALLED;
                    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


#pragma mark  下载回调
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
         // 记录已下载情况
//        [super saveCurrentAppStatus:DOWNLOADED tag:app.appid];
    }else {
//         [super updateApp:app cell:cell status:DOWNLOADED_FAIL];
         [super saveCurrentAppStatus:DOWNLOADED_FAIL tag:app.appid];
        [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
    }
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
    float prg = (float)finishSize/totalSize;
//    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    
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
    NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
    progress = [NSString stringWithFormat:@"当前进度:%@%%",progress];
    cell.textDownload.text = progress;
    
    // 更新app
    app.progress = progress;
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



@end
