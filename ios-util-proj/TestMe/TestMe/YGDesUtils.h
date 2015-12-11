//
//  DesUtil.h
//
//  Created by XmL on 14-2-12.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGDesUtils : NSObject

/**
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText;
/**
 用指定的秘钥进行DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+(NSString *) encryptModeDES:(NSString *)plainText;
+(NSString *) encryptModeDES:(NSString *)plainText key:(NSString *)key;

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSString *)cipherText;
/**
 用指定的秘钥进行DES解密
 */
+(NSString *) decryptUseDES:(NSString *)cipherText key:(NSString *)key;

+(NSString*) decryptModeDES:(NSString*)cipherText;
+(NSString*) decryptModeDES:(NSString*)cipherText key:(NSString *)key;
@end
