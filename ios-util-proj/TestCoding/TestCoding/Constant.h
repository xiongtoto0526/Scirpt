//
//  Constant.h
//  TestCoding
//
//  Created by 熊海涛 on 16/4/11.
//  Copyright © 2016年 熊海涛. All rights reserved.
//



// 注意：大量用宏会导致二进制文件变大
#define TEST_STR @"test-st"

//　const简介:之前常用的字符串常量，一般是抽成宏，但是苹果不推荐我们抽成宏，推荐我们使用const常量。
extern NSString *const XUserName;

@interface Constant : NSObject {
    
}

@end





