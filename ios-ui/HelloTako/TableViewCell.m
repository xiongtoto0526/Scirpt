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

@interface TableViewCell()<XHtDownLoadDelegate>
@property BOOL isClicked;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.isClicked=NO;
    [XHTUIHelper addBorderonButton:self.button];
   
    // tableView设置为不可点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 隐藏下载栏
    [self.btnCancel setHidden:YES];
    [self.progressControl setHidden:YES];
    [self.textDownload setHidden:YES];
    
    [self.button addTarget:self action:@selector(showDownload) forControlEvents:UIControlEventTouchDown];
    [self.btnCancel addTarget:self action:@selector(stopDownload) forControlEvents:UIControlEventTouchDown];

}


-(void) showDownload{
    
    if (!self.isClicked) {
        [self startDownload];
      
    }else{
        [self pauseDownload];
    }

    self.isClicked = !self.isClicked;
    // 显示下载栏
    [self.btnCancel setHidden:NO];
    [self.progressControl setHidden:NO];
    [self.textDownload setHidden:NO];
}

// 启动下载
-(void)startDownload{
    NSLog(@"will start download...");
    [self.button setTitle:@"暂停" forState:UIControlStateNormal];    // 修改下载按钮的文本显示
    [[DownloadWorker shareInstance] startWithUrl:[NSURL URLWithString:@"http://han/1/hello.zip"]  delegate:self];
}

// 暂停下载
-(void)pauseDownload{
     NSLog(@"will pause download...");
    [self.button setTitle:@"下载" forState:UIControlStateNormal];
    [[DownloadWorker shareInstance] pause];
}

-(void) stopDownload{
    
    // 弹出确认取消下载提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消下载任务？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"您即将取消本次下载...");
        
        // 恢复下载按钮的文本显示
        [self.button setTitle:@"下载" forState:UIControlStateNormal];
        
        // 隐藏下载栏
        [self.btnCancel setHidden:YES];
        [self.progressControl setHidden:YES];
        [self.textDownload setHidden:YES];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    UIViewController* currentVC = [XHTUIHelper getCurrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark  下载回调

-(void)downloadFinish:(BOOL)isSuccess{
    NSLog(@"收到回调通知：文件下载完成。");
    [self.button setTitle:@"已下载" forState:UIControlStateNormal];    // 修改下载按钮的文本显示
    [self.progressControl setHidden:YES];
    [self.btnCancel setHidden:YES];
    [self.textDownload setHidden:YES];
}

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize{
    double prg = (double)totalSize/finishSize;
    NSLog(@"收到回调通知：当前进度为:%f",prg);
    [self.progressControl setProgress:prg];
}

@end
