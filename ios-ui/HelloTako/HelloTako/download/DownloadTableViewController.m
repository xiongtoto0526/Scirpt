//
//  DownloadTableViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 16/3/5.
//  Copyright © 2016年 熊海涛. All rights reserved.
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
#import "DownloadTableViewController.h"

@interface DownloadTableViewController ()<XHtDownLoadDelegate>

@end


#import "DownloadTableViewController.h"

@interface DownloadTableViewController ()

@end


@implementation DownloadHistoryInfo

@end


@implementation DownloadTableViewController


-(void)receiveLoginBackNotification{
    BOOL isLogined = [XHTUIHelper isLogined];
    [self.tableview setHidden:!isLogined];
    if (isLogined && [self.listData count]==0) {
        [self loadMoreData];
    }
}


-(void)receiveDownloadpageFinishNotification:(NSNotification*)notice{
    NSLog(@"receive download page finish event...");
    // 定位到当前的cell
    NSString* isSuccess = (NSString*)[notice.userInfo objectForKey:DOWNLOAD_RESULT_KEY];
    NSString* tag = (NSString*)[notice.userInfo objectForKey:DOWNLOAD_TAG_KEY];
    
    TakoApp* app = nil;
    TableViewCell* cell = nil;
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
    [self hideProgressUI:YES cell:cell];
    // 更新app
    app.isSuccessed = isSuccess;
}

// 接收到cell的下载按钮点击事件
-(void)receiveClickDownloadNotification:(NSNotification*)notice{
    NSLog(@"receive click download button event...");
    
    // 处理
    if(self.currentApp.isNeedPassword){
        [self showPasswordConfirm];
    }else{
        [self downloadApp];
    }
}


// 接收到cell的取消按钮点击事件
-(void)receiveCancelDownloadNotification:(NSNotification*)notice{
    NSLog(@"receive cancel download button event...");
    
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
        self.currentApp.isStarted=NO;
        self.currentApp.isPaused=NO;
        self.currentApp.isSuccessed=NO;
        self.currentApp.progress = @"当前进度:0%";
        self.currentApp.progressValue=0;
        
        // 停止下载器
        [[XHtDownLoadQueue share] stop:self.currentApp.versionId];
        
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
        [self continueDownload];
    }
    
    // 更新cell
    TableViewCell *cell =  self.currentCell;
    [self hideProgressUI:NO cell:cell];
}

// 是否隐藏下载进度控件
-(void)hideProgressUI:(BOOL)isShow cell:(TableViewCell*)cell{
    [cell.btnCancel setHidden:isShow];
    [cell.progressControl setHidden:isShow];
    [cell.textDownload setHidden:isShow];
}


// 启动下载
-(void)startDownload{
    NSLog(@"will start download...");
    self.currentApp.isPaused = NO;
    self.currentApp.isStarted=YES;
    [self.currentCell.button setTitle:@"暂停" forState:UIControlStateNormal];
    
    /* 添加到下载队列。注：
     1. 下载队列无界，可无限添加，但每次只能有1个（constant.h中可配置梳理）活跃线程下载。允许重复添加（程序会自动识别）。
     2. 当某个应用暂停后，程序会保存当前进度。即使退出应用，下次进入时，仍可继续下。
     3. 参数tag说明: tag 为每个下载记录的唯一标识。
     */
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl appid:self.currentApp.appid password:self.currentApp.downloadPassword tag:self.currentApp.versionId delegate:self];
}


// 继续下载
-(void)continueDownload{
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
    [self hideProgressUI:YES cell:cell];
    // 更新app
    app.progress=@"100%";
    app.isSuccessed=isSuccess;
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
    float prg = (float)finishSize/totalSize;
    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
    
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
    NSString* progress = [NSString stringWithFormat:@"%.1lf",prg*100];
    progress = [NSString stringWithFormat:@"当前进度:%@%%",progress];
    cell.textDownload.text = progress;
    
    // 更新app
    app.progress = progress;
    app.progressValue = prg;
    
}


@end