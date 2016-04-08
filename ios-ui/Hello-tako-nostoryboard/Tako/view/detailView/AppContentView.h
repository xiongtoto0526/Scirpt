//
//  AppContentView.h
//  Tako
//
//  Created by 熊海涛 on 16/3/29.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppContentView : UIView

-(id)initWithFrame:(CGRect)frame content:(NSString*)contentText;

@property (nonatomic,copy)NSString* textContent;

@end
