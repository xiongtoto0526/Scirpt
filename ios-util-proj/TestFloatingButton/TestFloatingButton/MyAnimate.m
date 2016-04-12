//
//  MyAnimate.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/9.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "MyAnimate.h"


#define duration_x  0.3f
static MyAnimate* shareAnimate = nil;

@implementation MyAnimate

+(MyAnimate*)share{
    if (shareAnimate ==nil) {
        shareAnimate = [[MyAnimate alloc] init];
    }
    return shareAnimate;
}

#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 2;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}
//

-(void)myRotateforView:(UIView*) view{
    //创建一个CGAffineTransform  transform对象
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(view.transform,M_PI/6.0);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:2];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [view setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}

-(void)myScaleforView:(UIView*)view{
    CGAffineTransform  transform;
    transform = CGAffineTransformScale(view.transform,1.2,1.2);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    [view setTransform:transform];
    [UIView commitAnimations];
}

-(void)myOppositeforView:(UIView*)view{
    CGAffineTransform transform;
    transform=CGAffineTransformInvert(view.transform);
    
    [UIView beginAnimations:@"Invert" context:nil];
    [UIView setAnimationDuration:2];//动画时常
    [UIView setAnimationDelegate:self];
    [view setTransform:transform];//获取改变后的view的transform
    [UIView commitAnimations];//关闭动画
}


-(void)myShakeforView:(UIView*)view{
    CGFloat t =5.0;
    
    // 上下抖动
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, 0,t);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-t);
    //    // 左右抖动
    //    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0);
    //    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    view.transform = translateLeft;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAutoreverse animations:^{
        view.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

// 展开
- (void)myRotateAndMoveforOpenView:(UIView *)view endPoint:(CGPoint)endPoint buffer:(int)buffer delegate:(id)delegate{

    // 需要加上圆的半径
    float ext_x = view.frame.size.width/2;
    float ext_y = view.frame.size.width/2;
    
    float end_y_center = endPoint.y+ext_y;
    CGPoint original = view.center;
//    NSLog(@"original x is:%f",original.x);
    CGPoint endPoint2 = CGPointMake(original.x, end_y_center);
    CGPoint farPoint = CGPointMake(original.x, end_y_center+buffer);// 5 为摇晃时的幅度
    CGPoint nearPoint = CGPointMake(original.x, end_y_center-buffer);// 5 为摇晃时的幅度
    
    
    // bug1: 需要在point中x，y 方向分别增加 半径个像素。
    CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint2
                                                            andFarPoint:farPoint
                                                           andNearPoint:nearPoint originalPoint:original delegate:delegate];
    // @"bloomAnimation" 仅是一个唯一标示
    [view.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];

    // 注意: 需要在动画结束后再将view,移动到这个最终位置。
    view.frame  = CGRectMake(0,  endPoint.y, view.frame.size.width, view.frame.size.height);
}



// 收起
- (void)myRotateAndMoveforCloseView:(UIView *)view endPoint:(CGPoint)endPoint buffer:(int)buffer delegate:(id)delegate{
    // 需要加上圆的半径
    float ext_x = view.frame.size.width/2;
    float ext_y = view.frame.size.width/2;
    
    float end_y_center = endPoint.y+ext_y;
    CGPoint original = view.center;
    CGPoint endPoint2 = CGPointMake(original.x, end_y_center);
    CGPoint farPoint = CGPointMake(original.x, end_y_center+buffer);// buffer 为摇晃时的幅度
    CGPoint nearPoint = CGPointMake(original.x, end_y_center-buffer);// buffer 为摇晃时的幅度
    
    
    // bug1: 需要在point中x，y 方向分别增加 半径个像素。
    CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint2
                                                            andFarPoint:farPoint
                                                           andNearPoint:nearPoint originalPoint:original delegate:delegate];
    // @"debloomAnimation" 仅是一个唯一标示
    [view.layer addAnimation:bloomAnimation forKey:@"debloomAnimation"];
    
    // 注意: 需要在动画结束后再将view,移动到这个最终位置。
    view.frame  = CGRectMake(0, endPoint.y, view.frame.size.width, view.frame.size.height);
}


- (CAAnimationGroup *)bloomAnimationWithEndPoint:(CGPoint)endPoint andFarPoint:(CGPoint)farPoint andNearPoint:(CGPoint)nearPoint originalPoint:(CGPoint)original delegate:(id)delegate
{
    // 1.Configure rotation animation
    //
    float duration = duration_x;
    
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 1.5), @(- M_PI * 2)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.3), @(0.6), @(1.0)];
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    // path为移动的路径，临时变量，之后就会释放
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, original.x, original.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(0.7), @(1.0)];
    movingAnimation.duration = duration;
    CGPathRelease(path);
    
    // 3.Merge two animation together
    // 两个动画合并
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[movingAnimation, rotationAnimation];
    //    animations.animations = @[rotationAnimation];
    
    animations.duration = duration;
    animations.delegate = delegate;
    
    return animations;
}



@end
