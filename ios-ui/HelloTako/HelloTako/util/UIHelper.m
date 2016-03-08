//
//  UIHelper.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UIHelper.h"
#import "Constant.h"

// add for local ip
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation XHTUIHelper


// notes: this mehod maybe do nothing if your xib is auto-layout enabled
+(void) addBorderonButton:(UIButton*) btn{
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = 8;
}

+ (void) disableDownloadButton:(UIButton*) btn{
    [btn.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
    btn.enabled = NO;
}

// 隐藏tableview多余的单元格
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


+(void)alertWithNoChoice:(NSString*)msg view:(UIViewController*)view{
    if(view==nil){
        view = [self getCurrentVC];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [view presentViewController:alertController animated:YES completion:nil];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (CGSize) viewSizeWith: (UIView*) view{
    CGSize screensize = view.bounds.size;
    //float height = screensize.height;
    //float width = screensize.width;
    return screensize;
}



//读取userDefault的nsstring数据
+(NSString*)readNSUserDefaultsWithkey:(NSString*) key{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes stringForKey:key];
}


//读取userDefault的object数据
+(id)readNSUserDefaultsObjectWithkey:(NSString*) key{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:key];
}




//数据持久化至userDefault
+(void)writeNSUserDefaultsWithKey:(NSString*) key withValue:(NSString*) value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //添加
    [userDefaults setObject:value forKey:key];
    
    //同步
    [userDefaults synchronize];
}

+ (void)clearAllUserDefaultsData
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}


//object持久化至userDefault
+(void)writeNSUserDefaultsWithKey:(NSString*) key withObject:(id) value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //添加
    [userDefaults setObject:value forKey:key];
    
    //同步
    [userDefaults synchronize];
}



+ (id) objectWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key
{
    if (jsonStr==nil||key==nil) {
        return nil;
    }

    id ret=nil;
    NSData* tempData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if(tempData != nil){
        ret = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
        if(ret != nil && [ret isKindOfClass:[NSDictionary class]]){
            NSDictionary* retDict = (NSDictionary*)ret;
            ret = [retDict objectForKey:key];
        }
    }
    
    return ret;
}


+(void) setDictValue:(NSMutableDictionary*) dict withObject:(id)object forKey:(NSString*)key{
    if(object != nil && dict!=nil){
        [dict setObject:object forKey:key];
    }
}


+(BOOL)isLogined{
    NSString* key = [XHTUIHelper readNSUserDefaultsWithkey:LOGIN_KEY];
    NSLog(@"login key is:%@",key);
    if (key==nil) {
        return NO;
    }
    return [key isEqualToString:LOGIN_SUCCESS_KEY];
}

+(NSString*) hostFromInfoPlist{
    return [self infoPlistValueForKey:TAKO_SERVER_HOST_KEY];
}

+ (id) infoPlistValueForKey:(NSString *) key
{
    if (key==nil)
    {
        return nil;
    }
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}


//获取本机的IP
+ (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

+(BOOL)isDevicefileExist:(NSString*) file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* homePath =[paths firstObject];
    NSString* filepath = [homePath stringByAppendingPathComponent:file];

    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:filepath]==YES) {
        NSLog(@"device File exists");
        NSLog(@"file is:%@",filepath);
        return YES;
    }else{
        NSLog(@"device File not exists");
        return NO;
    }

}


@end
