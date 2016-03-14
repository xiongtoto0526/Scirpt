//
//  TableViewCell.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "TableViewCell.h"
#import "UIHelper.h"
#import "Constant.h"

@interface TableViewCell()

@end



NSMutableDictionary* workerDict = nil;

@implementation TableViewCell

- (void)awakeFromNib {

    // button圆角化
    [XHTUIHelper addBorderonButton:self.button];
    
    // tableView设置为不可点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 隐藏下载栏
    [self.btnCancel setHidden:YES];
    [self.progressControl setHidden:YES];
    [self.textDownload setHidden:YES];
    
    self.downloadSpeed.text = @"";
    [self.button addTarget:self action:@selector(clickDownload) forControlEvents:UIControlEventTouchDown];
    [self.btnCancel addTarget:self action:@selector(stopDownload) forControlEvents:UIControlEventTouchDown];
}


-(void) clickDownload{
    
    // 获取到button对应的cell
//    TableViewCell *cell = (TableViewCell*)[[self.button superview] superview];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:self forKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:CLICK_DOWNLOAD_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

// 停止下载
-(void) stopDownload{
    
    // 获取到button对应的cell
//    TableViewCell *cell = (TableViewCell*)[[self.button superview] superview];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:self forKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
