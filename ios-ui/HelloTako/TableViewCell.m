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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
