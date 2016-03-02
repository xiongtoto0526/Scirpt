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
    if (![ShareEntity shareInstance].isLogined) {
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
    BOOL isLogined = [ShareEntity shareInstance].isLogined;
    [self.tableview setHidden:!isLogined];
    if (isLogined && [self.listData count]==0) {
        [self loadMoreData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.image = [UIImage imageNamed:@"icon_test_unselected"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_test_selected"];
    
    self.listData =[NSMutableArray new];
    
    [self.loginBt setHidden:YES];// 登陆按钮暂不展示。
    
    // 1.添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClickDownloadNotification:) name:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelDownloadNotification:) name:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginBackNotification) name:LOGIN_BACK_TO_TEST_NOTIFICATION object:nil];
    
    
    // 未登录时不显示
    [self.tableview setHidden:![ShareEntity shareInstance].isLogined];
    
    // 初始化刷新控制器
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataWhenRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // 隐藏刷新按钮
    [self.refreshControl endRefreshing];
    
    // 添加refresh
    [self.tableview addSubview:self.refreshControl];
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"fTablecell"];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    if ([ShareEntity shareInstance].isLogined) {
        [self loadMoreData];
    }
    
}



-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    self.currentCell = cell;
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [self.listData objectAtIndex:row];
    self.currentApp = app;
    
    if(app.isNeedPassword){
        [self showPasswordConfirm];
    }else{
        [self downloadApp];
    }
}



-(void)receiveCancelDownloadNotification:(NSNotification*)notice{
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    self.currentCell = cell;
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [self.listData objectAtIndex:row];
    self.currentApp = app;
    
    // 弹出确认取消下载提示框
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
        self.currentApp.downloadPassword = password.text;
        if (self.currentApp.downloadPassword==nil) {
            NSLog(@"下载密码无效。");
            [XHTUIHelper alertWithNoChoice:@"下载密码不能为空!" view:[XHTUIHelper getCurrentVC]];
            return;
        }
        [self downloadApp];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入下载密码";
        textField.secureTextEntry = YES;
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    UIViewController* currentVC = [XHTUIHelper getCurrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
    
    
}


-(void)downloadApp{
    
    self.currentApp.downloadUrl = [TakoServer fetchDownloadUrl:self.currentApp.versionId password:self.currentApp.downloadPassword];
    if (self.currentApp.downloadUrl==nil) {
        NSLog(@"get downloadurl failed...");
        [XHTUIHelper alertWithNoChoice:@"下载密码不正确!" view:[XHTUIHelper getCurrentVC]];
        return;
    }
    
    NSLog(@"will download from :%@",self.currentApp.downloadUrl);
    if (!self.currentApp.isStarted) {
        [self startDownload];
    }else if(!self.currentApp.isPaused){
        [self pauseDownload];
    }else{
        [self countinueDownload];
    }
    
    // 显示下载栏.todo:是否可正常显示？
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
    [self.currentCell.button setTitle:@"暂停" forState:UIControlStateNormal];    // 修改下载按钮的文本显示
    
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl appid:self.currentApp.appid tag:self.currentApp.versionId delegate:self];
}


// 继续下载
-(void)countinueDownload{
    NSLog(@"will pause download...");
    [self.currentCell.button setTitle:@"暂停" forState:UIControlStateNormal];
    self.currentApp.isPaused = NO;
    [[XHtDownLoadQueue share] add:@"http://1.zip" appid:self.currentApp.appid tag:self.currentApp.versionId delegate:self];
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
    // 1.添加假数据
    NSArray* newdata = [self fetchDataFromServer];
    
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

-(BOOL)checkIsLogin{
    return [ShareEntity shareInstance].isLogined;
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
    
    static NSString *CellIdentifier = @"fTablecell";
    TableViewCell *tbCell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell==nil) {
        tbCell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
    // 记录index todo: 设置无效
    tbCell.tag = indexPath.row;
    NSLog(@"tag is:%ld",(long)tbCell.tag);
    
    
    // 数据绑定
    TakoApp* app = (TakoApp*)[self.listData objectAtIndex:indexPath.row];
    tbCell.appName.text=app.appname;
    tbCell.appVersion.text = app.version;
    tbCell.otherInfo.text = [NSString stringWithFormat:@"%@  %@",app.firstcreated,app.size];
    
    UIImage* image = nil;
    if(app.logourl==nil || app.logourl.length==0){    // app没有logo时，显示默认logo
        image = [UIImage imageNamed:@"ic_defaultapp"];
    }else{
        // todo: 使用 sdwebimage 优化速度
        if(tbCell.appImage.image==nil){
            NSURL *url = [NSURL URLWithString: app.logourl];
            image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        }
    }
    tbCell.appImage.image = image;
    
    if ([self isAppDownloadedBefore:app.versionId]) {
        NSLog(@"重复应用信息,名称，%@，版本，%@",tbCell.appName.text,app.versionId);
        [tbCell.button setTitle:@"已下载" forState:UIControlStateNormal];
        [tbCell.button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
        tbCell.button.enabled = NO;
    }
    
    return tbCell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


-(BOOL)isAppDownloadedBefore:(NSString*) versionId{
    BOOL isExist = NO;
    NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_KEY];
    for (NSString *key in downloadAppDict) {
        //        NSLog(@"dict key: %@ value: %@", key, downloadAppDict[key]);
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

-(void) showDownload:(TableViewCell*) cell{
    // 显示下载栏
    [cell.btnCancel setHidden:NO];
    [cell.progressControl setHidden:NO];
    [cell.textDownload setHidden:NO];
}



-(IBAction) gotoLoginView:(id)sender{
    [self presentViewController:[LoginViewController new] animated:NO completion:^{
        NSLog(@"enter login view");
    }];
}


- (void)reloadDataWhenRefresh
{
    // Reload table data
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

-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
    NSLog(@"收到回调通知：文件下载完成。");
    
    if ([tag isEqualToString:self.currentApp.versionId]) {
        // todo: 可抽取为公共方法。
        if (isSuccess) {
            [self.currentCell.button setTitle:@"已下载" forState:UIControlStateNormal];
            [self.currentCell.button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
            self.currentCell.button.enabled = NO;
            
            // 记录已下载情况
            NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_KEY];
            if (downloadAppDict==nil) {
                downloadAppDict = [NSMutableDictionary new];
            }
            NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:downloadAppDict];
            [newDict setValue:@"1" forKey:self.currentApp.versionId];
            [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_KEY withObject:newDict];
            
        }else{
            [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
            [self.currentCell.button setTitle:@"重下载" forState:UIControlStateNormal];
            self.currentApp.isStarted=NO;
        }
        
        
        [self.currentCell.progressControl setHidden:YES];
        [self.currentCell.btnCancel setHidden:YES];
        [self.currentCell.textDownload setHidden:YES];
    }
}

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
    float prg = (float)finishSize/totalSize;
    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    
    // 仅刷新匹配的行
    if ([tag isEqualToString:self.currentApp.versionId]) {
        [self.currentCell.progressControl setProgress:prg];
        NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
        self.currentCell.textDownload.text = [NSString stringWithFormat:@"当前进度:%@%%",progress];
    }
}


@end
