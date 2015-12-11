//
//  IOSShareSDK.h
//  IOSShareSDK
//
//  Created by hehaibing on 15/3/4.
//  Copyright (c) 2015年 seasung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark  分享内容功能类

@interface IOSShareSDK : NSObject

/*
 IOSShareSDK的初始化接口
 @param    初始化参数，定义查看 shareInitParam 类
 @result   调用成功与否（对应ShareErrCode中的定义）
 */
+ (void)initWithParam:(NSString*)jsonParam;


/*
 弹出分享渠道选择框
 @callback   分享结果返回的回调
 @mediaObj 分享内容json串
 @result 调用成功与否（0 成功， 1 失败，2 不支持的操作 ）
 
 mediaObj是一个json串
 type：类型枚举，包括TEXT、IMAGE、WEBPAGE
 title：标题
 description：描述
 imageUrl：图片路径字符串，如果为空，将尝试从imageUrls中取第一个图片路径
 imageUrls：JSONArray<String>，图片路径的数组
 webpageUrl：网页路径的字符串
 */
+ (void)openShareView:(NSString*)mediaObj;


/*
 直接分享接口，不用弹出分享选择框
 @channelValue 分享渠道的标志值，指出通过那个渠道分享出去
 @mediaObj 分享内容json串
 @callback   分享结果返回的回调
 @result 调用成功与否（0 成功， 1 失败，2 不支持的操作 ）
 
 mediaObj是一个json串
 type：类型枚举，包括TEXT、IMAGE、WEBPAGE
 title：标题
 description：描述
 imageUrl：图片路径字符串，如果为空，将尝试从imageUrls中取第一个图片路径
 imageUrls：JSONArray<String>，图片路径的数组
 webpageUrl：网页路径的字符串
 */
+ (void)directSendShare:(int)channelValue mediaObj:(NSString*)mediaObj;


/*
 系统回调接口（ 在应用程序的AppDelegate 类的handleOpenURL 以及 openURL 回调中调用此接口）
 @url 系统回调返回的URL
 handleOpenURL ( [myClass shareOpenURL:url sourceApplication:nil]; )
 openURL ( [myClass shareOpenURL:url sourceApplication:sourceApplication];)
*/
+ (BOOL)shareOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
