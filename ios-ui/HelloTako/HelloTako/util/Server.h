//
//  UIHelper.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version.h"
#import "User.h"
#import "App.h"

@interface TakoServer : NSObject

+(TakoVersion*)fetchVersion;

+(NSString*)fetchItermUrl:(NSString*)versionId password:(NSString*)password;

+(NSMutableArray*)fetchApp:(NSString*)cursor;

+(TakoApp*)fetchAppWithid:(NSString*)appid;

+(NSString*)fetchDownloadUrl:(NSString*)versionId password:(NSString*)password;

+(TakoUser*)authEmail:(NSString*)email password:(NSString*)password;

+(NSData*)postWithDict:(NSDictionary*)dict url:(NSString*)methodUrl;

+(NSData*)getWithUrl:(NSString*)methodUrl;

@end
