//
//  UIHelper.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface XHTUIHelper : NSObject

+ (void) addBorderonButton:(UIButton*) btn;

+ (void) setExtraCellLineHidden: (UITableView *)tableView;

//button圆角化
+ (void) disableDownloadButton:(UIButton*) btn;

+ (UIViewController *)getCurrentVC;

+ (CGSize) viewSizeWith: (UIView*) view;

+ (NSString*) readNSUserDefaultsWithkey:(NSString*) key;

+(id)readNSUserDefaultsObjectWithkey:(NSString*) key;

+ (void) writeNSUserDefaultsWithKey:(NSString*) key withValue:(NSString*) value;

+ (void)writeNSUserDefaultsWithKey:(NSString*) key withObject:(id) value;

+(void)alertWithNoChoice:(NSString*)msg view:(UIViewController*)view;

+ (void)clearAllUserDefaultsData;

+ (id) objectWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key;

+(void) setDictValue:(NSMutableDictionary*) dict withObject:(id)object forKey:(NSString*)key;

+(BOOL)isLogined;

+ (id) infoPlistValueForKey:(NSString *) key;

+(NSString*) hostFromInfoPlist;

+ (NSString *)localIPAddress;

+(NSString*)stringWithLong:(long long)longvalue;

+ (NSString*)formatByteCount:(long long)size;

+ (NSMutableArray*)getObjectKeys:(id)obj;

+ (NSDictionary*)getObjectData:(id)obj;

+(NSString*)md5withFile:(NSString*) path;

+(BOOL)isDevicefileValid:file md5:(NSString*)md5;

+(void)addleftViewforText:(UITextField*)t image:(NSString*)image;

@end
