//
//  iOSPushSDK.h
//  iOSPushSDK
//
//  Created by hehaibing on 15/4/14.
//  Copyright (c) 2015年 seasung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/****************************** 注意:游戏药接入IOS Push功能，必须要接入统计功能 **********************************/

@interface iOSPushSDK : NSObject
/*
 初始化iosPush 接口，参数跟统计初始化一样(这里就是初始化统计的接口,在xgCommon的onEnterGame中调用)
 @jsonParams 初始化统计接口的参数
*/
+(NSNumber*)initPushSDK:(NSString*)jsonParams andOther:(NSDictionary*)other;

/*
 设置回调接口
 @block      用于回调接口，用于通知游戏跳转到某个指定的页面
 @activity   要跳转的页面
 @jsonParam  跳转页面的参数
*/
+(void)setPushBlock:(void (^)(NSString* activity ,NSString* jsonParam))block;

///////////////////////////////////如下是APP对应的AppDelegate中相应的代理方法/////////////////////////////////////////////////

/*
 对应的AppDelegate中的 didFinishLaunchingWithOptions 代理方法
*/
+(void)pushDidFinishLaunchingWithOptions:(UIApplication *)application launchOptions:(NSDictionary*)launchOptions;

/*
 对应的AppDelegate中的 didRegisterUserNotificationSettings 代理方法
 */
+(void)pushDidRegisterUserNotificationSettings:(UIApplication *)application settings:(UIUserNotificationSettings*)notificationSettings;

/*
 对应的AppDelegate中的 didRegisterForRemoteNotificationsWithDeviceToken 代理方法
 */
+(void)pushDidRegisterForRemoteNotificationsWithDeviceToken:(UIApplication *)application token:(NSData *)deviceToken;

/*
 对应的AppDelegate中的 didFailToRegisterForRemoteNotificationsWithError 代理方法
 */
+(void)pushDidFailToRegisterForRemoteNotificationsWithError:(UIApplication *)application error:(NSError *)error;

/*
 对应的AppDelegate中的 didReceiveRemoteNotification 代理方法
 */
+(void)pushDidReceiveRemoteNotification:(UIApplication *)application userinfo:(NSDictionary *)userInfo;

@end
