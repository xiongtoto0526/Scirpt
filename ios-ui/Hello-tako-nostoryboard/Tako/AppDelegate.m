//
//  AppDelegate.m
//  Tako
//
//  Created by 熊海涛 on 16/3/14.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "HTTPServer.h"
#import "Constant.h"
#import "UIHelper.h"
#import "Server.h"
#import "SharedInstallManager.h"
#import "WXApi.h"
#import "RootBarViewController.h"
#import "REFrostedViewController.h"
#import "MyMenuViewController.h"

@interface AppDelegate ()<WXApiDelegate,REFrostedViewControllerDelegate>{
    HTTPServer *httpServer;
//    BOOL isUserSelected;
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
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置日志级别
    [XHTUIHelper configDebugInfo];
    
    // 注册微信分享服务
    Boolean isOk = [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    NSLog(@"%hhu",isOk);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 记录初始化根view的方式
    [XHTUIHelper writeNSUserDefaultsWithKey:IS_LOADD_BAR_VIEW_KEY withObject:@"0"];
    
    // 更新cookie
    if ([XHTUIHelper isLogined]) {
        [XHTUIHelper updateLoginCookie];
    }
    
//    NSLog(@"all app is:%@",[XHTUIHelper allApps]);
//    [[SharedInstallManager shareInstWithdelegate:self] isInstalledApp:@"com.jx3.m.jx3pocket"];
    
    // 若有新版本，由用户选择是否更新。
    if ( [TakoServer isNewVersion]) {
        self.window.rootViewController = [self launchScreenView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self showVersionView];
        });
        NSLog(@"检测到新版本...");
        return YES;
    }
    
    // 设置闪屏页面时间
    [NSThread sleepForTimeInterval:LAUNCH_SCREEN_TIME];
    
    // 正常启动
    [self normalStart];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
     // 保持原来的连接，只停监听。
    [httpServer stop:YES];
    
    UIApplication*    app = [UIApplication sharedApplication];
    
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);

    // 原来的连接还在，重启服务即可继续安装。
    [self startServer];
    self.backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you.
        // stopped or ending the task outright.
        NSLog(@"finish background task ,will end it...");
        [app endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    
    

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    // 发送事件,保存进度, to-refactor: 改为监听系统事件：UIApplicationDidEnterBackgroundNotification
    NSNotification *notification =[NSNotification notificationWithName:APPLICATION_WILL_TERMINATE_NOTIFICATION object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // 停止监听安装进度
//    [SharedInstallManager stop];
    
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
   return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.self.Tako" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tako" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tako.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // handle db upgrade (简单的数据迁移,如增加字段，字段必填改为可选。coredata会自动迁移)
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);

        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)normalStart{
    
#ifdef IS_SIDE_MENU_ENABLE
    [self setUpMenuController];
    return;
#endif
    
    if ([XHTUIHelper isLogined] && [TakoServer isValidLogin]) {
        self.window.rootViewController = [XHTUIHelper initTabbar];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }
    [self.window makeKeyAndVisible];

    //    [XHTUIHelper clearAllUserDefaultsData]; // 调试用

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

}

-(UIViewController*)launchScreenView{
    UIViewController* vc = [[UIViewController alloc] init];
    UIImageView* imgview = [[UIImageView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    imgview.image = [UIImage imageNamed:@"LaunchImage"];
    [vc.view addSubview:imgview];
    return vc;
}

-(void)showVersionView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到新版本~" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        [self normalStart];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"跳转至更新页面...");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[XHTUIHelper takoAppUrl]]];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


// 设置侧滑菜单特性
-(void)setUpMenuController{
    
    // Create content and menu controllers
//    MenuTableViewController *menuController = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    UINavigationController* navc = [[UINavigationController alloc] initWithRootViewController:menuController];
    
    MyMenuViewController *menuController = [[MyMenuViewController alloc] init];
        UINavigationController* navc = [[UINavigationController alloc] initWithRootViewController:menuController];
    
    // Create frosted view controller
    RootTabBarController* rootVc = [XHTUIHelper initTabbar];
    REFrostedViewController* frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:rootVc menuViewController:navc];

    
    // 持有根引用
    rootVc.reVC = frostedViewController;
    
    // 设置menu滑动特性
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    // 设置根视图
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

}

# pragma mark side-menu-delegate

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

@end
