//
//  SmartTako.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "TakoSdk.h"
#import "UIHelper.h"

@interface TakoSdk (){
    Boolean isOpened;
}
@property (nonatomic,strong) UIButton* mainButton;
@property (nonatomic,strong) UIButton* subButton;
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


-(void)openMenu{
    NSLog(@"will show menu bar...");
    
    // 已打开,忽略。
    if (isOpened) {
        self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, originalFrame.size.height);
        self.subButton = nil;
        isOpened = NO;
        return;
    }
    self.subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subButton setTitle:@"次按钮" forState:UIControlStateNormal];
    self.subButton.frame = CGRectMake(0, 90, 80, 80);
    //    [newbt addTarget:self action:@selector(openNew) forControlEvents:UIControlEventTouchDown];
    [self.rootWindow addSubview:self.subButton];
    self.rootWindow.frame = CGRectMake(self.rootWindow.frame.origin.x, self.rootWindow.frame.origin.y, self.rootWindow.frame.size.width, self.rootWindow.frame.size.height+90);
    
    [self.subButton setBackgroundColor:[UIColor grayColor]];
    [UIHelper addBorderonButton:self.subButton cornerSize:40];
    isOpened = YES;
    
}

- (void) dragMoving: (UIControl *) c withEvent:ev
{
    // todo:需要取到最上层的。
    UIView* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CGPoint currentCenter = [[[ev allTouches] anyObject] locationInView:appWindow];
    self.rootWindow.center = currentCenter;
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    // todo:需要取到最上层的。
    UIView* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CGPoint currentCenter = [[[ev allTouches] anyObject] locationInView:appWindow];
    
//    // 已经靠边，则不做出来
//    if (currentCenter.x == mainS.width-self.rootWindow.frame.size.width/2 || self.rootWindow.frame.size.width/2) {
//        return;
//    }
    
    // 判断当前位置, 只能靠边停. todo：需要增加动画
    if (currentCenter.x<mainS.width/2 ) {
        currentCenter.x = self.rootWindow.frame.size.width/2;
    }else{
        currentCenter.x = mainS.width-self.rootWindow.frame.size.width/2;
    }
    self.rootWindow.center = currentCenter;
}


// 对象释放
- (void)destoryTakoSdk
{
    [self.rootWindow resignKeyWindow];
    self.rootWindow = nil;
}



@end
