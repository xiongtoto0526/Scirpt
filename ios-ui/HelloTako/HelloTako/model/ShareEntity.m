//
//  ShareEntity.m
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEntity.h"
#import "UIHelper.h"
#import "Constant.h"

static ShareEntity* share=nil;

@implementation  ShareEntity
+(ShareEntity*) shareInstance{
    @synchronized(self){
        if(share==nil){
            share=[[super alloc]init];
        }
            return share;
   }
}

@end