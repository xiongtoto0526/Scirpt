//
//  AppDetailViewController.m
//  Tako
//
//  Created by 熊海涛 on 16/3/29.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "AppDetailViewController.h"
#import "UIHelper.h"
#import "TimeLineTableViewCell.h"
#import "Constant.h"
#import "AppVersion.h"
#import "Server.h"
#import "AppContentView.h"
#import "UIImageView+WebCache.h"
#import "WeixinActivity.h"
#import "DownloadQueue.h"
#import "SVPullToRefresh.h"
#import "WZLBadgeImport.h"

@interface AppDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UIView* textView;
@property (strong, nonatomic)NSArray *weChatActivitys;
@property (nonatomic,strong)UIBarButtonItem *downloadBarItem;
@end

#define TIME_LINE_CELL_HEIGHT 80
#define TIME_LINE_IMAGE_HEIGHT 80

@implementation AppDetailViewController

//fix: svpullrefresh的bug,一旦刷新,整个tableview会自动上移64个像素
- (void)viewDidLayoutSubviews {
    // 初始化刷新控制器
    if (self.tableView.pullToRefreshView == nil) {
        __weak AppDetailViewController *weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf reloadDataWhenRefresh];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setShowNewDownload:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 检查历史下载记录,更新状态
    for(int i=0;i<[self.listData count];i++){
        TakoAppVersion* appVersion = (TakoAppVersion*)[self.listData objectAtIndex:i];
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:appVersion.versionId];
        if (appHis==nil) {
            appVersion.status = INITED;
        }
        appVersion.status = [appHis.status intValue];
    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cursor=@"0";
    self.listData=nil;
    MBProgressHUD* hud = [XHTUIHelper modalAlertIn:self.view withText:@"正在加载..."];
    
    // 异步加载数据
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        self.listData =[self fetchDataFromServer];
        self.cursor = [NSString stringWithFormat:@"%lu",(unsigned long)[self.listData count]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.tableView reloadData];
        });
    });
    
    
    self.title = @"应用详情";
    
    // 去除边框,圆角化
    [XHTUIHelper addBorderonButton:self.shareButton cornerSize:4 borderWith:0];
    
    // 初始化profile信息
    self.appName.text = self.app.appname;
    self.releaseTime.text = self.app.releasetime;
    self.appVersion.text = self.app.versionname;
    [self.appImage sd_setImageWithURL:[NSURL URLWithString:self.app.logourl]
                     placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeLineTableViewCell"];
    
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickMoreNotification:) name:CLICK_MORE_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDetailDownloadNotification:) name:CLICK_DETAIL_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    // 添加segment事件
    [ self.segment addTarget: self action: @selector(controlPressed:) forControlEvents: UIControlEventValueChanged];
    
    // 添加分享事件
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    // 设置应用描述界面
    [self setUpTextView];
    
    
    // 增加导航栏的下载管理页面入口
    UIButton* button = [XHTUIHelper navButtonWithImage:@"download"];
    [button addTarget:self action:@selector(showDownloadManageView)
     forControlEvents:UIControlEventTouchUpInside];
    self.downloadBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.downloadBarItem.badgeBgColor = [UIColor colorWithRed:1 green:(float)102/255 blue:(float)102/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:self.downloadBarItem];
    
    // 注册 "加载更多"
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableview的delegate

// 设置headerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

// 行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}


//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TakoAppVersion* v = (TakoAppVersion*)[self.listData objectAtIndex:indexPath.row];
    if (v.cellHeight==nil) {
        return TIME_LINE_CELL_HEIGHT;
    }
    return [v.cellHeight floatValue];
}


// 点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 系统原生的cell
    //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineTableViewCell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TimeLineTableViewCell" owner:self options:nil] lastObject];
    }
    
    
    // 设置文本
    TakoAppVersion* currentVersion = (TakoAppVersion*)[self.listData objectAtIndex:indexPath.row];
    if (currentVersion.releaseDesc) {
        cell.appDesc.text = currentVersion.releaseDesc;
        [cell.moreButton setHidden:NO];
    }else{
        cell.appDesc.text = @"暂无更新描述~";
        [cell.moreButton setHidden:YES];
    }
    
    cell.versionName.text = [NSString stringWithFormat:@"版本:%@",currentVersion.versionname];
    cell.releaseTime.text = currentVersion.releasetime;
    cell.appSize.text = currentVersion.size;
    cell.moreButton.tag = indexPath.row;
    
       //    NSLog(@" init tag is:%ld",cell.moreButton.tag);
    
    // 设置图片
    if (currentVersion.isClicked) {
        [cell.moreButton setTitle:@"收起 ▲" forState:UIControlStateNormal];
    }else{
        [cell.moreButton setTitle:@"展开 ▼" forState:UIControlStateNormal];
    }
    
    if (currentVersion.status == INITED) {
        [cell.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    }else if(currentVersion.status>INITED && currentVersion.status<DOWNLOADED){
        [cell.downloadButton setTitle:@"已开始" forState:UIControlStateNormal];
    }else if (currentVersion.status == DOWNLOADED){
        [cell.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
    }
    
    return cell;
}




- (float)addHight:(TimeLineTableViewCell*)cell {
    //准备工作
    UILabel *textLabel = cell.appDesc;
    CGRect oldLableFrame =  textLabel.frame;
    
    textLabel.numberOfLines = 0;//根据最大行数需求来设置
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(oldLableFrame), 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    
    float diff = expectSize.height-CGRectGetHeight(oldLableFrame);
    if (diff<0) {
        diff = 0;
    }
    NSLog(@"add height :%f",diff);
    return diff;
}



-(void)receiveClickDetailDownloadNotification:(NSNotification*)notice{
    NSLog(@"receive more button clicked notification...");
    [self prepare];
    
   
    
    // todo: 最新版本,不允许再此处重复下载。
    
    // 定位到当前的cell
    TimeLineTableViewCell* cell = (TimeLineTableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    // 获取当前data
    TakoAppVersion* currentVersion = [self.listData objectAtIndex:indexPath.row];
    currentVersion.logourl = self.app.logourl;
    self.currentApp = [TakoApp new];
    self.currentApp.appid = self.app.appid;
    self.currentApp.logourl = self.app.logourl;
    self.currentApp.appname = currentVersion.appname;
    self.currentApp.versionId = currentVersion.versionId;
    self.currentApp.versionname = currentVersion.versionname;
    self.currentApp.lanhost = currentVersion.lanhost;//目前为空？
    self.currentApp.lanurl = currentVersion.lanurl;
    self.currentApp.downloadPassword = currentVersion.downloadPassword;
    self.currentApp.md5 = currentVersion.md5;
    
    /* 检查是否可加入下载队列 */
    // 0.是否已下载完成
    if (currentVersion.status ==DOWNLOADED) {
        [XHTUIHelper alertWithNoChoice:@"如需重新下载，请先删除安装包~" view:self];
        return;
    }
    
    // 1. 是否已经在下载中
    AppHis* his = [[AppHisDao share] fetchAppWithVersionId:currentVersion.versionId];
    if (his && [his.status intValue]<DOWNLOADED) {
        NSLog(@"尚未完成下载，无需再次下载");
        [XHTUIHelper alertWithNoChoice:@"尚未完成下载，无需再次下载" view:self];
        return;
    }
    
    // 2. 是否有密码
    if([self.app.password isEqualToString:@"true"]){
        [self showPasswordAlert:^{
        // 3. 其他检查
            [self gotoDownload:currentVersion cell:cell];
        }];
    }else{
        // 3. 其他检查
        [self gotoDownload:currentVersion cell:cell];
    }
    
}


-(void)receiveClickMoreNotification:(NSNotification*)notice{
    NSLog(@"receive more button clicked notification...");
    
    // 定位到当前的cell
    TimeLineTableViewCell* cell = (TimeLineTableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    // 获取当前data
    TakoAppVersion* currentVersion = [self.listData objectAtIndex:indexPath.row];
    currentVersion.isClicked = !currentVersion.isClicked;
    
    if (currentVersion.isClicked) {
        float diff = [self addHight:cell];
        currentVersion.cellHeight = [NSNumber numberWithFloat:TIME_LINE_CELL_HEIGHT + diff];
    }else{
        currentVersion.cellHeight = [NSNumber numberWithFloat:TIME_LINE_CELL_HEIGHT];
    }
    
    // animate
    if (currentVersion.isClicked) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    // 刷新cell
    [self.tableView reloadData];
}

#pragma mark segment delegate

- (void) controlPressed:(id)sender {
    int selectedIndex = (int)self.segment.selectedSegmentIndex;
    NSLog(@"selected index is:%d",selectedIndex);
    
    // 视图切换
    if (selectedIndex == 0) {
        [self.tableView setHidden:NO];
        
        [self.textView setHidden:YES];
    }else if (selectedIndex == 1){
        [self.tableView setHidden:YES];
        [self.textView setHidden:NO];
    }
}



#pragma mark share-button-delegate
-(void)shareButtonPressed{
    NSLog(@"share button pressed.");
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed){
        NSLog(@"activityType :%@", activityType);
        if (completed){
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");}
    };
    
    
    // 初始化微信view
    if (self.weChatActivitys==nil) {
        self.weChatActivitys = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    }
    
    // 初始化view
    UIImage* image = self.appImage.image ;
    NSString* urlString = [[XHTUIHelper takoAppUrl] stringByReplacingOccurrencesOfString:@"takoios" withString:self.app.uri];
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* description = [NSString stringWithFormat:@"发现一个不错的应用%@,快来试试吧~",self.app.appname];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[description, image,url] applicationActivities:self.weChatActivitys];
    
    // 排除系统的部分服务
    activityController.excludedActivityTypes = @[UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint,UIActivityTypeOpenInIBooks];
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该block都会被调用
    activityController.completionHandler = myBlock;
    
    // 适配ipad设备
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentViewController:activityController animated:YES completion:nil];
    }
    //if iPad
    else
    {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        NSLog(@"%f",self.view.frame.size.width/2);
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}



-(void)setUpTextView{
    if(self.textView == nil){
        NSString* content = self.app.appdesc;
        if ([XHTUIHelper isEmpty:content]) {
            content = @"暂无应用描述~";
        }
        self.textView = [[AppContentView alloc] initWithFrame:self.tableView.frame content:content];
        [self.view addSubview:self.textView];
        [self.textView setHidden:YES];
    }
}

- (void)loadMoreData
{
    // 从server端拉取数据,并根据历史记录更新状态
    NSArray* newdata = [self fetchDataFromServer];
    
    // 没有新数据提示
    if ([newdata count]==0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }

    [self.listData addObjectsFromArray:newdata];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
    // 更新游标
    self.cursor = [NSString stringWithFormat:@"%lu",(unsigned long)[self.listData count]];
}


-(NSMutableArray*)fetchDataFromServer{
    if (self.cursor==nil) {
        self.cursor=@"0";
    }
    
    NSMutableArray* newdata = [TakoServer fetchAppVersions:self.app.appid cursor:self.cursor];
    
    // 检查历史下载记录
    for(int i=0;i<[newdata count];i++){
        TakoAppVersion* appVersion = (TakoAppVersion*)[newdata objectAtIndex:i];
        appVersion.password = self.app.password;// 补充部分信息。
        
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:appVersion.versionId];
        if (appHis==nil) {
            continue;
        }
        appVersion.status = [appHis.status intValue];
    }
    
    return newdata;
}


// 从服务端重新加载数据
- (void)reloadDataWhenRefresh
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd,hh:mm:ss"];
    NSString *title = [NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:[NSDate date]]];
    [self.tableView.pullToRefreshView setSubtitle:title forState:SVPullToRefreshStateTriggered];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        [self resetAndReloadServerData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.pullToRefreshView stopAnimating];
        });
    });
    
}


// 清空历史数据，从server端重新加载
-(void)resetAndReloadServerData{
    
    self.cursor = @"0";
    // 从server端拉取数据
    NSArray* newdata = [self fetchDataFromServer];
    
    self.listData = [NSMutableArray arrayWithArray:newdata];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    self.cursor = [NSString stringWithFormat:@"%lu",(unsigned long)[self.listData count]];
}




-(void)showPasswordAlert:(void (^ __nullable)(void))finishBlock{
    
    // 弹出确认取消下载提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要输入下载密码。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"您取消了本次下载...");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"密码已输入...");
        UITextField *password = alertController.textFields.firstObject;
//        NSLog(@"download password is: %@",password.text);
        self.currentApp.downloadPassword = password.text;//缓存密码
        
        if (self.currentApp.downloadPassword==nil) {
            NSLog(@"下载密码无效。");
            [XHTUIHelper alertWithNoChoice:@"下载密码不能为空!" view:self];
            return;
        }
        finishBlock();
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入下载密码";
        //        textField.secureTextEntry = YES; // 暂时不做掩码
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


// 密码检查通过后，继续其他检查
-(void)gotoDownload:(TakoAppVersion*)currentVersion cell:(TimeLineTableViewCell*)cell{

    // 3. 下载地址是否正确
    [self getDownloadUrl];
    
    // 4. 启动下载，弹出提示框，通知用户去下载管理员查看进度
    // 等待 downloadQueue 上一个任务执行完成
    dispatch_async(self.downLoadQueue, ^{
        
        if (self.currentApp.downloadUrl == nil) {
            DDLogError(@"下载链接无效，无法下载...");
            return ;
        }
        
        TakoApp* app = [TakoApp new];
        app.appid = self.app.appid;
        app.appname = [NSString stringWithFormat:@"%@_%@",self.app.appname,currentVersion.versionname];
        app.versionId = currentVersion.versionId;
        app.versionname = currentVersion.versionname;
        
        app.logourl = currentVersion.logourl;
        app.md5 = currentVersion.md5;
        app.status = STARTED;
        app.password = currentVersion.password;
        app.downloadPassword = currentVersion.downloadPassword;
        app.packagename = currentVersion.packagename;
        app.isDownloadSuccess = NO;
        app.size = currentVersion.size;
        app.lanhost = currentVersion.lanhost;
        app.lanurl = currentVersion.lanurl;
        app.currentlength = @"0";
        app.totallength = @"0";
        app.releasetime = currentVersion.releasetime;
        
        [[AppHisDao share] createApp:app]; // 保存下载信息，refactor:可抽为service
      AppHis* aa = [[AppHisDao share] fetchAppWithVersionId:app.versionId];
      NSString* n =  aa.appname;// 调试用
      NSLog(@"调试信息:  app is ：%@",aa);
        
        // 必须主线程执行，否则viewcontroller接收不到进度
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl versionid:app.versionId tag:self.currentApp.versionId delegate:nil];
            [XHTUIHelper tipWithText:@"已加入下载队列~" time:2];
            [self setShowNewDownload:YES];
            [cell.downloadButton setTitle:@"已开始" forState:UIControlStateNormal];
        });
    });
}


-(void)setShowNewDownload:(BOOL)isShow{
    if (isShow) {
            [self.downloadBarItem showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeShake];
    }else{
        [self.downloadBarItem clearBadge];
    }
}

@end
