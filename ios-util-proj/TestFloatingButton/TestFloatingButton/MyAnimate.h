//
//  MyAnimate.h
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/9.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface MyAnimate : NSObject

+(MyAnimate*)share;

// 动画接口
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view;


//以下参考：http://blog.csdn.net/mad2man/article/details/17554621
// 翻转
-(void)myRotateforView:(UIView*) view;

// 缩放
-(void)myScaleforView:(UIView*)view;

// 动画取反
-(void)myOppositeforView:(UIView*)view;

// 抖动
-(void)myShakeforView:(UIView*)view;

// 收起，旋转加移动
- (void)myRotateAndMoveforCloseView:(UIView *)view endPoint:(CGPoint)endPoint delegate:(id)delegate;

// 展开，旋转加移动, 注意：endpoint是view结束位置的中心位置
- (void)myRotateAndMoveforOpenView:(UIView *)view endPoint:(CGPoint)endPoint delegate:(id)delegate;

@end
