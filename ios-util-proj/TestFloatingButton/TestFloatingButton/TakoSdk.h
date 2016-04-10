//
//  SmartTako.h
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakoSdk : NSObject

+(TakoSdk*)share;
-(UIWindow*) takoSdkInit;
-(void) destoryTakoSdk;

@property (nonatomic,strong) NSMutableArray* subButtons;

@end
