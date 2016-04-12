//
//  GlanceController.m
//  demo WatchKit Extension
//
//  Created by liweiqiang on 15/7/20.
//  Copyright (c) 2015 Beijing Tendcloud Tianxia Technology Co., Ltd. All rights reserved.
//

#import "GlanceController.h"
#import "TalkingData.h"

@interface GlanceController()

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [TalkingData initWithWatch:@"E7538D90715219B3A2272A3E07E69C57"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [TalkingData trackPageBegin:@"Glance" withPageType:TDPageTypeGlance];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [TalkingData trackPageEnd:@"Glance"];
}

@end



