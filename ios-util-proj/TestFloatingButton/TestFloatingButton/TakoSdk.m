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
@property (nonatomic,strong) UIWindow* rootWindow;
@end

static TakoSdk* shareTakoSdk = nil;
#define button_count 3
#define button_alpha 1
#define button_width 50
#define originalFrame  CGRectMake(100, 180, button_width, button_width)

@implementation TakoSdk

+(TakoSdk*)share{
    if (shareTakoSdk ==nil) {
        shareTakoSdk = [[TakoSdk alloc] init];
    }
    return shareTakoSdk;
}

-(void) takoSdkInitWithSubButtons:(NSArray*)buttons{
    [self takoSdkInit];
    self.subButtons = [NSMutableArray new];
    for (int i =0 ;i<[buttons count];i++) {
        UIButton* sub = [buttons objectAtIndex:i];
        sub = [self buildSubButton:sub index:i];
        [self.subButtons addObject:sub];
        [self.rootWindow insertSubview:sub belowSubview:self.mainButton];
    }
}

-(UIWindow*) takoSdkInit{
    
    // 添加主按钮
    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainButton setTitle:@"主按钮" forState:UIControlStateNormal];
    [self.mainButton setBackgroundImage:[UIImage imageNamed:@"btmbg.png"] forState:UIControlStateNormal];
    [self.mainButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    self.mainButton.frame = CGRectMake(0, 0, button_width, button_width);
    self.mainButton.backgroundColor = [UIColor clearColor];
    
    // 注册响应事件
    [self.mainButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.mainButton addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [UIHelper addBorderonButton:self.mainButton cornerSize:button_width/2];
    
    // window拖拽跟随
    [self.mainButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [self.mainButton addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    self.mainButton.alpha = button_alpha;
    
    // 添加window
    self.rootWindow = [[UIWindow alloc]initWithFrame:originalFrame];
    self.rootWindow.windowLevel = UIWindowLevelAlert+1;
    self.rootWindow.backgroundColor = [UIColor clearColor];
    self.rootWindow.layer.cornerRadius = button_width/2;
    self.rootWindow.layer.masksToBounds = YES;
    [self.rootWindow addSubview:self.mainButton];
    [self.rootWindow makeKeyAndVisible];//关键语句,显示window
    
    return self.rootWindow;
}

-(void)touchDown{
    isDragged = NO;
}


-(void)openMenu{
    
    // 拖拽期间不再响应点击事件
    if (isDragged) {
    NSLog(@"dragging...");
        return;
    }
    
    // 已打开时，收缩window。
    if (isOpened) {
    NSLog(@"will close menu...");
        [self.mainButton setTitle:@"主按钮" forState:UIControlStateNormal];
        [[MyAnimate share] myRotateAndMoveforCloseView:self.mainButton endPoint:CGPointMake(0, 0) buffer:0 delegate:self];
        
        
        for(int i =0 ;i<[self.subButtons count];i++){
            CGPoint endPoint = CGPointMake(0, self.mainButton.frame.origin.y);
            UIButton* sub = [self.subButtons objectAtIndex:i];
            [[MyAnimate share] myRotateAndMoveforCloseView:sub endPoint:endPoint buffer:5 delegate:self];
        }
        isOpened = NO;
        return;
    }
    
    NSLog(@"will open menu ...");
    if ([self.subButtons count]==0) {
        
        self.subButtons = [NSMutableArray new];
        for (int i=0; i<button_count; i++) {
            UIButton* sub = [self buildSubButton:[[UIButton alloc] init] index:i];
//            UIButton* sub = [self buildSubButtonWithIndex:i];
            [self.subButtons addObject:sub];
        }
    }
    
    
    self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, self.rootWindow.frame.size.height+button_width*button_count);
    
    // 测试所有动画
    //    [[MyAnimate share] myScaleforView:self.subButton];
    //    [[MyAnimate share] myOppositeforView:self.subButton];
    //    [[MyAnimate share] myRotateforView:self.subButton];
    //    [[MyAnimate share] myShakeforView:self.subButton];
    
    [[MyAnimate share] myRotateAndMoveforOpenView:self.mainButton endPoint:CGPointMake(0, 0) buffer:0 delegate:self];
    for (int i =0;i<[self.subButtons count];i++) {
        //        NSLog(@"tag is:%ld",(long)sub.tag);
        UIButton* sub = [self.subButtons objectAtIndex:i];
        float end_y =  self.mainButton.frame.origin.y + sub.frame.size.height*(i+1)+1;
        CGPoint endPoint = CGPointMake(0, end_y);
        [[MyAnimate share] myRotateAndMoveforOpenView:sub endPoint:endPoint buffer:5 delegate:self];
    }
    [self.mainButton setTitle:@"收起" forState:UIControlStateNormal];
    isOpened = YES;
}


// 这里的delegate可能造成多个回调，此处通过if判断过滤
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && !isOpened && self.rootWindow.frame.size.height != originalFrame.size.height) {
        self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, originalFrame.size.height);
    }
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



-(UIButton*)buildSubButton:(UIButton*)button index:(int) i{
    button.frame = self.mainButton.frame;
    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
    button.tag =i;
    [UIHelper addBorderonButton:button cornerSize:button_width/2];
    return button;
}


@end
