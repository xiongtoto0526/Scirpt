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
#import "SharedInstallManager.h"
#import "InstallingModel.h"
#import "DownloadTableViewController.h"

@interface DownloadTableViewController ()<XHtDownLoadDelegate,XHTInstallProgressDelegate>
@property (nonatomic,strong) NSTimer* timer;
@end


@implementation DownloadHistoryInfo

@end


@implementation DownloadTableViewController



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
        [self hideProgressUI:YES cell:cell];
        [cell.progressControl setProgress:0];
        if (self.currentApp.isNeedUpdate) {
            self.currentApp.status = TOBE_UPDATE;
        }else{
            self.currentApp.status = INITED;
        }
        [self updateApp:self.currentApp cell:self.currentCell status:self.currentApp.status];
        self.currentApp.progress = @"0%";
        self.currentApp.progressValue=0;
        
        // 停止下载器
        [[XHtDownLoadQueue share] stop:self.currentApp.appid];
        
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
    
    if (self.currentApp.status == INSTALLING) {
        NSLog(@"app is installing ,please wait...");
        [XHTUIHelper alertWithNoChoice:@"正在安装请等待..." view:self];
        return;
    }
    
    if (self.currentApp.downloadUrl == nil) {
        self.currentApp.downloadUrl = [TakoServer fetchDownloadUrl:self.currentApp.versionId password:self.currentApp.downloadPassword];
    }
    
    if (self.currentApp.downloadUrl==nil) {
        NSLog(@"get downloadurl failed...");
        [XHTUIHelper alertWithNoChoice:@"下载密码不正确!" view:self];
        return;
    }
    
    NSLog(@"password is ok, will download from :%@",self.currentApp.downloadUrl);
    
    
    switch (self.currentApp.status) {
            
        case INITED:
            [self startDownload];
            break;
        case DOWNLOADED:
            [self beginInstall];
            break;
        case DOWNLOADED_FAILED:
            [self startDownload];
            break;
        case STARTED:
            [self pauseDownload];
            break;
        case PAUSED:
            [self continueDownload];
            break;
        case INSTALL_FAILED:
            [self beginInstall];
            break;
        case TOBE_UPDATE:
            [self startDownload];
            break;
            
        default:
            break;
    }
    
    [self updateApp:self.currentApp cell:self.currentCell status:self.currentApp.status];
    
}

-(void)beginInstall{

    // 开启线程监控。
    [SharedInstallManager shareInstWithdelegate:self];
    NSString* itermServiceUrl = [TakoServer fetchItermUrl:self.currentApp.versionId password:self.currentApp.downloadPassword];
    NSLog(@"will install,iterm url is:%@",itermServiceUrl);
    NSString* testFile = [NSString stringWithFormat:@"%@.ipa",self.currentApp.versionId];
    BOOL isFileReady = [XHTUIHelper isDevicefileExist:testFile];
    NSString* testUrl = [NSString stringWithFormat:@"%@:%d/%@",[XHTUIHelper localIPAddress],HTTP_SERVER_PORT,testFile];
    if (isFileReady) {
        NSLog(@"file is ready ,will install...try the test url in browse:%@",testUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itermServiceUrl]];
        [XHTUIHelper alertWithNoChoice:@"安装已启动,可在桌面查看安装进度~" view:self];
    }else{
        NSString* testUrl = [NSString stringWithFormat:@"http://%@:%d/%@",[XHTUIHelper localIPAddress],HTTP_SERVER_PORT,testFile];
        NSLog(@"File is not ready ,maybe you should download again...,try the test url in browse:%@",testUrl);
        [self updateApp:self.currentApp cell:self.currentCell status:INITED];
        [self saveCurrentAppStatus:INITED tag:self.currentApp.appid];
        [XHTUIHelper alertWithNoChoice:@"安装文件无效，请重新下载~" view:self];
    }
    
}

// 是否隐藏下载进度控件
-(void)hideProgressUI:(BOOL)isHide cell:(TableViewCell*)cell{
    [cell.btnCancel setHidden:isHide];
    [cell.progressControl setHidden:isHide];
    [cell.textDownload setHidden:isHide];
    [cell.appVersion setHidden:!isHide];
    [cell.otherInfo setHidden:!isHide];
    [cell.downloadSpeed setHidden:isHide];
}


// 启动下载
-(void)startDownload{
    NSLog(@"will start download...");
    self.currentApp.status=STARTED;
    
    // 首次下载，保存app信息。
    
    
    /* 添加到下载队列。注：
     1. 下载队列无界，可无限添加，但每次只能有1个（constant.h中可配置梳理）活跃线程下载。允许重复添加（程序会自动识别）。
     2. 当某个应用暂停后，程序会保存当前进度。即使退出应用，下次进入时，仍可继续下。
     3. 参数tag说明: tag 为每个下载记录的唯一标识。
     */
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl versionid:self.currentApp.versionId password:self.currentApp.downloadPassword tag:self.currentApp.appid delegate:self];
}


// 继续下载
-(void)continueDownload{
    NSLog(@"will continue download...");
    self.currentApp.status = STARTED;
    [[XHtDownLoadQueue share] add:self.currentApp.downloadUrl versionid:self.currentApp.versionId password:self.currentApp.downloadPassword tag:self.currentApp.appid delegate:self];
}



// 暂停下载
-(void)pauseDownload{
    NSLog(@"will pause download...");
    self.currentApp.status = PAUSED;
    [[XHtDownLoadQueue share] pause:self.currentApp.appid];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark  下载回调
// 下载结束回调
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
    NSLog(@"empty impliment...");
}


// 下载进度回调
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize speed:(NSString *)speed tag:(NSString *)tag{
    NSLog(@"empty impliment...");
}


// 通过bundleid找到对应的index
-(NSInteger)cellIndexWithbundleId:(NSString*)bundleId{
    NSMutableArray* apps = self.listData;
    TakoApp* updateApp = nil;
    for (TakoApp* app in apps) {
        if ([app.bundleid isEqualToString:bundleId]) {
            // updateApp 逻辑上不可能为空
            updateApp = app;
            break;
        }
    }
    if (updateApp == nil) {
        // 原来就存在无法安装的应用，忽略。
        return -1;
    }
    
    return (NSInteger)[apps indexOfObject:updateApp];
}


#pragma mark 安装进度监听

// 安装完成
-(void) finishInstall:(NSArray*)models{

    TableViewCell* updateCell = nil;
    TakoApp* updateApp = nil;
    for (InstallingModel* model in models) {
        // updateCell,updateApp 逻辑上不可能为空
        NSInteger cellIndex = [self cellIndexWithbundleId:model.bundleID];
        if (cellIndex == -1) {
            return ;
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        updateCell = [self.tableview cellForRowAtIndexPath:path];
        updateApp = [self.listData objectAtIndex:cellIndex];
        NSLog(@"app %@ install finished",updateApp.appname);
        
        // 有一种错误可能，从downloaded状态直接进来。在此过滤掉。
        if (updateApp.status == INSTALLING) {
            [updateCell.button setTitle:@"已安装" forState:UIControlStateNormal];
            [XHTUIHelper disableDownloadButton:updateCell.button];
            updateApp.status = INSTALLED;
            [self saveCurrentAppStatus:INSTALLED tag:updateApp.appid];
        }
    }
    
}

-(void)failedInstall:(NSArray *)models{
    TableViewCell* updateCell = nil;
    TakoApp* updateApp = nil;
    for (InstallingModel* model in models) {
        
        // updateCell,updateApp 逻辑上不可能为空
        NSInteger cellIndex = [self cellIndexWithbundleId:model.bundleID];
        if (cellIndex == -1) {
            continue ;
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        updateCell = [self.tableview cellForRowAtIndexPath:path];
        updateApp = [self.listData objectAtIndex:cellIndex];
        updateApp.installProgress = @"0%";
        NSLog(@"app %@ install failed...",updateApp.appname);
        updateApp.status = INSTALL_FAILED;
//        [self saveCurrentAppStatus:INSTALL_FAILED tag:updateApp.appid];
        [self updateApp:updateApp cell:updateCell status:INSTALL_FAILED];
    }

}

// 安装进度更新
-(void) currentInstallProgress:(NSArray*)models{
    TableViewCell* updateCell = nil;
    TakoApp* updateApp = nil;
    for (InstallingModel* model in models) {
        
        // updateCell,updateApp 逻辑上不可能为空
        NSInteger cellIndex = [self cellIndexWithbundleId:model.bundleID];
        if (cellIndex == -1) {
            continue ;
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        updateCell = [self.tableview cellForRowAtIndexPath:path];
        updateApp = [self.listData objectAtIndex:cellIndex];
        updateApp.installProgress = model.progress;
        NSLog(@"app %@ install progress update,new install progress is:%@",updateApp.appname,updateApp.installProgress);
        
//        NSString* newTitle = [NSString stringWithFormat:@"安装中 %@",updateApp.progress];
//        [updateCell.button setTitle:newTitle forState:UIControlStateNormal];
        [updateCell.button setTitle:@"安装中" forState:UIControlStateNormal];
        updateApp.status = INSTALLING;
    }
}

// 安装开始
-(void) newInstall:(NSArray*)models{
    TableViewCell* updateCell = nil;
    TakoApp* updateApp = nil;
    for (InstallingModel* model in models) {
        // updateCell,updateApp 逻辑上不可能为空
        NSInteger cellIndex = [self cellIndexWithbundleId:model.bundleID];
        if (cellIndex == -1) {
            return ;
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        updateCell = [self.tableview cellForRowAtIndexPath:path];
        updateApp = [self.listData objectAtIndex:cellIndex];
        NSLog(@"app %@ install begin...",updateApp.appname);
        
        updateApp.status = INSTALLING;
        [updateCell.button setTitle:@"安装中" forState:UIControlStateNormal];
        updateApp.installProgress = model.progress;
        [self saveCurrentAppStatus:INSTALLING tag:updateApp.appid];
    }
}


// 根据app的执行状态动态更新cell和数据源
-(void)updateApp:(TakoApp*)app cell:(TableViewCell*)cell status:(enum APPSTATUS)status{
    
    app.status = status;
    switch (status) {
        case INITED:
            NSLog(@"app is in init status...");
            app.progress=@"0%";
            [cell.button setTitle:@"下载" forState:UIControlStateNormal];
            break;
        case STARTED:
            NSLog(@"app is in start status...");
            [cell.button setTitle:@"暂停" forState:UIControlStateNormal];
            [self hideProgressUI:NO cell:cell];
            break;
        case PAUSED:
            NSLog(@"app is in pause status...");
            [cell.button setTitle:@"继续" forState:UIControlStateNormal];
            [self hideProgressUI:NO cell:cell];
            break;
        case DOWNLOADED:
            NSLog(@"app is in downloaded status...");
            app.progress=@"100%";
            [cell.button setTitle:@"安装" forState:UIControlStateNormal];
            [self hideProgressUI:YES cell:cell];
            break;
        case DOWNLOADED_FAILED:
            NSLog(@"app is in downloaded failed status...");
            app.progress=@"0%";
            [cell.button setTitle:@"重下载" forState:UIControlStateNormal];
            [self hideProgressUI:YES cell:cell];
            break;
        case INSTALLING:
            NSLog(@"app is in installing status...");
            [cell.button setTitle:@"安装中" forState:UIControlStateNormal];
            [self hideProgressUI:YES cell:cell];
            break;
        case INSTALLED:
            NSLog(@"app is in installed status...");
            [cell.button setTitle:@"已安装" forState:UIControlStateNormal];
            [XHTUIHelper disableDownloadButton:cell.button];
            [self hideProgressUI:YES cell:cell];
            break;
        case INSTALL_FAILED:
            NSLog(@"app is in installed failed status...");
            [cell.button setTitle:@"安装失败" forState:UIControlStateNormal];
            [self hideProgressUI:YES cell:cell];
            [XHTUIHelper disableDownloadButton:cell.button];
            break;
        case TOBE_UPDATE:
            NSLog(@"app is in to-be-update status...");
            [cell.button setTitle:@"更新" forState:UIControlStateNormal];
            [self hideProgressUI:YES cell:cell];
            break;
            
        default:
            break;
    }
}



// 更新当前app的状态,记录到userdefault。
-(void)saveCurrentAppStatus:(int) status tag:(NSString*)tag{
    
    NSDictionary* oldCurrent =nil;
    NSMutableDictionary* newCurrent =nil;
    NSMutableDictionary* newDict = nil;
    NSDictionary* oldDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    
    if (oldDict==nil) {
        newDict = [NSMutableDictionary new];
    }else{
        newDict = [NSMutableDictionary dictionaryWithDictionary:oldDict];
    }
    
    oldCurrent =[newDict objectForKey:tag];
    if (oldCurrent==nil) {
        newCurrent = [NSMutableDictionary new];
    }else{
        newCurrent = [NSMutableDictionary dictionaryWithDictionary:oldCurrent];
    }
    
    NSString* statusStr = [NSString stringWithFormat:@"%d",status];
    [newCurrent setObject:statusStr forKey:DOWNLOAD_STATUS_KEY];
    
    [newDict setValue:newCurrent forKey:tag];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:newDict];
}


-(void)receiveDownloadProgressNotification:(NSNotification*)notice{
    
    // 定位到当前的cell
    NSString* totalSize = (NSString*)[notice.userInfo objectForKey:@"totalSize"];
    long long totalSizeLong = [totalSize longLongValue];
    NSString* finishSize = (NSString*)[notice.userInfo objectForKey:@"finishSize"];
    long long finishSizeLong = [finishSize longLongValue];
    NSString* tag = (NSString*)[notice.userInfo objectForKey:@"tag"];
    NSString* speed = (NSString*)[notice.userInfo objectForKey:@"speed"];
    [self downloadingWithTotal:totalSizeLong complete:finishSizeLong speed:speed tag:tag];
}


-(void)receiveDownloadFinishNotification:(NSNotification*)notice{
    // 定位到当前的cell
    NSString* isSuccess = (NSString*)[notice.userInfo objectForKey:@"isSuccess"];
    BOOL isSuccessBool = [isSuccess isEqualToString:@"1"]?YES:NO;
    NSString* msg = (NSString*)[notice.userInfo objectForKey:@"msg"];
    NSString* tag = (NSString*)[notice.userInfo objectForKey:@"tag"];
    [self downloadFinish:isSuccessBool msg:msg tag:tag];
}

@end