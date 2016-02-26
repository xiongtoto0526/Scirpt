//
//  UIHelper.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version.h"

@interface TakoServer : NSObject

+(TakoVersion*)fetchVersion;

+(NSArray*)fetchApp;

@end
