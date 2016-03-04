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

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate>
@property TableViewCell* currentCell;
@property  NSMutableArray* sectionTitleArray;
@property  NSMutableArray* listData;
@property TakoApp* currentApp;
@end



@interface DownloadHistoryInfo : NSObject
@property (nonatomic,copy) NSString* currentLength;
@property (nonatomic,copy) NSString* TotalLength;
@property (nonatomic,copy) NSString* status;
@property (nonatomic,copy) NSString* appid;
@property (nonatomic,copy) NSString* password;
@end

@implementation DownloadHistoryInfo

@end


@implementation DownloadViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
        
        TakoApp* app = [TakoServer fetchAppWithid:info.appid];
        //        app = (float)info.currentLength/info.TotalLength;
        
        int status = [info.status intValue];
        if (status == DOWNLOAD_FINISH_SUCCESS) {
            [downloadedList addObject:app];
        }else if(status == DOWNLOAD_START || status == DOWNLOAD_PAUSE){
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
    
    if (app.isSuccessed) {
        NSLog(@"重复应用信息,名称，%@，版本，%@",cell.appName.text,app.versionId);
        [XHTUIHelper disableDownloadButton:cell.button];
    }else if (app.isPaused) {
        [cell.button setTitle:@"继续" forState:UIControlStateNormal];
        [self hideProgressUI:NO cell:cell];
    }else if (app.isStarted) {
        [cell.button setTitle:@"暂停" forState:UIControlStateNormal];
        [self hideProgressUI:NO cell:cell];
    }
    
    return cell;
}

// 单元格选中时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0 && indexPath.row==0){
        NSLog(@"即将进入“下载”页面...");
        
        
    }else if(indexPath.section==0 && indexPath.row==1){
        NSLog(@"即将进入“退出登录”页面...");
    }
}

-(UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma to be refactor

// 接收到cell的下载按钮点击事件
-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    NSLog(@"receive click download button event...");
    
    // 定位到当前的cell
    TableViewCell* cell = (TableViewCell*)[notice.userInfo objectForKey:CELL_INDEX_NOTIFICATION_KEY];
    NSInteger section = [self.tableview indexPathForCell:cell].section;
    // todo: 需从监听发送处增加参数，以识别是否源于该viewcontroller.
    if(section == 0){
        return;
    }
    
    
    self.currentCell = cell;
   
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [(NSArray*)[self.listData objectAtIndex:section] objectAtIndex:row];
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
    NSInteger section = [self.tableview indexPathForCell:cell].section;
    
    // todo: 需从监听发送处增加参数，以识别是否源于该viewcontroller.
    if(section == 0){
        return;
    }
    
    self.currentCell = cell;
    NSInteger row = [self.tableview indexPathForCell:cell].row;
    TakoApp* app = [(NSArray*)[self.listData objectAtIndex:section] objectAtIndex:row];
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
    [[XHtDownLoadQueue share] pause:self.currentApp.versionId];
}


// 是否隐藏下载进度控件
-(void)hideProgressUI:(BOOL)isShow cell:(TableViewCell*)cell{
    [cell.btnCancel setHidden:isShow];
    [cell.progressControl setHidden:isShow];
    [cell.textDownload setHidden:isShow];
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
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:DOWNLAOD_MANAGE_PAGE_FINISH_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
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
        TakoApp* app = (TakoApp*)[cellList objectAtIndex:i];
        if ([app.versionId isEqualToString:tag]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
            cell = [self.tableview cellForRowAtIndexPath:path];
            break;
        }
    }
    
    // 更新cell
    [cell.progressControl setProgress:prg];
    NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
    cell.textDownload.text = [NSString stringWithFormat:@"当前进度:%@%%",progress];
    
    // 更新app
    app.progress = progress;
}

@end
