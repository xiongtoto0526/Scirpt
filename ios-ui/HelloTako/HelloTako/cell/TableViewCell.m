//
//  TableViewCell.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "TableViewCell.h"
#import "UIHelper.h"
#import "DownloadWorker.h"
#import "Constant.h"
//#import "RequestQueue.h"
#import "DownloadQueue.h"
#import "Server.h"

@interface TableViewCell()

@end



NSMutableDictionary* workerDict = nil;

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code

    [XHTUIHelper addBorderonButton:self.button];
    
    // tableView设置为不可点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // 隐藏下载栏
    [self.btnCancel setHidden:YES];
    [self.progressControl setHidden:YES];
    [self.textDownload setHidden:YES];
    

    [self.button addTarget:self action:@selector(clickDownload) forControlEvents:UIControlEventTouchDown];
    [self.btnCancel addTarget:self action:@selector(stopDownload) forControlEvents:UIControlEventTouchDown];
    // t:不能再此处动态设置cell，应该在tableview的 willDisplayCell 回调中处理。
}


-(void) clickDownload{
    NSLog(@"self.tag is:",self.tag);
    
    TableViewCell *cell = (TableViewCell*)[[self.button superview] superview];
//    NSIndexPath *indexPath = [_myTableView indexPathForCell:cell];
//    NSLog(@"indexPath is = %i",indexPath.row);

    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:cell forKey:CELL_INDEX_NOTIFICATION_KEY];
//    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:CELL_INDEX_NOTIFICATION_KEY,cell, nil];
    NSNotification *notification =[NSNotification notificationWithName:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    if(self.isNeedPassword){
//        [self showPasswordConfirm];
//    }else{
//        [self downloadApp];
//    }
}
//
//// 启动下载
//-(void)startDownload{
//    NSLog(@"will start download...");
//    self.isPaused = NO;
//    self.isStarted=YES;
//    [self.button setTitle:@"暂停" forState:UIControlStateNormal];    // 修改下载按钮的文本显示
//    
//    [[XHtDownLoadQueue share] add:self.downloadUrl appid:self.appId tag:self.versionId delegate:self];
//}
//
//
//// 继续下载
//-(void)countinueDownload{
//    NSLog(@"will pause download...");
//    [self.button setTitle:@"暂停" forState:UIControlStateNormal];
//    self.isPaused = NO;
//    [[XHtDownLoadQueue share] add:@"http://1.zip" appid:self.appId tag:self.versionId delegate:self];
//}
//
//-(void)showPasswordConfirm{
//    
//    // 弹出确认取消下载提示框
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要输入下载密码。" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"您取消了本次下载...");
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"密码已输入...");
//        UITextField *password = alertController.textFields.firstObject;
//        NSLog(@"download password is: %@",password.text);
//        self.downloadPassword = password.text;
//        if (self.downloadPassword==nil) {
//            NSLog(@"下载密码无效。");
//            [XHTUIHelper alertWithNoChoice:@"下载密码不能为空!" view:[XHTUIHelper getCurrentVC]];
//            return;
//        }
//        [self downloadApp];
//        
//    }];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
//        textField.placeholder = @"请输入下载密码";
//        textField.secureTextEntry = YES;
//    }];
//    
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    UIViewController* currentVC = [XHTUIHelper getCurrentVC];
//    [currentVC presentViewController:alertController animated:YES completion:nil];
//    
//    
//}

//
//
//// 暂停下载
//-(void)pauseDownload{
//    NSLog(@"will pause download...");
//    [self.button setTitle:@"继续" forState:UIControlStateNormal];
//    self.isPaused = YES;
//    [[XHtDownLoadQueue share] pause:self.appId];
//}

// 停止下载
-(void) stopDownload{
    TableViewCell *cell = (TableViewCell*)[[self.button superview] superview];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:CELL_INDEX_NOTIFICATION_KEY,cell, nil];
    NSNotification *notification =[NSNotification notificationWithName:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    
//    // 弹出确认取消下载提示框
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消下载任务？" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"您即将取消本次下载...");
//        
//        // 恢复下载按钮的文本显示
//        [self.button setTitle:@"下载" forState:UIControlStateNormal];
//        
//        // 隐藏下载栏
//        [self.btnCancel setHidden:YES];
//        [self.progressControl setProgress:0];
//        [self.progressControl setHidden:YES];
//        [self.textDownload setHidden:YES];
//        self.isStarted=NO;
//        
//        // 停止下载器
//        [[XHtDownLoadQueue share] stop:self.appId];
//        
//    }];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    UIViewController* currentVC = [XHTUIHelper getCurrentVC];
//    [currentVC presentViewController:alertController animated:YES completion:nil];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//
//#pragma mark  下载回调
//
//-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString *)tag{
//    NSLog(@"收到回调通知：文件下载完成。");
//    
//    if ([tag isEqualToString:self.versionId]) {
//        // todo: 可抽取为公共方法。
//        if (isSuccess) {
//            [self.button setTitle:@"已下载" forState:UIControlStateNormal];
//            [self.button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
//            self.button.enabled = NO;
//            
//            // 记录已下载情况
//            NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_KEY];
//            if (downloadAppDict==nil) {
//                downloadAppDict = [NSMutableDictionary new];
//            }
//            NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:downloadAppDict];
//            [newDict setValue:@"1" forKey:self.versionId];
//            [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_KEY withObject:newDict];
//            
//        }else{
//            [XHTUIHelper alertWithNoChoice:[NSString stringWithFormat:@"下载失败:%@",msg] view:[XHTUIHelper getCurrentVC]];
//            [self.button setTitle:@"重下载" forState:UIControlStateNormal];
//            self.isStarted=NO;
//        }
//        
//        
//        [self.progressControl setHidden:YES];
//        [self.btnCancel setHidden:YES];
//        [self.textDownload setHidden:YES];
//    }
//}
//
//-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString *)tag{
//    float prg = (float)finishSize/totalSize;
//    NSLog(@"收到回调通知：当前进度为:%f,tag:%@",prg,tag);
//    
//    // 仅刷新匹配的行
//    if ([tag isEqualToString:self.versionId]) {
//        [self.progressControl setProgress:prg];
//        self.progress = [NSString stringWithFormat:@"%.1lf",prg*100];
//        self.textDownload.text = [NSString stringWithFormat:@"当前进度:%@%%",self.progress];
//    }
//}

@end
