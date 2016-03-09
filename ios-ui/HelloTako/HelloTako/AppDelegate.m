//
//  AppDelegate.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "Constant.h"
#import "UIHelper.h"
#import "Server.h"
#import "SharedInstallManager.h"

@interface AppDelegate (){
	HTTPServer *httpServer;
}

@end

@implementation AppDelegate



- (void)startServer
{
    // 启动cocoaHttpServer
    NSError *error;
    if([httpServer start:&error])
    {
        int port = [httpServer listeningPort];
        NSLog(@"Started HTTP Server on port %d", port);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 强制调整view的加载顺序。refactor:是否可优化为配置？
    UITabBarController *bar = (UITabBarController*)self.window.rootViewController;
    NSArray* all = [bar childViewControllers];
    NSMutableArray* newItems = [NSMutableArray new];
    [newItems addObject:all[1]];
    [newItems addObject:all[0]];
    bar.viewControllers = newItems;
    
    [NSThread sleepForTimeInterval:LAUNCH_SCREEN_TIME];//设置闪屏页面时间
//    
//     [XHTUIHelper clearAllUserDefaultsData]; // 调试用

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"当前版本:%@",currentVersion);
    
    
    // 启动 httpserver
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    [httpServer setPort:HTTP_SERVER_PORT];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homePath = [paths firstObject];
    //    filepath = [homePath  stringByAppendingPathComponent:@"xgtakofiles"];
    [httpServer setDocumentRoot:homePath];
    NSLog(@"root path is:%@",homePath);
    [self startServer];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //    [httpServer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    //    [self startServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    // 发送事件,保存进度
    NSNotification *notification =[NSNotification notificationWithName:APPLICATION_WILL_TERMINATE_NOTIFICATION object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // 停止监听安装进度
    [SharedInstallManager stop];

}

@end
