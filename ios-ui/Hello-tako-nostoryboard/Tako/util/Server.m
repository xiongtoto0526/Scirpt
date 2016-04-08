//
//  UIHelper.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//


#import "Server.h"
#import "App.h"
#import "Constant.h"
#import "UIHelper.h"
#import "MBProgressHUD.h"
#import "AppVersion.h"

#define LOGIN_EMAIL_KEY @"email"
#define LOGIN_PASSWORD_KEY @"password"
#define COMMON_RET_KEY @"ret"
#define COMMON_DATA_KEY @"data"
#define LOGIN_USERID_KEY @"userid"
#define LOGIN_USERTOKEN_KEY @"token"
#define LOGIN_USERNICKNAME_KEY @"nickname"

@implementation TakoServer

+(BOOL)isValidLogin{
    BOOL result = YES;
    NSString* url = nil;
    
    url = [NSString stringWithFormat:@"/checklogin"];
    
    
    NSData* returnData = [self postWithDict:nil url:url];
    if (returnData==nil) {
        return result;
    }
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!! fetch iterm url error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    result = [resultCode longValue] == 0;
    if (!result) {
        NSLog(@"token过期。");
    }
    return result;
}

+(BOOL)isNewVersion{
    NSString* oldbuildid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    oldbuildid = @"800";
    TakoVersion* version = [TakoServer fetchVersion];
    NSLog(@"old build id is:%@,new build id is:%@",oldbuildid,version.buildNumber);
    BOOL isNew = [oldbuildid intValue]<[version.buildNumber intValue];
    if (isNew) {
        NSLog(@"发现新版本，将提示用户更新...");
    }
    return isNew;
}

+(NSMutableArray*)searchApp:(NSString*) searchText{
    return nil;
}

+(TakoVersion*)fetchVersion{
    TakoVersion* version = [TakoVersion new];
    NSString*  url = @"/tako/upgrade/latest?platform=1";
    [self getWithUrl:url];
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        DDLogError(@"error!!! fetch http error...");
        return nil;
    }
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!! fetch version error...");
        return nil;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch version success....");
        NSDictionary* data = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
        NSDictionary* package =[data objectForKey:@"package"];
        NSString* versionName = [package objectForKey:@"version"];
        NSString* buildNumber = [package objectForKey:@"buildnumber"];
        version.versionName = versionName;
        version.buildNumber = buildNumber;
    }
    
    return version;
}

+(NSMutableArray*)fetchAppVersions:(NSString*)appid cursor:(NSString*)cursor{
    NSMutableArray* result = [NSMutableArray new];
    
    NSString* url = [NSString stringWithFormat:@"/getappversions?appid=%@&cursor=%@&count=%@&pid=%@",appid,cursor,TAKO_SERVER_VERSION_FETCH_SIZE,@"1"];
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        return result;
    }
    
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"http response is ...%@",retjson);// 量太大,暂时不log
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!!  apps fetch error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch success....");
        NSDictionary* dataDict = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
        
        NSArray* appVersions = [dataDict objectForKey:@"appversions"];
        if ([appVersions isKindOfClass:[NSNull class]]) {
            NSLog(@"no new data...");
            return result;
        }
        for (int i=0; i<[appVersions count]; i++) {
            NSDictionary* temp = (NSDictionary*)[appVersions objectAtIndex:i];
            TakoAppVersion* app =  [[TakoAppVersion new] initWithDictionary:temp];
            [result addObject:app];
        }
    }
    
    return result;
}

+(NSString*)fetchItermUrl:(NSString*)versionId password:(NSString*)password{
    
    NSString* result = nil;
    NSString* url = nil;
    
    if (password!=nil && ![password isEqualToString:@"-1"]) {
        url = [NSString stringWithFormat:@"/app/version/url?id=%@&local=true&password=%@",versionId,password];
    }else{
        url = [NSString stringWithFormat:@"/app/version/url?id=%@&local=true",versionId];
    }
    
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        return result;
    }
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!! fetch iterm url error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch iterm url success....");
        result = (NSString*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
    }
    
    return result;
    
}

+(TakoApp*)fetchAppWithid:(NSString*)appid{
    NSString* url = [NSString stringWithFormat:@"/app/%@",appid];
    TakoApp* result = nil;
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        return result;
    }
    
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!! app info fetch error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch success....");
        NSDictionary* dataDict = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
        
        NSDictionary* appDict = [dataDict objectForKey:@"app"];
        result =  [[TakoApp new] initWithDictionary:appDict];
    }
    return result;
}

+(NSMutableArray*)fetchApp:(NSString*)cursor{
    
    NSMutableArray* result = [NSMutableArray new];
    
    NSString* url = [NSString stringWithFormat:@"/gettaskapps?cursor=%@&count=%@&pid=%@",cursor,TAKO_SERVER_APP_FETCH_SIZE,@"1"];
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        return result;
    }
    
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);// 量太大,暂时不log
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"error!!!  apps fetch error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch success....");
        NSDictionary* dataDict = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
        
        NSArray* apps = [dataDict objectForKey:@"apps"];
        for (int i=0; i<[apps count]; i++) {
            NSDictionary* temp = (NSDictionary*)[apps objectAtIndex:i];
            TakoApp* app =  [[TakoApp new] initWithDictionary:temp];
            [result addObject:app];
        }
    }
    return result;
}



+(NSString*)fetchDownloadUrl:(NSString*)versionId password:(NSString*)password{
    NSString* result=nil;
    NSData* response=nil;
    if (password==nil || [password isEqualToString:@"-1"]) {
        NSLog(@"无需下载密码。");
        response = [self getWithUrl:[NSString stringWithFormat:@"/app/version/download/url?id=%@",versionId]];
    }else{
        NSLog(@"需要下载密码。");
        response = [self getWithUrl:[NSString stringWithFormat:@"/app/version/download/url?id=%@&password=%@",versionId,password]];
    }
    
    // 处理http结果
    if(response == nil){
        DDLogError(@"error!!!  downloadurl fetch error...");
        return result;
    }
    
    NSString* retjson = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        DDLogError(@"http error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if([resultCode longLongValue]!=0){
        NSLog(@"http failed...");
        return result;
    }
    result = (NSString*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
    return result;
}

// 模拟数据
+(NSMutableArray*)mockApps{
    NSMutableArray* result = [NSMutableArray new];
    for (int i=0;i<5;i++) {
        TakoApp* app = [TakoApp new];
        app.appname=[NSString stringWithFormat:@"app%d",i+1];
        app.versionname=[NSString stringWithFormat:@"%d.%d.%d",i+1,i+1,i+1];
        app.releasetime=@"2015-11-09";
        app.appid=[NSString stringWithFormat:@"appid%d",i];
        [result addObject:app];
    }
    return result;
}

+(TakoUser*)authEmail:(NSString*)email password:(NSString*)password{

    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:email forKey:LOGIN_EMAIL_KEY];
    [dict setObject:password forKey:LOGIN_PASSWORD_KEY];
    NSData* retData = [self postWithDict:dict url:@"/login"];
    
    // 解析结果
    if(retData == nil){
        DDLogError(@"http error...");
        return nil;
    }else{
        NSString* retjson = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
        NSLog(@"http response is ...%@",retjson);// 敏感信息,暂时不log
        if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
            NSLog(@"auth error...");
            return nil;
        }
        
        NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
        if ([resultCode longValue] == 0) {
            NSLog(@"auth success....");
            NSDictionary* data = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
            
            TakoUser* user = [TakoUser new];
            if([data objectForKey:LOGIN_USERID_KEY]!=nil){
                user.userId = (NSString*)[data objectForKey:LOGIN_USERID_KEY];
            }
            if([data objectForKey:LOGIN_USERTOKEN_KEY]!=nil){
                user.userToken = (NSString*)[data objectForKey:LOGIN_USERTOKEN_KEY];
                // 存储token
                [XHTUIHelper writeNSUserDefaultsWithKey:USER_TOKEN_KEY withObject:user.userToken];
            }
            if([data objectForKey:LOGIN_USERNICKNAME_KEY]!=nil){
                user.nickName = (NSString*)[data objectForKey:LOGIN_USERNICKNAME_KEY];
            }
            return user;
        }
    }
    
    return nil;
}

+(NSData*)postWithDict:(NSDictionary*)dict url:(NSString*)methodUrl{
    
    
    NSData* bodyData = nil;
    if (dict) {
       bodyData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    }
    NSString* serverUrl = [NSString stringWithFormat:@"%@%@",[XHTUIHelper takoHost],methodUrl];
    NSURL* url = [[NSURL alloc] initWithString:serverUrl];
    NSLog(@"url is %@", url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TAKO_SERVER_TIME_OUT];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (bodyData) {
        [request setHTTPBody:bodyData];
//        NSLog(@"setHTTPBody data = %@",[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding]);
    }
    

    NSError* error = nil;
    NSData* retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];


    
    return retData;
}



+(NSData*) getWithUrl:(NSString*)methodUrl
{

//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSLog(@"before login....");
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        NSLog(@"%@", cookie);
//    }
    
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",[XHTUIHelper takoHost],methodUrl];
    NSLog(@"url is:%@",urlstr);
    NSURL* url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TAKO_SERVER_TIME_OUT];
    [request setHTTPMethod:@"GET"];
    NSLog(@"request is %@",request);
    NSData* returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    return returnData;
}


+(BOOL) testDownloadUrl:(NSString*)url{
    
    NSURL* urlT = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:urlT cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TAKO_DOWNLOAD_URL_TEST_TIME_OUT];
    [request setHTTPMethod:@"HEAD"];
    NSData* returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (returnData==nil) {
        DDLogError(@"error!!! fetch http error...");
        return NO;
    }
    return YES;
    
}



@end
