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


#define LOGIN_EMAIL_KEY @"email"
#define LOGIN_PASSWORD_KEY @"password"
#define COMMON_RET_KEY @"ret"
#define COMMON_DATA_KEY @"data"
#define LOGIN_USERID_KEY @"userid"
#define LOGIN_USERTOKEN_KEY @"token"
#define LOGIN_USERNICKNAME_KEY @"nickname"

@implementation TakoServer

+(TakoVersion*)fetchVersion{
    TakoVersion* version = [TakoVersion new];
    version.versionId = @"1";
    version.versionName=@"1.3.1";
    return version;
}

+(NSString*)fetchItermUrl:(NSString*)versionId password:(NSString*)password{
    
    NSString* result = nil;
    NSString* url = nil;
    if (password!=nil) {
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
        NSLog(@"fetch iterm url error...");
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
        NSLog(@"fetch error...");
        return result;
    }
    
    NSNumber* resultCode = (NSNumber*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY];
    if ([resultCode longValue] == 0) {
        NSLog(@"fetch success....");
        NSDictionary* dataDict = (NSDictionary*)[XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_DATA_KEY];
        
        NSDictionary* appDict = [dataDict objectForKey:@"app"];
        result =  [[TakoApp new] initWithDictionary:appDict];
//        result.isSuccessed = [self isAppDownloadedBefore:result.versionId];  // 添加下载标志
    }
    return result;
}

+(NSMutableArray*)fetchApp:(NSString*)cursor{
    
    NSMutableArray* result = [NSMutableArray new];
    
    NSString* url = [NSString stringWithFormat:@"/gettaskapps?cursor=%@&count=%@&pid=%@",cursor,TAKO_SERVER_FETCH_SIZE,@"1"];
    NSData* returnData = [self getWithUrl:url];
    if (returnData==nil) {
        return result;
    }
    
    // 解析结果
    NSString* retjson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"http response is ...%@",retjson);// 量太大,暂时不log
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        NSLog(@"fetch error...");
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
    if (password==nil) {
        response = [self getWithUrl:[NSString stringWithFormat:@"/app/version/download/url?id=%@",versionId]];
    }else{
        response = [self getWithUrl:[NSString stringWithFormat:@"/app/version/download/url?id=%@&password=%@",versionId,password]];
    }
    
    // 处理http结果
    if(response == nil){
        NSLog(@"http error...");
        return result;
    }
    
    NSString* retjson = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"http response is ...%@",retjson);
    if([XHTUIHelper objectWithJsonStr:retjson byKey:COMMON_RET_KEY]==nil){
        NSLog(@"http error...");
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
        app.version=[NSString stringWithFormat:@"%d.%d.%d",i+1,i+1,i+1];
        app.firstcreated=@"2015-11-09";
        app.appid=[NSString stringWithFormat:@"appid%d",i];
        [result addObject:app];
    }
    return result;
}

+(TakoUser*)authEmail:(NSString*)email password:(NSString*)password{
    if ([email isEqualToString: @"c@kingsoft.com"]) {
        email = @"carson510@126.com";
        password = @"123456";
    }else if ([email isEqualToString: @"x@kingsoft.com"]){
        email = @"547610328@qq.com";
        password = @"123456";
    }
//    email = @"carson510@126.com";
//    password = @"123456";
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:email forKey:LOGIN_EMAIL_KEY];
    [dict setObject:password forKey:LOGIN_PASSWORD_KEY];
    NSData* retData = [self postWithDict:dict url:@"/login"];
    
    // 解析结果
    if(retData == nil){
        NSLog(@"http error...");
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
    NSData* bodyData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString* serverUrl = [NSString stringWithFormat:@"%@%@",[XHTUIHelper hostFromInfoPlist],methodUrl];
    NSURL* url = [[NSURL alloc] initWithString:serverUrl];
    NSLog(@"url is %@", url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TAKO_SERVER_TIME_OUT];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    NSLog(@"setHTTPBody data = %@",[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding]);

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
//    
//  
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",[XHTUIHelper hostFromInfoPlist],methodUrl];
    NSLog(@"url is:%@",urlstr);
    NSURL* url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TAKO_SERVER_TIME_OUT];
    [request setHTTPMethod:@"GET"];
    NSLog(@"request is %@",request);
    NSData* returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return returnData;
}




@end
