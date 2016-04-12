//
//  ViewController.m
//  TestLocalNotification
//
//  Created by 熊海涛 on 16/4/11.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bt setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)testNotify:(id)sender{
    NSLog(@"enter...");
//    [self testLocalNotification];
}

-(void)testLocalNotification{
    NSLog(@"will do local notification...");
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为20妙后
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:8];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody = @"just a xht title";
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"xht_local_push_id",@"id",[NSNumber numberWithInteger:123],@"time",[NSNumber numberWithInt:12345],@"affair.aid", nil];
    localNotification.userInfo = infoDic;
    //在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    //立即触发一个通知
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    //    [localNotification release];
}


@end
