//
//  Util.h
//  XGSDK
//
//  Created by 王刚 on 14/12/7.
//  Copyright (c) 2014年 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *) dataUrlFromInfoPlist;
+ (NSString *) payUrlFromInfoPlist;
+ (NSString *) authUrlFromInfoPlist;
+ (NSString *) notifyUrlFromInfoPlist;
+ (NSString *) appIDFromInfoPlist;

+ (NSString *) channelIDFromInfoPlist;

+ (NSString *) appKeyFromInfoPlist;

+ (NSString *) infoPlistValueForKey:(NSString *) key;

+ (NSString *) infoPlistValueForNewKey:(NSString *) Newkey;

+ (NSString *) sdkAppKeyFromInfoPlist;

+ (NSString *) sdkAppIDFromInfoPlist;

+ (NSString *) md5keyFromInfoPlist;

+ (NSString *) appSchemFromInfoPlist;

+ (NSString *) getJsonValueWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key withDefaultValue: (NSString*) defValue;

+ (NSString * ) jsonDataWithDict: (NSMutableDictionary*) dict withDefaultValue: (NSString*) defValue;

@end
