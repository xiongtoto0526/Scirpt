
#ifndef xgCommon_httpUtil_h
#define xgCommon_httpUtil_h


@interface httpUtil : NSObject

+(NSString*) httpSendSynchronousWithGetUrl:(NSString*)requestUrl withmethod:(NSString*)method withParams:(NSDictionary*) parameters;

+(NSString*) httpSendSynWithGetUrl:(NSString *)requestUrl withmethod:(NSString *)method withParams:(NSDictionary *)parameters;

+(NSString*) prepareParams:(NSDictionary*) params withMethod:(NSString*)method;

+(NSString*) httpGetWithUrl:(NSString*)requestUrl withmethod:(NSString*)method withParams:(NSDictionary*) parameters finishBlock:(void(^)(NSInteger retCode, NSDictionary* retContent)) block;

+ (NSString*)urlEncodedString:(NSString*)stringToEncode;

+ (NSString *)md5Digest:(NSString *)str;


@end

#endif
