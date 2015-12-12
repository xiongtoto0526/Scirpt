//
//  TableViewCell.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "TableViewCell.h"
#import "UIHelper.h"
@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [XHTUIHelper addBorderonButton:self.button];
   
    // 隐藏下载栏
    [self.btnCancel setHidden:YES];
    [self.progressControl setHidden:YES];
    [self.textDownload setHidden:YES];
    
    [self.button addTarget:self action:@selector(showDownload) forControlEvents:UIControlEventTouchDown];
    [self.btnCancel addTarget:self action:@selector(stopDownload) forControlEvents:UIControlEventTouchDown];

}


-(void) showDownload{
    
    // 修改下载按钮的文本显示
    [self.button setTitle:@"暂停" forState:UIControlStateNormal];

    // 显示下载栏
    [self.btnCancel setHidden:NO];
    [self.progressControl setHidden:NO];
    [self.textDownload setHidden:NO];
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


@end
