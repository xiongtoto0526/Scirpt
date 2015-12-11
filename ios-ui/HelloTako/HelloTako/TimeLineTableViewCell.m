//
//  TimeLineTableViewCell.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "UIHelper.h"
@implementation TimeLineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [XHTUIHelper addBorderonButton:self.button];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
