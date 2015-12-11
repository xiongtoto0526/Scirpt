//
//  DesUtil.m
//
//  Created by XmL on 14-2-12.
//  Copyright (c) 2014年. All rights reserved.
//

#import "YGDesUtils.h"
#import <CommonCrypto/CommonCryptor.h>
//#import "YGConstants.h"
//#import "GTMBase64.h"


@implementation YGDesUtils
static Byte iv[] = {1,2,3,4,5,6,7,8};
static const NSString *encryKey = @"1a8.jf65;j^f2v-0";

+(NSString *) encryptUseDES:(NSString *)plainText{
    return [self encryptUseDES:plainText key:(NSString *)encryKey];
}
/*
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key{
    return [self encryptDES:plainText key:key option:kCCOptionPKCS7Padding];
}

+(NSString *) encryptModeDES:(NSString *)plainText {
    return [self encryptUseDES:plainText key:(NSString *)encryKey];
}

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
        NSString* result2 =[dataTemp base64EncodedStringWithOptions:0];
        NSLog(@"res is :%@",result2);
    }else{
//        iLog(@"DES加密失败");
    }
    return cipherText;
}

// DES解密
+(NSString*) decryptUseDES:(NSString*)cipherText{
    return [self decryptUseDES:cipherText key:(NSString *)encryKey];
}

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString *)key {
    return [self decryptDES:cipherText key:key option:kCCOptionPKCS7Padding];
}

+(NSString*) decryptModeDES:(NSString*)cipherText{
    return [self decryptUseDES:cipherText key:(NSString *)encryKey];
}

+(NSString*) decryptModeDES:(NSString*)cipherText key:(NSString *)key{
    return [self decryptDES:cipherText key:key option:kCCOptionPKCS7Padding|kCCOptionECBMode];
}

+(NSString*) decryptDES:(NSString*)cipherText key:(NSString *)key option:(CCOptions)option{
    // 利用 GTMBase64 解码 Base64 字串
    NSData* cipherData =nil;
//    NSData* cipherData = [GTMBase64 decodeString:cipherText];
//    unsigned char buffer[1024];
    char* buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          option,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
        
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    return plainText;
}


//将十进制转化为二进制,设置返回NSString 长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}

//将十进制转化为十六进制
- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

//将16进制转化为二进制
-(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binaryString=[[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //iLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
//    iLog(@"转化后的二进制为:%@",binaryString);
    
    return binaryString;
    
}



@end
