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

@interface TakoServer : NSObject

+(TakoVersion*)fetchVersion;

+(NSMutableArray*)fetchApp:(NSString*)cursor;

+(NSString*)fetchDownloadUrl:(NSString*)versionId password:(NSString*)password;

+(TakoUser*)authEmail:(NSString*)email password:(NSString*)password;

+(NSData*)postWithDict:(NSDictionary*)dict url:(NSString*)methodUrl;

+(NSData*) getWithUrl:(NSString*)methodUrl;

@end
