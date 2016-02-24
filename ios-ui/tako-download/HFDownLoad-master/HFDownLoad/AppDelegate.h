//
//  AppDelegate.h
//  HFDownLoad
//
//  Created by 洪峰 on 15/9/7.
//  Copyright (c) 2015年 洪峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTPServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
HTTPServer *httpServer;
}
@property (strong, nonatomic) UIWindow *window;


@end

