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
#import "UIHelper.h"
#import "App.h"
#import "DownloadWorker.h"
#import "Constant.h"
#import "Server.h"
#import "DownloadQueue.h"
#import "UIImageView+WebCache.h"
#import "DownloadViewController.h"
#import "SWTableViewCell.h"
#import "AppHisDao.h"
#import "AppDetailViewController.h"
#import "SVPullToRefresh.h"
#import "SearchViewController.h"
#import "WZLBadgeImport.h"

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate,SWTableViewCellDelegate,UISearchBarDelegate>
@property (nonatomic,weak)UISearchBar *searchBar;
@property (nonatomic,strong)UIBarButtonItem *downloadBarItem;
@end


@implementation TestViewController



#pragma mark view生命周期

//fix: svpullrefresh的bug,一旦刷新,整个tableview会自动上移64个像素
- (void)viewDidLayoutSubviews {
    // 初始化刷新控制器
    if (self.tableview.pullToRefreshView == nil) {
        __weak TestViewController *weakSelf = self;
        [self.tableview addPullToRefreshWithActionHandler:^{
            [weakSelf reloadDataWhenRefresh];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.listData count]==0) {
        [self resetAndReloadServerData];// inside , table view will reload.
        return;
    }
    
    // 读取下载情况，更新状态。
    for(int i=0;i<[self.listData count];i++){
        TakoApp* app = (TakoApp*)[self.listData objectAtIndex:i];
        NSLog(@"app name is:%@,count is:%d",app.appname,i);
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:app.versionId];
        
        // 下载历史被清空后时，需要处理此情况。
        if (appHis==nil && app.status > INITED) {
            app.status = INITED;
        }
        app = [self updateApp:app withHis:appHis];
    }
    [self.tableview reloadData];
}

-(void)refreshAppFromHis{
    // 读取下载情况，更新状态。
    for(int i=0;i<[self.listData count];i++){
        TakoApp* app = (TakoApp*)[self.listData objectAtIndex:i];
        NSLog(@"app name is:%@,count is:%d",app.appname,i);
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:app.versionId];
        if (appHis==nil && app.status > INITED) {
            app.status = INITED;
        }
        app = [self updateApp:app withHis:appHis];
    }
    [self.tableview reloadData];
}

// todo: view整个上移了
-(void)clearviewData{
    NSLog(@"will clear data");
    self.listData = [NSMutableArray new];
    self.cursor = @"0";
    self.currentCell=nil;
    self.currentApp=nil;
    //    self.view = nil;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.searchBar resignFirstResponder];
}


- (void)viewDidLoad {
    
    [XHTUIHelper writeNSUserDefaultsWithKey:IS_LOADD_BAR_VIEW_KEY withObject:@"1"];
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // 增加手势切换页面
//    [self addTabBarswipeGesture];
    
    // 增加搜索框
    [self addSearchBar];
    self.title = @"测试";
//    self.title = @"我参与的测试";
    self.navigationController.tabBarItem.title = @"测试";
    
    [XHTUIHelper formatNavigateColor:self.navigationController.navigationBar];// 将导航栏设置为蓝色
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];// 默认为蓝色，此处更改为白色以适应push出来的子view导航栏的文字颜色。
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    
    // 表格的源数据
    self.listData =[NSMutableArray new];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    // 退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearviewData) name:USER_LOGOUT_NOTIFICATION object:nil];
    
    
    // 添加下载进度监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadProgressNotification:) name:XHT_DOWNLOAD_PROGERSS_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadFinishNotification:) name:XHT_DOWNLOAD_FINISH_NOTIFICATION object:nil];
    
    
    // 增加导航栏的下载管理页面入口
    UIButton* button = [XHTUIHelper navButtonWithImage:@"download"];
    [button addTarget:self action:@selector(showDownloadManageView)
     forControlEvents:UIControlEventTouchUpInside];
    self.downloadBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.downloadBarItem.badgeBgColor = [UIColor colorWithRed:1 green:(float)102/255 blue:(float)102/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:self.downloadBarItem ];

    #ifdef IS_SIDE_MENU_ENABLE
    // 增加menu口
     UIButton* menuButton = [XHTUIHelper navButtonWithImage:nil];
    [menuButton setTitle:@"≡" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [menuButton addTarget:self action:@selector(showMenuView)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:item2];
    #endif
    
    // 未登录时不显示tableview
    [self.tableview setHidden:![XHTUIHelper isLogined]];
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    // 注册 "加载更多"
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

#pragma mark cell上的点击事件

// 接收到cell的下载按钮点击事件
-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    NSLog(@"enter test receiveClickDownloadNotification");
    
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
    app = [self.listData objectAtIndex:indexPath.row];
    self.currentApp = app;
    self.currentCell = cell;
    
    [super receiveClickDownloadNotification:notice];
    
    NSLog(@"finish test receiveClickDownloadNotification");
}


// 接收到cell的取消按钮点击事件
-(void)receiveCancelDownloadNotification:(NSNotification*)notice{
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
    app = [self.listData objectAtIndex:indexPath.row];
    
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
    TakoApp* app = (TakoApp*)[self.listData objectAtIndex:indexPath.row];
    
#ifdef IS_CELL_EXT_BUTTON_DISPLAY
    if (app.isClicked) {
        return 125;
    }
#endif
    if (app.isHidden) {
        return 0;
    }
    return 80;
}

// 点击单元格，可显示扩展按钮。暂时关闭该页面。如需激活该方法，需要修改cell中设置。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    TakoApp* app = (TakoApp*)[self.listData objectAtIndex:indexPath.row];
    for (TakoApp* temp in self.listData) {
        if (temp != app) {
            temp.isClicked = NO;
        }
    }
    app.isClicked = !app.isClicked;
    
    // 关闭键盘
    [self.searchBar resignFirstResponder];
    
#ifdef IS_APP_DETAIL_DISPLAY
    AppDetailViewController* appDetail = [[AppDetailViewController alloc] init];
    appDetail.app = app;
    [self.navigationController pushViewController:appDetail animated:YES];
#endif
    // animate the cell change
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
    
    // 数据绑定
    TakoApp* app = (TakoApp*)[self.listData objectAtIndex:indexPath.row];
    // [cell.button setHidden:NO];
    cell.appName.text=app.appname;
    cell.appVersion.text = app.versionname;
    cell.otherInfo.text = [NSString stringWithFormat:@"%@  %@",app.releasetime,app.size];
    
    [cell.appImage sd_setImageWithURL:[NSURL URLWithString:app.logourl]
                     placeholderImage:[UIImage imageNamed:@"ic_defaultapp"]];
    
    [super updateApp:app cell:cell status:app.status];
    [super updateProgress:app cell:cell];
    
    
    // 标记当前cell
    cell.tag = CELL_FOR_TEST_PAGE_KEY;
    
    // 添加扩展按钮
//    cell.delegate = self;
//    cell.rightUtilityButtons = [self rightButtons];
    
#ifdef DEBUG
    //    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
#endif
    
    return cell;
}

//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    TableViewCell* newcell = (TableViewCell*)cell;
//    bool ishiddend = newcell.button.hidden;
//    NSLog(@"cell is:%@",newcell.button);
//}



#pragma mark  download的回调
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
        [super updateApp:app cell:cell status:DOWNLOADED];
        [super beginInstall:app cell:cell];
        // 更新version显示
        if (app.serverVersion) {
            app.versionname = app.serverVersion;
        }
        cell.appVersion.text = app.versionname;
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
        });
        
        
        [super updateApp:app cell:cell status:DOWNLOADED_FAILED];
    }
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize speed:(NSString *)speed tag:(NSString *)tag{
    
    float prg = (float)finishSize/totalSize;
    NSString* finishStr = [XHTUIHelper formatByteCount:finishSize];
    NSString* totalStr = [XHTUIHelper formatByteCount:totalSize];
    NSString* percent = [NSString stringWithFormat:@"%@/%@",finishStr,totalStr];
    
    
    TableViewCell* cell = nil;
    TakoApp* app = nil;
    
    // 找到对应的cell
    for (int i=0; i<[self.listData count]; i++) {
        app = (TakoApp*)[self.listData objectAtIndex:i];
        if ([app.versionId isEqualToString:tag]) {
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
    app.currentlength = [XHTUIHelper stringWithLong:finishSize];;
    app.totallength = [XHTUIHelper stringWithLong:totalSize];;
    app.progress = percent;
    app.progressValue = prg;
    
}


#pragma mark view的其他私有方法
-(void)resetAndReloadServerData{
    
    self.cursor = @"0";
    // 从server端拉取数据
    NSArray* newdata = [self fetchDataFromServer];
    
    // 检查历史下载记录
    for(int i=0;i<[newdata count];i++){
        TakoApp* app = (TakoApp*)[newdata objectAtIndex:i];
        
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:app.versionId];
        if (appHis==nil) {
            continue;
        }
        app = [self updateApp:app withHis:appHis];
    }
    
    self.listData = [NSMutableArray arrayWithArray:newdata];
    [self.tableview reloadData];
    [self.tableview.mj_footer endRefreshing];
    self.cursor = [NSString stringWithFormat:@"%lu",(unsigned long)[self.listData count]];
}


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
    for(int i=0;i<[newdata count];i++){
        TakoApp* app = (TakoApp*)[newdata objectAtIndex:i];
        
        AppHis* appHis = [[AppHisDao share] fetchAppWithVersionId:app.versionId];
        if (appHis==nil) {
            continue;
        }
        app = [self updateApp:app withHis:appHis];
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



// 从服务端重新加载数据
- (void)reloadDataWhenRefresh
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd,hh:mm:ss"];
    NSString *title = [NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:[NSDate date]]];
    [self.tableview.pullToRefreshView setSubtitle:title forState:SVPullToRefreshStateTriggered];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        [self resetAndReloadServerData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview.pullToRefreshView stopAnimating];
        });
    });

}


// 根据历史信息，部分字段需要回填app
-(TakoApp*) updateApp:(TakoApp*)app withHis:(AppHis*)appHis{
    
    
    // 下载历史被清空后时，需要处理此情况。
    if (appHis==nil && app.status > INITED) {
        app.status = INITED;
        return app;
    }
    
    if(!appHis){
        return app;
    }
    
    int status = [appHis.status intValue];
    NSLog(@"app name:%@,app bundle id:%@",app.appname,app.bundleid);
    // 如果已经下载成功了，且发现新版本，则更新app的状态
    if ([appHis.isDownloadSuccess boolValue]) {
        
        BOOL isNewVersion = ![app.versionId isEqualToString:appHis.versionId] ;
                
        // 若不是新版本，再判断下serversionId的字段
        if (!isNewVersion) {
            isNewVersion = app.serverVersionId!=nil && ![app.serverVersionId isEqualToString:appHis.versionId];
        }
        
        
        if (isNewVersion) {
            app.status = TOBE_UPDATE;
            app.isNeedUpdate =YES;
            app.serverVersionId = app.versionId;
            app.serverVersion = app.versionname;
            app.isDownloadSuccess = YES;
        }else{
            app.status = status;
            app.isDownloadSuccess = YES;
        }
        
    }
    
    // 已下载 或 安装失败
    else if (status == DOWNLOADED || status == INITED) {
        app.status = status;
    }
    
    // 尚未下载完
    else if(status == STARTED || status == PAUSED){
        app.status = status;
        float currentL = [appHis.currentlength floatValue];
        float totalL = [appHis.totallength floatValue];
        
        
        // 正常情况下不存在，除非应用调试阶段强制退出。
        if (totalL == 0 || currentL == 0) {
            app.progressValue = 0;
            // 有一种情况，已安装，进度立即清零。此时无需关注该警告。
            DDLogWarn(@"warning!!! 原始进度可能丢失，需要重新下载.");
        }else{
            app.progressValue = (float)currentL/totalL;
        }
        
        
        NSString* finishStr = [XHTUIHelper formatByteCount:currentL];
        NSString* totalStr = [XHTUIHelper formatByteCount:totalL];
        NSString* percent = [NSString stringWithFormat:@"%@/%@",finishStr,totalStr];
        app.currentlength = appHis.currentlength;
        app.totallength = appHis.totallength;
        app.progress = percent;
    }
    
    
    
    // 未更新前，需要使用,版本id和版本name。
    app.versionId = appHis.versionId;
    app.versionname = appHis.versionname;
    
    // 若密码又在后台取消了，则不能读取老密码。
    if ([app.password isEqualToString:@"true"]) {
        app.downloadPassword = appHis.downloadPassword;
    }
    
    
    return app;
}


-(BOOL)updateApp:(TakoApp*)app withDownloadPage:(NSArray*)listdata{
    BOOL isExist = NO;
    NSArray* temp = [listdata objectAtIndex:1];
    for (int i=0; i<[temp count]; i++) {
        TakoApp* tempApp = [temp objectAtIndex:i];
        if ([app.versionId isEqualToString:tempApp.versionId]) {
            app = tempApp;
            isExist = YES;
            break;
        }
    }
    return isExist;
}

// 返回NO，可以解决SWSwipeTableCell两侧的扩展按钮，整体出现的问题。
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 允许滑动
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat{
    NSLog(@"ok");
}

-(void)viewWillUnload{
    NSLog(@"test view will unload...");
}

-(void)viewDidUnload{
    NSLog(@"test view did unload...");
}


// clear live object
- (void)dealloc
{
    //    [[AppHisDao share] save];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 增加搜索框
-(void)addSearchBar{
    
    CGRect frame = CGRectMake(0, 0, 200, 28);
    UIView *titleView = [[UIView alloc] initWithFrame:frame];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.backgroundColor;//背景色保持一致
    [titleView setBackgroundColor:color];//
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.frame = frame;
    searchBar.backgroundColor = color;
    [searchBar.layer setBorderColor:[UIColor grayColor].CGColor];//设置边框为白色
    [searchBar.layer setBorderWidth:0.5];
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder  = @"过滤列表中应用";
    searchBar.keyboardType = UIKeyboardAppearanceDefault;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
}

#pragma mark searchbar-delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

#ifdef IS_ADVANCE_SEARCH_ENABLE
    SearchViewController* searchVc = [[SearchViewController alloc] init];
    [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:searchVc animated:YES completion:nil];
#endif

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"search text is %@",searchText);
    int showCount = 0;
    int hideCount = 0;
    for (TakoApp* app in self.listData) {
        if ([searchText isEqualToString:@""]) {
            app.isHidden = NO;
            showCount++;
        }else {
            if ([app.appname containsString:searchText]) {
                app.isHidden = NO;
                            showCount++;
                NSLog(@"appName is:%@",app.appname);
            }else{
                app.isHidden = YES;
                            hideCount++;
            }}
    }
    [self.tableview reloadData];
}




-(void)showMenuView{
    NSLog(@"will show main menu...");
    id rootVc =[[UIApplication sharedApplication].windows objectAtIndex:1].rootViewController;
    NSLog(@"root viewcontroller is:%@",rootVc);
    [rootVc presentMenuViewController];
    
}


-(void)setShowNewDownload:(BOOL)isShow{
    if (isShow) {
        [self.downloadBarItem showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeShake];
    }else{
        [self.downloadBarItem clearBadge];
    }
}


@end
