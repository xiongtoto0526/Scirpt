//
//  InterfaceController.m
//  demo WatchKit Extension
//
//  Created by liweiqiang on 15/7/20.
//  Copyright (c) 2015 Beijing Tendcloud Tianxia Technology Co., Ltd. All rights reserved.
//

#import "InterfaceController.h"
#import "TalkingData.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [TalkingData initWithWatch:@"E7538D90715219B3A2272A3E07E69C57"];
    }
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [TalkingData trackPageBegin:@"Interface" withPageType:TDPageTypeWatchApp];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [TalkingData trackPageEnd:@"Interface"];
}

- (IBAction)buttonClick:(WKInterfaceButton *)sender {
    [TalkingData trackEvent:@"myEvent"];
}

@end



