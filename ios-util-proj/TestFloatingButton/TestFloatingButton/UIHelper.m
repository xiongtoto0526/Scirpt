//
//  UIHelper.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+(void) addBorderonButton:(UIButton*) btn cornerSize:(int) size{
    UIColor* systemBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    btn.layer.borderColor = systemBlue.CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = size;
}


@end

