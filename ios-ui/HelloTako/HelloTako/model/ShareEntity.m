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
            share=[[ShareEntity alloc]init];
//            share.userAccount= [XHTUIHelper readNSUserDefaultsObjectWithkey:USER_ACCOUNT_KEY];
//            share.userName=[XHTUIHelper readNSUserDefaultsObjectWithkey:USER_NAME_KEY];
        }
            return share;
   }
}

@end