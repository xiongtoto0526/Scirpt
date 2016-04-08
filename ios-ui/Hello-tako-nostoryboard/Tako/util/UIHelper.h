//
//  UIHelper.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RKDropdownAlert.h"
#import "RootBarViewController.h"
//#import "CocoaLumberjack.h"

// alert
#import "MBProgressHUD.h"



@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@end


typedef void (^Md5FinishBlock) (int flag);

@interface XHTUIHelper : NSObject

+(void)forceTableViewToLeft:(UITableView *)tableView;

// 将tableviewcell中的分割线顶头，防止留空
+(void)forceCellToLeft:(UITableViewCell*)cell;

+(void)addNewAccount:(NSString*)account;

+(NSArray*)loadAllUsers;

//button圆角化
+(void) addBorderonButton:(UIButton*) btn cornerSize:(int) size;
+(void) addBorderonButton:(UIButton*) btn cornerSize:(int) size borderWith:(int)width;

+(void)formatNavigateColor:(UINavigationBar*)bar;
+(UIColor*)navigateColor;

//去除多余单元格
+ (void) setExtraCellLineHidden: (UITableView *)tableView;

//禁用cell中的按钮
+ (void) disableDownloadButton:(UIButton*) btn;

// 自动消失的tip
+(void)tipWithText:(NSString*)text;
+(void)tipWithText:(NSString*)text time:(int) time;

// 纯模态提示框
+(void)alertWithNoChoice:(NSString*)msg view:(UIViewController*)view;

// 获取当前view
+ (UIViewController *)getCurrentVC;

// 获取view外框size
+ (CGSize) viewSizeWith: (UIView*) view;

// 初始化barview
+(RootTabBarController*)initTabbar;

// textfield添加图片
+(void)addRightViewforText:(UITextField*)t image:(NSString*)image;

// 返回系统蓝色
+(UIColor*)systemColor;

// 菊花
+(MBProgressHUD*)modalAlertIn:(UIView*)view withText:(NSString*)text;

// 修改frame
+(CGRect)addFrame:(CGRect)frame addHeight:(float)height addWidth:(float)with;

// 设置frame
+(CGRect)setFrame:(CGRect)frame Height:(float)height Width:(float)with;

// 导航栏自定义按钮
+(UIButton*)navButtonWithImage:(NSString*) image;

// 是否深色
+(BOOL)isDarkColor:(UIColor *)newColor;

// userdefaults
+ (NSString*) readNSUserDefaultsWithkey:(NSString*) key;
+(id)readNSUserDefaultsObjectWithkey:(NSString*) key;
+ (void) writeNSUserDefaultsWithKey:(NSString*) key withValue:(NSString*) value;
+ (void)writeNSUserDefaultsWithKey:(NSString*) key withObject:(id) value;
+ (void)clearAllUserDefaultsData;

// 字符，对象处理
+ (id) objectWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key;
+(void) setDictValue:(NSMutableDictionary*) dict withObject:(id)object forKey:(NSString*)key;
+ (id) infoPlistValueForKey:(NSString *) key;
+ (NSString *)localIPAddress;
+(NSString*)stringWithLong:(long long)longvalue;
+ (NSString*)formatByteCount:(long long)size;
+ (NSMutableArray*)getObjectKeys:(id)obj;
+ (NSDictionary*)getObjectData:(id)obj;
+(NSString*)md5withFile:(NSString*) path;
+(void)isDevicefileValid:file md5:(NSString*)md5 finishBlock:(Md5FinishBlock) block;
+(void)removeDevicefile:(NSString*)file;
+(BOOL)isEmpty:(id)object;

// 业务utils
+(BOOL)isAppLoadBefore;
+(BOOL)isLogined;
+(BOOL) isOnsiteEnv;
+(NSString*) takoAppUrl;
+(NSString*) takoHost;

// cookie操作
+(void)saveLoginCookie;
+(void)removeLoginCookie;
+(void)updateLoginCookie;

// 设置ddlog
+(void)configDebugInfo;

// 动画
+(void)animateHide:(UIView*)view;
    
@end
