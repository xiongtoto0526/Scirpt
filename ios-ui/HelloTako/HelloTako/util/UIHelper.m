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

// 反射key
#import <objc/runtime.h>
#import <zlib.h>

#import <CommonCrypto/CommonDigest.h>

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
    if (key==nil) {
        NSLog(@"login key is invalid,please login again...");
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

+(NSString*)stringWithLong:(long long)longvalue{
    return [NSString stringWithFormat:@"%qi",longvalue];
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

+(int)isDevicefileValid:file md5:(NSString*)md5{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* homePath =[paths firstObject];
    NSString* filepath = [homePath stringByAppendingPathComponent:file];
    
    // 检查文件是否存在
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:filepath]==YES) {
        NSLog(@"device File exists");
        NSLog(@"file is:%@",filepath);
    }else{
        NSLog(@"error!!! device File not exists");
        return 1;
    }
    
    // 检查md5
    NSString* currentMd5 = [XHTUIHelper md5withFile:filepath];
    if (![currentMd5 isEqualToString:md5]) {
        NSLog(@"error!!! device filemd5 validate failed,local:%@,remote:%@",currentMd5,md5);
        return 2;
    }
    
    return 0;
}



+ (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}


+ (NSMutableArray*)getObjectKeys:(id)obj
{
    NSMutableArray* keys = [NSMutableArray new];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        [keys addObject:propName];
    }
    return keys;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}



+(NSString*)md5withFile:(NSString*) path{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
//        NSLog(@"length is:%lu",(unsigned long)[fileData length]);
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);// file_length  max to be 256 which never overflow,so here we it force to cc_long
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

+(void)addleftViewforText:(UITextField*)t image:(NSString*)image{
    
    UIImageView *nameImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    nameImageview.image = [UIImage imageNamed:image];
    t.rightView = nameImageview;
    t.rightViewMode=UITextFieldViewModeAlways;
//    [t paste:self];
//    int beginAt = 140;
//    UITextPosition *start = [t positionFromPosition:[t beginningOfDocument]
//                                                 offset:NSMakeRange(beginAt, 0).location];
//    UITextPosition *end = [t positionFromPosition:start
//                                               offset:NSMakeRange(beginAt, 0).length];
//    [t setSelectedTextRange:[t textRangeFromPosition:start toPosition:end]];
}

@end
