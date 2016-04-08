//
//  TimeLineTableViewCell.m
//  Tako
//
//  Created by 熊海涛 on 16/3/29.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "Constant.h"
#import "UIHelper.h"



@implementation TimeLineTableViewCell


- (void)awakeFromNib {
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [XHTUIHelper addBorderonButton:self.downloadButton cornerSize:4];
    [XHTUIHelper addBorderonButton:self.moreButton cornerSize:4];
    self.moreButton.layer.borderWidth = 0;
    
    [self.downloadButton addTarget:self action:@selector(clickDownloadButton:) forControlEvents:UIControlEventTouchDown];
    [self.moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchDown];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





-(void)clickDownloadButton:(UIButton*)button{
    NSLog(@"clicked...tag is:%ld",(long)button.tag);
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:self forKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:CLICK_DETAIL_DOWNLOAD_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


-(void)clickMoreButton:(UIButton*)button{
    NSLog(@"clicked...tag is:%ld",(long)button.tag);
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:self forKey:CELL_INDEX_NOTIFICATION_KEY];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:CLICK_MORE_BUTTON_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
