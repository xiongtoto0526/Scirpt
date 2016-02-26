//
//  ShareEntity.h
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#ifndef ShareEntity_h
#define ShareEntity_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareEntity : NSObject 
+(ShareEntity*) shareInstance;
@property (copy, nonatomic) NSString* userName;
@property (weak, nonatomic) UIImageView* userImage;
@property (copy, nonatomic) NSString* userAccount;
@property (nonatomic) BOOL  isLogined;
@end
#endif /* ShareEntity_h */
