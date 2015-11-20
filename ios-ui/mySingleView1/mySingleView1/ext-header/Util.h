

#import <Foundation/Foundation.h>

#pragma mark ---------oldkeys

#define APPID_KEY             @"xgsdk_appid"        //渠道申请的
#define APPKEY_KEY            @"xgsdk_appkey"       //渠道申请的
#define CHANNELID_KEY         @"xgsdk_channelid"    //xgSDK分配的
#define SDK_APPID_KEY         @"xgsdk_sdkAppid"     //xgSDK分配的
#define SDK_APPKEY_KEY        @"xgsdk_sdkAppkey"    //xgSDK分配的
#define SDK_MD5_KEY           @"xgsdk_md5key"       //渠道用到特殊字段
#define SDK_APPSCHEME_KEY     @"xgsdk_appScheme"    //渠道用到特殊字段
#define DEBUG_MODE_KEY        @"xgsdk_debugMode"    //渠道用到特殊字段////
#define XgRechargeUrl         @"XgRechargeUrl"      //xgSDK用到的字段
#define XgAuthUrl             @"XgAuthUrl"          //xgSDK用到的字段
#define XgDataUrl             @"XgDataUrl"          //xgSDK用到的字段
#define XgNotifyUrl           @"XgNotifyUrl"        //xgSDK用到的字段/////

#pragma mark ---------newkeys
//ljz2015-4-1

#define CHANNEL_APPID_KEY       @"channelAppId"             //渠道申请的
#define CHANNEL_APPKEY_KEY      @"channelAppkey"            //渠道申请的
#define XGSDK_CHANNELID_KEY     @"xgsdkChannelId"           //xgSDK分配的
#define XGSDK_APPID_KEY         @"xgsdkAppId"               //xgSDK分配的
#define XGSDK_APPKEY_KEY        @"xgsdkAppKey"              //xgSDK分配的
#define CHANNEL_MD5_KEY         @"channelMd5Key"              //渠道用到特殊字段
#define CHANNEL_APPSCHEME_KEY   @"channelAppScheme"           //渠道用到特殊字段
#define XGSDK_DEBUG_MODE_KEY    @"xgsdkDebugMode"           //xgsdk用到特殊字段
#define XGSDK_AuthUrl           @"xgsdkAuthUrl"             //xgSDK用到的字段
#define XGSDK_RechargeUrl       @"xgsdkRechargeUrl"         //xgSDK用到的字段
#define XGSDK_DataUrl           @"xgsdkDataUrl"             //xgSDK用到的字段
#define XGSDK_NotifyUrl         @"channelNotifyUrl"           //渠道用到的字段

//xgsdk 2.0 新增
#define XGSDK_BUNDLE_ID   @"xgsdkBundleId"
#define XGSDK_PLAN_ID @"xgsdkPlanId"
#define XGSDK_BUILD_NUMBER @"xgsdkBuildNumber"
#define XGSDK_SERVER_VERSION @"xgsdkServerVersion"
#define XGSDK_ORIENTATION @"xgsdkOrientation"




//正式环境
#define onsite_XgRechargeUrl    @"http://onsite.recharge.xgsdk.com:8180"
#define onsite_XgAuthUrl        @"http://onsite.auth.xgsdk.com:8180"
#define onsite_XgDataUrl        @"http://onsite.data.xgsdk.com:8180"

//沙箱环境
#define test_XgRechargeUrl      @"http://recharge.xgsdk.com:8180"
#define test_XgAuthUrl          @"http://auth.xgsdk.com:8180"
#define test_XgDataUrl          @"http://data.xgsdk.com:6001"

//ci环境
#define dev_XgRechargeUrl       @"http://dev.recharge.xgsdk.com:38180"
#define dev_XgAuthUrl           @"http://dev.auth.xgsdk.com:38180"
#define dev_XgDataUrl           @"http://dev.data.xgsdk.com:38280"

typedef NS_ENUM(NSInteger, XGHttpResult)
{
    XGHttpSuccess = 1,
    XGHttpFailed=2,
    XGHttpTimeout=3,
};


@interface Util : NSObject

+ (NSString *) dataUrlFromInfoPlist;
+ (NSString *) payUrlFromInfoPlist;
+ (NSString *) authUrlFromInfoPlist;
+ (NSString *) notifyUrlFromInfoPlist;
+ (NSString *) appIDFromInfoPlist;

+ (NSString *) channelIDFromInfoPlist;

+ (NSString *) appKeyFromInfoPlist;


//2.0新增

+ (NSString *) planIdFromInfoPlist;

+ (NSString *) buildNumberFromInfoPlist;

+ (NSString *) bundleIDFromInfoPlist;

+ (NSString *) serverVersionFromInfoPlist;

+ (NSString *) orinetationFromInfoPlist;


+ (NSString *) infoPlistValueForKey:(NSString *) key;

+ (NSString *) infoPlistValueForNewKey:(NSString *) Newkey;

+ (NSString *) sdkAppKeyFromInfoPlist;

+ (NSString *) sdkAppIDFromInfoPlist;

+ (NSString *) md5keyFromInfoPlist;

+ (NSString *) appSchemFromInfoPlist;

+ (NSString *) getJsonValueWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key withDefaultValue: (NSString*) defValue;

+ (NSDictionary *) getDictValueWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key;

+ (NSString * ) jsonDataWithDict: (NSMutableDictionary*) dict withDefaultValue: (NSString*) defValue;

// http post
+ (NSMutableURLRequest *)createPostRequestWithUrl:(NSString *)url
                                           params:(NSDictionary *)params ;

// http get
+ (NSMutableURLRequest *)createGetRequestWithUrl:(NSString *)url
                                          params:(NSDictionary *)params ;


+(NSDictionary*) dictoryWithJsonString:(NSString*) jsonString;

+(void) setDictValue:(NSMutableDictionary*) dict withObject:(id)object forKey:(NSString*)key;

+(NSString*) getCurrentTimeWithFormat:(NSString*) format;
+ (NSString*)deviceId;
+(NSString*)deviceModel;
+(NSString*)deviceBrand;
+(NSString*) currentTimeMS;
+(BOOL) isEmptyString:(NSString*) inputString;
+(BOOL)isEmptyStringOfObject:(id)object;
+(BOOL)booValueOfString:(NSString *)inputString;
+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text;

+(BOOL) callbackEvent:(NSString*) type beginTime:(NSDate*)beginTime eventId:(NSString*)eventId;

// 生成36位随机字符串，例：2720A216-3D3A-427D-B739-D5AF61B2D4C9
+(NSString*) randomUUID;

+ (NSDictionary*)getObjectData:(id)obj;
@end



@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
@end
