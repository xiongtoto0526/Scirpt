
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Util.h"
#import "httpUtil.h"
#import "XGSDK.h"



@interface HttpService : NSObject

+(NSString*) authInfoWithParamsDict:(NSDictionary*) paramDict;
+(NSString*) authInfoWithUid:(NSString*) uid name:(NSString*)name token:(NSString*)token;

+ (NSMutableDictionary*) getRequestDicionaryWithBuyinfo: (XGBuyInfo*) buyinfo;

+ (NSMutableDictionary*) getCommonRequestDicionaryWithBuyinfo: (XGBuyInfo*) buyinfo;

+(NSMutableDictionary*) initOrderParams:(XGBuyInfo*) buyInfo;

+ (NSString*) createAppleOrderWithParams: (NSDictionary*)requestParams;

+ (NSString*) createOrderWithParams: (NSDictionary*)requestParams;

+ (void) getOrderIdwithRequest: (NSDictionary*)requestParams whenSuccess:(void(^)(NSString* retContent))success whenfailure:(void(^)(NSInteger retCode))failure ;


// apple 更新订单
+(void) notifyXgServer:(NSString *)orderID sdkAppId:(NSString *)appID sdkAppKey:(NSString *)appKey sdkCustData:(NSString*) receiptData;

// apple 触发主动查询
+ (NSString*) searchAppleOrderWithParams: (NSDictionary*)requestParams;

/**
 @brief 更新订单
 */
+(void) updateOrder:(NSString*) orderID sdkAppId:(NSString*) appID sdkAppKey:(NSString*) appKey;

/**
 @brief 取消订单
 */
+(void) cancelOrder:(NSString*) orderID sdkAppID:(NSString*) appID sdkAppKey:(NSString*) appKey;

/**
 @brief 生成校验的Token
 */
+(NSString*) makeAuthToken:(NSString*)sessionID sdkAppID:(NSString*) appID sdkAppKey:(NSString*)appKey
                 channelID:(NSString*) channelID uid:(NSString*)uid name:(NSString*)name;

/**
 @brief 腾讯应用宝支付更新订单 ljz
 */
+(void) updateTencentOrderWithBuyinfo:(XGBuyInfo*) buyInfo withOtherInfo:(NSDictionary*)otherInfo;

/**
 @brief 腾讯应用宝支付创建订单前获取订单信息 ljz
 */
+(NSDictionary*) getTencentRequestDicionaryWithBuyinfo: (XGBuyInfo*) buyinfo withOtherInfo:(NSDictionary*)otherInfo;

/**
 @brief 腾讯应用宝支付更新余额 ljz
 */
+(void)refreshTencetBalancewithInfo:(NSDictionary*)refreshInfo;

/**
 @brief 生成腾讯校验的Token
 */
+(NSString*) makeTencentAuthToken:(NSString*) appID sdkAppKey:(NSString*)appKey
                        channelID:(NSString*) channelID uid:(NSString*)uid openKey:(NSString*)openKey clientIp:(NSString*)clientIp;
@end
