#import "Util.h"
#import "sdk_bi_client.h"
#import "constant.h"
#import "xgPublicDefine.h"
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <objc/runtime.h>
#import <zlib.h>

@implementation Util

//支持plist和debugMode两种模式。优先读取debugMode的设置。
+ (NSString *) dataUrlFromInfoPlist
{
    NSString* debugMode =[Util infoPlistValueForKey:DEBUG_MODE_KEY];
    if( nil == debugMode){
        debugMode =[Util infoPlistValueForNewKey:XGSDK_DEBUG_MODE_KEY];
    }
    NSString* ret=nil;
    
    if (debugMode!=nil) {
        XGLog(@"will use debugMode configuration....");
        switch ([debugMode intValue]) {
            case 0:
                XGLog(@"will use onsite params...");
                ret = onsite_XgDataUrl;
                break;
            case 1:
                XGLog(@"will use test params...");
                ret = test_XgDataUrl;
                break;
            case 2:
                XGLog(@"will use dev params...");
                ret = dev_XgDataUrl;
                break;
                
            default:
                XGLog(@"config error!!please check, debugMode can be only in: 0,1,2 ");
                XGLog(@"0: 正式环境 ");
                XGLog(@"1: 测试环境 ");
                XGLog(@"2: ci环境 ");
                break;
        }
    }
    else{
      XGLog(@"will use plist configuration....");
        
        ret = [Util infoPlistValueForKey:XgDataUrl];
        if (ret==nil) {
            ret = [Util infoPlistValueForNewKey:XGSDK_DataUrl];
        }
    }
    XGLog(@"data url is: %@",ret);
    return ret;
    
}

//支持plist和debugMode两种模式。优先读取debugMode的设置。
+ (NSString *) payUrlFromInfoPlist
{
    NSString* debugMode =[Util infoPlistValueForKey:DEBUG_MODE_KEY];
    if( nil == debugMode){
        debugMode =[Util infoPlistValueForNewKey:XGSDK_DEBUG_MODE_KEY];
    }
    NSString* ret=nil;
    
    if (debugMode!=nil) {
        XGLog(@"will use debugMode configuration....");
        switch ([debugMode intValue]) {
            case 0:
                XGLog(@"will use onsite params...");
                ret = onsite_XgRechargeUrl;
                break;
            case 1:
                XGLog(@"will use test params...");
                ret = test_XgRechargeUrl;
                break;
            case 2:
                XGLog(@"will use dev params...");
                ret = dev_XgRechargeUrl;
                break;
                
            default:
                XGLog(@"config error!!please check, debugMode can be only in: 0,1,2 ");
                XGLog(@"0: 正式环境 ");
                XGLog(@"1: 测试环境 ");
                XGLog(@"2: ci环境 ");
                break;
        }
    }
    else{
        XGLog(@"will use plist configuration....");
        
        ret = [Util infoPlistValueForKey:XgRechargeUrl];
        if (ret==nil) {
            ret = [Util infoPlistValueForNewKey:XGSDK_RechargeUrl];
        }
    }
    XGLog(@"rechargeUrl url is: %@",ret);
    return ret;

}

//支持plist和debugMode两种模式。优先读取debugMode的设置。
+ (NSString *) authUrlFromInfoPlist
{
    NSString* debugMode =[Util infoPlistValueForKey:DEBUG_MODE_KEY];
    if( nil == debugMode){
        debugMode =[Util infoPlistValueForNewKey:XGSDK_DEBUG_MODE_KEY];
    }
    NSString* ret=nil;
    
    if (debugMode!=nil) {
        XGLog(@"will use debugMode configuration....");
        switch ([debugMode intValue]) {
            case 0:
                XGLog(@"will use onsite params...");
                ret = onsite_XgAuthUrl;
                break;
            case 1:
                XGLog(@"will use test params...");
                ret = test_XgAuthUrl;
                break;
            case 2:
                XGLog(@"will use dev params...");
                ret = dev_XgAuthUrl;
                break;
                
            default:
                XGLog(@"config error!!please check, debugMode can be only in: 0,1,2 ");
                XGLog(@"0: 正式环境 ");
                XGLog(@"1: 测试环境 ");
                XGLog(@"2: ci环境 ");
                break;
        }
    }
    else{
        
        XGLog(@"will use plist configuration....");
        ret = [Util infoPlistValueForKey:XgAuthUrl];
        if (ret==nil) {
            ret = [Util infoPlistValueForNewKey:XGSDK_AuthUrl];
        }
    }
    XGLog(@"authUrl url is: %@",ret);
    return ret;
    
}

+ (NSString *) notifyUrlFromInfoPlist
{
    NSString* notifyUrl = [Util infoPlistValueForKey:XgNotifyUrl];
    if(nil == notifyUrl){
        notifyUrl = [Util infoPlistValueForNewKey:XGSDK_NotifyUrl];
    }
    XGLog(@"notifyUrl is..%@",notifyUrl);
    return notifyUrl;
}


+ (NSString *) appIDFromInfoPlist
{
    NSString* appID = [Util infoPlistValueForKey:APPID_KEY];
    XGLog(@"info value 1 is:%@",appID);
    if (appID == nil) {
        XGLog(@"will use bundle info plist...");
        appID = [Util infoPlistValueForNewKey:CHANNEL_APPID_KEY];
        XGLog(@"info value 2 is:%@",appID);
    }
    XGLog(@"appID result is..%@",appID);
    return appID;
}

+ (NSString *) channelIDFromInfoPlist
{
    NSString* channelId = [Util infoPlistValueForKey:CHANNELID_KEY];
    if(nil == channelId){
        channelId = [Util infoPlistValueForNewKey:XGSDK_CHANNELID_KEY];
    }
    return channelId;
}

+ (NSString *) appKeyFromInfoPlist
{
    NSString* channleAppid = [Util infoPlistValueForKey:APPKEY_KEY];
    if(nil == channleAppid){
        channleAppid = [Util infoPlistValueForNewKey:CHANNEL_APPKEY_KEY];
    }
    return channleAppid;
}


+ (NSString *) sdkAppIDFromInfoPlist
{
    NSString* xgSdkAppid = [Util infoPlistValueForKey:SDK_APPID_KEY];
    if(nil == xgSdkAppid){
        xgSdkAppid = [Util infoPlistValueForNewKey:XGSDK_APPID_KEY];
    }
    return xgSdkAppid;
}

+ (NSString *) md5keyFromInfoPlist
{
    NSString* md5Str = [Util infoPlistValueForKey:SDK_MD5_KEY];
    if(nil == md5Str){
        md5Str = [Util infoPlistValueForNewKey:CHANNEL_MD5_KEY];
    }
    return md5Str;
}

+ (NSString *) appSchemFromInfoPlist
{
    NSString* schemeStr = [Util infoPlistValueForKey:SDK_APPSCHEME_KEY];
    if(nil == schemeStr){
        schemeStr = [Util infoPlistValueForNewKey:CHANNEL_APPSCHEME_KEY];
    }
    return schemeStr;
}


+ (NSString *) bundleIDFromInfoPlist
{
    NSString* bundleId = [Util infoPlistValueForNewKey:XGSDK_BUNDLE_ID];
    return bundleId;
}


+ (NSString *) serverVersionFromInfoPlist
{
    NSString* serverVersion = [Util infoPlistValueForNewKey:XGSDK_SERVER_VERSION];
    return serverVersion;
}


+ (NSString *) orinetationFromInfoPlist
{
    NSString* orientation = [Util infoPlistValueForNewKey:XGSDK_ORIENTATION];
    return orientation;
}




+ (NSString *) buildNumberFromInfoPlist
{
    NSString* buildNumber = [Util infoPlistValueForNewKey:XGSDK_BUILD_NUMBER];
    return buildNumber;
}

+ (NSString *) planIdFromInfoPlist
{
    NSString* planId = [Util infoPlistValueForNewKey:XGSDK_PLAN_ID];
    return planId;
}

+ (NSString *) sdkAppKeyFromInfoPlist
{
    NSString* agSdkAppKey = [Util infoPlistValueForKey:SDK_APPKEY_KEY];
    if(nil == agSdkAppKey){
        agSdkAppKey = [Util infoPlistValueForNewKey:XGSDK_APPKEY_KEY];
    }
    return agSdkAppKey;
}


//从独立的plist文件中读取xgsdk生成的key值。
+ (NSString *) infoPlistValueForNewKey:(NSString *) Newkey
{
    if (Newkey==nil)
    {
        return nil;
    }
    
    NSString* channelId = [Util channelIDFromInfoPlist];
    NSString* plistFileName = [NSString stringWithFormat:@"xgsdk_%@_info",channelId];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];

    if(plistPath == nil){
        return nil;
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(dictionary == nil){
        return nil;
    }
    NSLog(@"key :%@,value:%@",Newkey,[dictionary valueForKey:Newkey]);
    return [dictionary valueForKey:Newkey];
}

+ (NSString *) infoPlistValueForKey:(NSString *) key
{
    if (key==nil)
    {
        return nil;
    }
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

+ (NSString * ) jsonDataWithDict: (NSMutableDictionary*) dict withDefaultValue: (NSString*) defValue
{
    if (dict==nil) {
        return defValue;
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return stringData;
}


+ (NSString *) getJsonValueWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key withDefaultValue: (NSString*) defValue
{
    NSString* retStr=nil;
    id ret=nil;
    NSData* tempData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if(tempData != nil){
        ret = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
        if(ret != nil && [ret isKindOfClass:[NSDictionary class]]){
            NSDictionary* retDict = (NSDictionary*)ret;
            ret = [retDict objectForKey:key];
        }
    }
    
    if(ret==nil)
    {
        retStr = defValue;
    }else{
        retStr = (NSString*)ret;
    }
    
    return retStr;
}


+ (NSDictionary *) getDictValueWithJsonStr: (NSString*) jsonStr byKey: (NSString*) key
{
    if (jsonStr==nil||key==nil) {
        return nil;
    }
    NSDictionary* retStr=nil;
    id ret=nil;
    NSData* tempData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if(tempData != nil){
        ret = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
        if(ret != nil && [ret isKindOfClass:[NSDictionary class]]){
            NSDictionary* retDict = (NSDictionary*)ret;
            ret = [retDict objectForKey:key];
        }
    }
    
    if([ret isKindOfClass:[NSDictionary class]])
    {
        retStr = (NSDictionary*)ret;
    }
    
    return retStr;
}



+(NSDictionary*) dictoryWithJsonString:(NSString*) jsonString{
    NSData* tempData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* retDict=nil;
    id ret;
    if(tempData != nil){
        ret = [NSJSONSerialization JSONObjectWithData:tempData options:0 error:nil];
        if(ret != nil && [ret isKindOfClass:[NSDictionary class]]){
            retDict = (NSDictionary*)ret;
        }
    }
    return retDict;
}




#pragma mark - private
+ (NSMutableURLRequest *)createPostRequestWithUrl:(NSString *)url
                                           params:(NSDictionary *)params {
    NSMutableString* strBody = [NSMutableString stringWithFormat:@"%@",@""];
    
    if (params) {
        BOOL isFirst = YES;
        for (NSString* key in [params allKeys]) {
            if (isFirst) {
                isFirst = NO;
            }
            else
                [strBody appendString:@"&"];
            
            [strBody appendString:key];
            NSString* val = (NSString*)[params objectForKey:key];
            [strBody appendString:@"="];
            [strBody appendString:val];
        }
    }
    
    NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:nsurl];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData* postData = [strBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    return request;
}

+ (NSMutableURLRequest *)createGetRequestWithUrl:(NSString *)url
                                          params:(NSDictionary *)params {
    NSMutableString* strBody = [NSMutableString stringWithFormat:@"%@",url];
    
    if (params) {
        for (NSString* key in [params allKeys]) {
            [strBody appendString:@"&"];
            [strBody appendString:key];
            NSString* val = (NSString*)[params objectForKey:key];
            [strBody appendString:@"="];
            [strBody appendString:val];
        }
    }
    
    NSURL *nsurl = [NSURL URLWithString:[strBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:nsurl];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:20];
    
    return request;
}


+ (NSString*)deviceId{
    NSString *adId = [[UIDevice currentDevice].identifierForVendor UUIDString];;
    return adId;
}

+(NSString*)deviceBrand{
    UIDevice* dev =[UIDevice currentDevice];
    NSString* osVersion= [NSString stringWithFormat:@"%@_%@",dev.systemName,dev.systemVersion] ;
    return osVersion;
}

+(NSString*)deviceModel{
   return [UIDevice currentDevice].model;
}


+(NSString*) getCurrentTimeWithFormat:(NSString*) format
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:format];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    return date;
}

+(BOOL) isEmptyString:(NSString*) inputString{
    NSLog(@"input string is:%@",inputString);
    return inputString==nil || inputString.length==0;
}

+(BOOL)isEmptyStringOfObject:(id)object
{
    return [object isKindOfClass:[NSNull class]]|| object == nil ||[object isEqualToString:@"(null)"];
}

+(BOOL)booValueOfString:(NSString *)inputString
{
    if ((![self isEmptyStringOfObject:inputString]) && [inputString isEqualToString:@"Y"]) {
        return YES;
    }
    return NO;
}

+(NSString*) currentTimeMS{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString* ret = [NSString stringWithFormat:@"%llu",recordTime];
    return ret;
}

+(void) setDictValue:(NSMutableDictionary*) dict withObject:(id)object forKey:(NSString*)key{
    if(object != nil && dict!=nil){
        [dict setObject:object forKey:key];
    }
}

+(BOOL) callbackEvent:(NSString*) type beginTime:(NSDate*)beginTime eventId:(NSString*)eventId{
    if (beginTime!=nil) {
        int diff=round(-[beginTime timeIntervalSinceNow]*1000);
        NSString* msg = [NSString stringWithFormat:@"xgsdk %@ finish,cost %d ms.",type,diff];
        NSLog(@"%@",msg);
        
        id myClass = NSClassFromString(@"SdkBiClient");
        if (myClass==nil) {
            XGLog(@"no this class found...");
            return NO;
        }else{
            [myClass onEvent:eventId eventVal:[NSString stringWithFormat:@"%d",diff] eventDesc:msg Content:nil];
        }
    }
     return YES;
}


+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    NSLog(@"apple before sign is..%@",text);
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    NSLog(@"apple after sign is..%@",hash);
    return hash;
}

+(NSString*) randomUUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (__bridge NSString*)uuidString;
    return result;
}



+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
//        else
//        {
//            value = [self getObjectData:value];
//        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}


# pragma mark -- des
static Byte iv[] = {1,2,3,4,5,6,7,8};
+(NSString *) encryptModeDES:(NSString *)plainText key:(NSString *)key{
    return [self encryptDES:plainText key:key option:kCCOptionPKCS7Padding|kCCOptionECBMode];
}

+(NSString *) encryptDES:(NSString *)plainText key:(NSString *)key option:(CCOptions)option
{
    if ([plainText isEqualToString:@""]) {
        return @"";
    }
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          option,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    NSString* cipherText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cipherText =[dataTemp base64EncodedString];
    }else{
        NSLog(@"DES加密失败");
    }
    return cipherText;
}


/*
 NSdata initWithBase64EncodedString 仅ios7.0有效,故 decryptModeDES不建议使用
 */

//
//
//+(NSString*) decryptModeDES:(NSString*)cipherText key:(NSString *)key{
//    return [self decryptDES:cipherText key:key option:kCCOptionPKCS7Padding|kCCOptionECBMode];
//}
//
//
//+(NSString*) decryptDES:(NSString*)cipherText key:(NSString *)key option:(CCOptions)option{
//    
//    NSData* cipherData = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
//    //    unsigned char buffer[1024];
//    char* buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          option,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [cipherData bytes],
//                                          [cipherData length],
//                                          buffer,
//                                          1024,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
//        
//    }
//    return plainText;
//}


@end


@implementation NSData (Gzip)
#define SCFW_CHUNK_SIZE 16384
/**
 *  @brief  GZIP压缩
 *
 *  @param level 压缩级别
 *
 *  @return 压缩后的数据
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)roundf(level * 9);
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:SCFW_CHUNK_SIZE];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += SCFW_CHUNK_SIZE;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

/**
 *  @brief  GZIP压缩 压缩级别
 *
 *  @return 压缩后的数据
 */
- (NSData *)gzippedData
{
    return [self gzippedDataWithCompressionLevel:-1.0f];
}

/**
 *  @brief  GZIP解压
 *
 *  @return 解压后数据
 */
- (NSData *)gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength: [self length] * 1.5];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}

@end

@implementation NSData (Base64)


+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99,99, 99, 99, 99, 99,99, 99, 99, 99, 99,99,
        99, 99, 99, 99, 99,99, 99, 99, 99, 99,99, 99, 99, 99, 99,99,
        99, 99, 99, 99, 99,99, 99, 99, 99, 99,99, 62, 99, 99, 99,63,
        52, 53, 54, 55, 56,57, 58, 59, 60, 61,99, 99, 99, 99, 99,99,
        99,  0,  1,  2,  3, 4,  5,  6,  7,  8, 9, 10, 11, 12, 13,14,
        15, 16, 17, 18, 19,20, 21, 22, 23, 24,25, 99, 99, 99, 99,99,
        99, 26, 27, 28, 29,30, 31, 32, 33, 34,35, 36, 37, 38, 39,40,
        41, 42, 43, 44, 45,46, 47, 48, 49, 50,51, 99, 99, 99, 99,99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength /4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength =0;
    unsigned char accumulated[] = {0,0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] &0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] <<2) | (accumulated[1] >>4);
                outputBytes[outputLength++] = (accumulated[1] <<4) | (accumulated[2] >>2);
                outputBytes[outputLength++] = (accumulated[2] <<6) | accumulated[3];
            }
            accumulator = (accumulator +1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] <<2) | (accumulated[1] >>4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] <<4) | (accumulated[2] >>2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth /4) * 4;
    
    const char lookup[] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength /3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) *2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    long long outputLength =0;
    for (i = 0; i < inputLength -2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] &0x03) << 4) | ((inputBytes[i +1] & 0xF0) >>4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i +1] & 0x0F) <<2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i +2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] ='\r';
            outputBytes[outputLength++] ='\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] &0x03) << 4) | ((inputBytes[i +1] & 0xF0) >>4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i +1] & 0x0F) <<2];
        outputBytes[outputLength++] =  '=';
    }
    else if (i == inputLength -1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0x03) << 4];
        outputBytes[outputLength++] ='=';
        outputBytes[outputLength++] ='=';
    }
    
    //truncate data to match actual output length
    outputBytes =realloc(outputBytes, outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4)? result: nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}



@end




