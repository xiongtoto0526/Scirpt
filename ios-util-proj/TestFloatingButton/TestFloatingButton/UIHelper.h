//
//  UIHelper.h
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define  mainS  [UIScreen mainScreen].bounds.size

@interface UIHelper : NSObject

+(void) addBorderonButton:(UIButton*) btn cornerSize:(int) size;

@end
