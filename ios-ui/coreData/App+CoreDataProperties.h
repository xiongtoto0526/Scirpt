//
//  App+CoreDataProperties.h
//  coreData
//
//  Created by 熊海涛 on 16/3/9.
//  Copyright © 2016年 熊海涛. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "App.h"

NS_ASSUME_NONNULL_BEGIN

@interface App (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *appid;
@property (nullable, nonatomic, retain) NSString *currentlength;
@property (nullable, nonatomic, retain) NSDate *creattime;

@end

NS_ASSUME_NONNULL_END
