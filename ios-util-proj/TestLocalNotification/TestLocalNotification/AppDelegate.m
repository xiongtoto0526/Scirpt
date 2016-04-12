//
//  AppDelegate.m
//  TestLocalNotification
//
//  Created by 熊海涛 on 16/4/11.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self testLocalNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    [self removeNotification];

}


// 功能：用户收到本地通知，且已点击该通知，此时需要将清除通知栏。
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSLog(@"用户收到本地通知，且已点击通知，将清除通知栏的...");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}


// 功能：取消某一个通知，前提：该通知尚未发送。
-(void)removeNotification{
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:@"xht_local_push_id"]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            NSLog(@" remove successful...");
            break;
        }
    }
    
    //取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// 功能：发送一个通知，3秒后发送。
-(void)testLocalNotification{
    NSLog(@"will do local notification...");
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为20妙后
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
