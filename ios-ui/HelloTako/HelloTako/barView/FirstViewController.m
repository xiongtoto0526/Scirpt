//
//  FirstViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "FirstViewController.h"
#import "TableViewCell.h"
#import "ThirdViewController.h"
#import "LoginViewController.h"
#import "GameDetailViewController.h"
#import "ShareEntity.h"
#import "UIHelper.h"
#import "App.h"
#import "DownloadWorker.h"
#import "Constant.h"
#import "Server.h"
#import "MJRefresh.h"
#import "DownloadQueue.h"
#import "UIImageView+WebCache.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate>
@property UIRefreshControl* refreshControl;
@property NSMutableArray* listData;
@property NSString* cursor;
@property TableViewCell* currentCell;
@property TakoApp* currentApp;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end


@implementation FirstViewController


-(void)viewDidAppear:(BOOL)animated{
    // t:此处不能模态alter窗口,否则崩溃。
    if (![XHTUIHelper isLogined]) {
        [self presentViewController:[LoginViewController new] animated:NO completion:^{
            NSLog(@"enter login view");
        }];
    }
    
    [super viewDidAppear:animated];
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
    NSLog(@"receive click download button event...");
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    self.currentCell = cell;
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [self.listData objectAtIndex:row];
    self.currentApp = app;
    
    // 处理
    if(app.isNeedPassword){
        [self showPasswordConfirm];
    }else{
        [self downloadApp];
    }
}


// 接收到cell的取消按钮点击事件
-(void)receiveCancelDownloadNotification:(NSNotification*)notice{
    NSLog(@"receive cancel download button event...");
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    self.currentCell = cell;
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [self.listData objectAtIndex:row];
    self.currentApp = app;
    
    // 处理
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消下载任务？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"您即将取消本次下载...");
        
        // 恢复下载按钮的文本显示
        TableViewCell *cell = self.currentCell;
        [cell.button setTitle:@"下载" forState:UIControlStateNormal];
        
        // 隐藏下载栏
        [cell.btnCancel setHidden:YES];
        [cell.progressControl setProgress:0];
        [cell.progressControl setHidden:YES];
        [cell.textDownload setHidden:YES];
        app.isStarted=NO;
        
        // 停止下载器
        [[XHtDownLoadQueue share] stop:app.versionId];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    UIViewController* currentVC = [XHTUIHelper getCurrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}


-(void)showPasswordConfirm{
    
    // 弹出确认取消下载提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要输入下载密码。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"您取消了本次下载...");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"密码已输入...");
        UITextField *password = alertController.textFields.firstObject;
        NSLog(@"download password is: %@",password.text);
        self.currentApp.downloadPassword = password.text;//缓存密码
        
        if (self.currentApp.downloadPassword==nil) {
            NSLog(@"下载密码无效。");
            [XHTUIHelper alertWithNoChoice:@"下载密码不能为空!" view:self];
            return;
        }
        [self downloadApp];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入下载密码";
        //        textField.secureTextEntry = YES; // 暂时不做掩码
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)downloadApp{
    
    // 从server端获取下载地址。
    self.currentApp.downloadUrl = [TakoServer fetchDownloadUrl:self.currentApp.versionId password:self.currentApp.downloadPassword];
    if (self.currentApp.downloadUrl==nil) {
        NSLog(@"get downloadurl failed...");
        [XHTUIHelper alertWithNoChoice:@"下载密码不正确!" view:self];
        return;
    }
    
    NSLog(@"password is ok, will download from :%@",self.currentApp.downloadUrl);
    if (!self.currentApp.isStarted) {
        [self startDownload];
    }else if(!self.currentApp.isPaused){
        [self pauseDownload];
    }else{
        [self countinueDownload];
    }
    
    // 更新cell
    TableViewCell *cell =  self.currentCell;
    [cell.btnCancel setHidden:NO];
    [cell.progressControl setHidden:NO];
    [cell.textDownload setHidden:NO];
}


// 启动下载
-(void)startDownload{
    NSLog(@"will start download...");
    self.currentApp.isPaused = NO;
    self.currentApp.isStarted=YES;
    [self.currentCell.button setTitle:@"暂停" forState:UIControlStateNormal];  // 修改下载按钮的文本显示
    
    /* 添加到下载队列。注：
     1. 下载队列无界，可无限添加，但每次只能有1个（constant.h中可配置梳理）活跃线程下载。允许重复添加（程序会自动识别）。
     2. 当某个应用暂停后，程序会保存当前进度。即使退出应用，下次进入时，仍可继续下。
     3. 参数tag说明: tag 为每个下载记录的唯一标识。
     */
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl appid:self.currentApp.appid password:self.currentApp.downloadPassword tag:self.currentApp.versionId delegate:self];
}


// 继续下载
-(void)countinueDownload{
    NSLog(@"will continue download...");
    [self.currentCell.button setTitle:@"暂停" forState:UIControlStateNormal];
    self.currentApp.isPaused = NO;
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl appid:self.currentApp.appid password:self.currentApp.downloadPassword tag:self.currentApp.versionId delegate:self];
}



// 暂停下载
-(void)pauseDownload{
    NSLog(@"will pause download...");
    [self.currentCell.button setTitle:@"继续" forState:UIControlStateNormal];
    self.currentApp.isPaused = YES;
    [[XHtDownLoadQueue share] pause:self.currentApp.appid];
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
    
    // 初始化其他属性
    for(int i=0;i<[newdata count];i++){
        TakoApp* app = (TakoApp*)[newdata objectAtIndex:i];
        app.isStarted=NO;
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


//改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

// 点击单元格，暂时关闭该页面。如需激活该方法，需要修改cell中设置。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"即将进入“游戏详情”页面...");
    //    GameDetailViewController* gameDetailView = [[GameDetailViewController alloc] init];
    //    [self presentViewController:gameDetailView animated:YES completion:nil];
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
    
    UIImage* image = nil;
    if(app.logourl==nil || app.logourl.length==0){
        image = [UIImage imageNamed:@"ic_defaultapp"];// 没有logourl时，显示默认logo
        cell.appImage.image = image;
    }else{
        [cell.appImage sd_setImageWithURL:[NSURL URLWithString:app.logourl]
                         placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    }
    
    if ([self isAppDownloadedBefore:app.versionId]) {
//        NSLog(@"重复应用信息,名称，%@，版本，%@",cell.appName.text,app.versionId);
        [XHTUIHelper disableDownloadButton:cell.button];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// 判断app是否下载过
-(BOOL)isAppDownloadedBefore:(NSString*) versionId{
    BOOL isExist = NO;
    NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_VERSION_KEY];
    for (NSString *key in downloadAppDict) {
        if ([key isEqualToString:versionId]) {
            NSLog(@"该应用已保存在下载记录中...");
            isExist = YES;
            NSLog(@"versionId is:%@",versionId);
            NSLog(@"downloadAppDict is:%@",downloadAppDict);
            break;
        }
    }
    return isExist;
}

// 显示下载进度栏
-(void) showDownload:(TableViewCell*) cell{
    [cell.btnCancel setHidden:NO];
    [cell.progressControl setHidden:NO];
    [cell.textDownload setHidden:NO];
}


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
        if ([app.versionId isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
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
        app.isStarted=NO;
    }
    
    // 更新cell
    [cell.progressControl setHidden:YES];
    [cell.btnCancel setHidden:YES];
    [cell.textDownload setHidden:YES];
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
    float prg = (float)finishSize/totalSize;
    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    
    TableViewCell* cell = nil;
    
    // 找到对应的cell
    for (int i=0; i<[self.listData count]; i++) {
        TakoApp* app = (TakoApp*)[self.listData objectAtIndex:i];
        if ([app.versionId isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    // 更新cell
    [cell.progressControl setProgress:prg];
    NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
    cell.textDownload.text = [NSString stringWithFormat:@"当前进度:%@%%",progress];
}


@end
