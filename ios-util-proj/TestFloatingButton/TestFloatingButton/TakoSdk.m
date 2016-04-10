//
//  SmartTako.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "TakoSdk.h"
#import "UIHelper.h"
#import "MyAnimate.h"

@interface TakoSdk (){
    Boolean isOpened;
    Boolean isDragged;
}
@property (nonatomic,strong) UIButton* mainButton;
@property (nonatomic,strong) UIButton* subButton;
@property (nonatomic,strong) NSMutableArray* subButtons;
@property (nonatomic,strong) UIWindow* rootWindow;
@end

static TakoSdk* shareTakoSdk = nil;
#define originalFrame  CGRectMake(100, 180, 80, 80)

@implementation TakoSdk

+(TakoSdk*)share{
    if (shareTakoSdk ==nil) {
       shareTakoSdk = [[TakoSdk alloc] init];
    }
    return shareTakoSdk;
}

-(UIWindow*) takoSdkInit{
    
    // 添加主按钮
    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainButton setTitle:@"主按钮" forState:UIControlStateNormal];
    self.mainButton.frame = CGRectMake(0, 0, 80, 80);
    self.mainButton.backgroundColor = [UIColor grayColor];
    [self.mainButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.mainButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [UIHelper addBorderonButton:self.mainButton cornerSize:40];
    
    // window拖拽跟随
    [self.mainButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [self.mainButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    
    // 添加window
    self.rootWindow = [[UIWindow alloc]initWithFrame:originalFrame];
    self.rootWindow.windowLevel = UIWindowLevelAlert+1;
    self.rootWindow.backgroundColor = [UIColor clearColor];
    self.rootWindow.layer.cornerRadius = 40;
    self.rootWindow.layer.masksToBounds = YES;
    [self.rootWindow addSubview:self.mainButton];
    [self.rootWindow makeKeyAndVisible];//关键语句,显示window
    
    return self.rootWindow;
}

-(void)touchDown{
    isDragged = NO;
}


-(void)openMenu{
    NSLog(@"will show menu bar...");
    
    // 拖拽期间不再响应点击事件
    if (isDragged) {
        return;
    }
    
    // 已打开时，收缩window。
    if (isOpened) {
//        CGPoint endPoint = CGPointMake(0, 0);
//            [self.subButton setX:40]; // bug 1: why???
        for(int i =0 ;i<[self.subButtons count];i++){
            CGPoint endPoint = CGPointMake(0, 0);
            UIButton* sub = [self.subButtons objectAtIndex:i];
//            [sub setX:40]; // bug 1: why???
         [[MyAnimate share] myRotateAndMoveforOpenView:sub endPoint:endPoint delegate:self];
        }
        

//        self.subButton = nil;
        isOpened = NO;
        return;
    }
    
    if ([self.subButtons count]==0) {
       
    self.subButtons = [NSMutableArray new];
    
    for (int i=0; i<4; i++) {
        UIButton* sub = [[UIButton alloc]initWithFrame:self.mainButton.frame];
        [sub setTitle:[NSString stringWithFormat:@"次按钮%d",i] forState:UIControlStateNormal];
        sub.tag =i;
        NSLog(@"tag is:%ld",(long)sub.tag);
//        [sub setX:self.mainButton.frame.size.width/2];
        NSLog(@"main x is:%f",self.mainButton.frame.origin.x);
        [sub setBackgroundColor:[UIColor grayColor]];
        [UIHelper addBorderonButton:sub cornerSize:40];
        NSLog(@"fram is:%f",sub.frame.origin.y);
        [self.rootWindow insertSubview:sub belowSubview:self.mainButton];
        [self.subButtons addObject:sub];
    }
    }
    

    self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, self.rootWindow.frame.size.height+290+8);
    

    
    //    self.subButton.alpha = 1;
    
    // 测试所有动画
//    [[MyAnimate share] myScaleforView:self.subButton];
//    [[MyAnimate share] myOppositeforView:self.subButton];
//    [[MyAnimate share] myRotateforView:self.subButton];
//    [[MyAnimate share] myShakeforView:self.subButton];

    //    [[MyAnimate share] myRotateAndMoveforCloseView:self.subButton];
    int a = 0;
    for (UIButton* sub in self.subButtons) {
//        NSLog(@"tag is:%ld",(long)sub.tag);
        float newHeight =  sub.frame.size.height*a+1;
        CGPoint endPoint = CGPointMake(0, newHeight+sub.frame.size.height/2);
        [[MyAnimate share] myRotateAndMoveforOpenView:sub endPoint:endPoint delegate:self];
        a = a+1;
    }
//    CGPoint endPoint = CGPointMake(0, 190);
//    [[MyAnimate share] myRotateAndMoveforOpenView:self.subButton endPoint:endPoint delegate:self];

    isOpened = YES;
}


// bug: 这里的delegate可能造成多个回调冲突，需要优化。
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && !isOpened) {
        self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, originalFrame.size.height);    }
}


- (void) dragMoving: (UIControl *) c withEvent:ev
{
    isDragged = YES;

    // 菜单已打开时，不响应拖拽
    if(isOpened){
        return;
    }
    
    // todo:需要取到最上层的。
    UIView* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CGPoint currentCenter = [[[ev allTouches] anyObject] locationInView:appWindow];
    
    self.rootWindow.center = currentCenter;
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    /* 
     1. 非拖拽的touchup事件不响应，
     2. 菜单打开时，不响应
     */
    if(!isDragged || isOpened){
        return;
    }
    // todo:需要取到最上层的。
    UIView* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CGPoint currentCenter = [[[ev allTouches] anyObject] locationInView:appWindow];

    
    // 判断当前位置, 只能靠边停. todo：需要增加动画
    if (currentCenter.x<mainS.width/2 ) {
        currentCenter.x = self.rootWindow.frame.size.width/2;
    }else{
        currentCenter.x = mainS.width-self.rootWindow.frame.size.width/2;
    }
    
    //首尾式动画
    [UIView beginAnimations:nil context:nil];

    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.2];  
    self.rootWindow.center = currentCenter;
    
    [UIView commitAnimations];
}


// 对象释放
- (void)destoryTakoSdk
{
    [self.rootWindow resignKeyWindow];
    self.rootWindow = nil;
}



@end
