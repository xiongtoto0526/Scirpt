//
//  UIHelper.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/11.
//  Copyright © 2015年 熊海涛. All rights reserved.
//


#import "Server.h"
#import "App.h"

@implementation TakoServer

+(TakoVersion*)fetchVersion{
    TakoVersion* version = [TakoVersion new];
    version.versionId = @"1";
    version.versionName=@"1.3.1";
    return version;
}


+(NSArray*)fetchApp{
    NSMutableArray* result = [NSMutableArray new];
    for (int i=0;i<3;i++) {
        TakoApp* app = [TakoApp new];
        app.name=[NSString stringWithFormat:@"app%d",i+1];
        app.version=[NSString stringWithFormat:@"%d.%d.%d",i+1,i+1,i+1];
        app.createTime=@"2015-11-09";
        app.size=@"3.1M";
//        app.image=nil;
        [result addObject:app];
    }
    return result;
}

@end
