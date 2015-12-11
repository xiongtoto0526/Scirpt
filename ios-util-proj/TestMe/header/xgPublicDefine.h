//
//  xgPublicDefine.h
//  IOSShareSDK_Demo
//
//  Created by lijizhong on 15/5/18.
//  Copyright (c) 2015年 seasung. All rights reserved.
//

#ifndef IOSShareSDK_Demo_xgPublicDefine_h
#define IOSShareSDK_Demo_xgPublicDefine_h

#define Atag   1

#define XGLog(fmt, ...) \
do\
{\
if(1){\
NSLog((@"%s [Line %d] :" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);\
}\
} while(0);
#else
#define XGLog(fmt, ...)

#endif
