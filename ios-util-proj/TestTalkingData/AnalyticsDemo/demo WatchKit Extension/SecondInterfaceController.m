//
//  SecondInterfaceController.m
//  demo
//
//  Created by liweiqiang on 15/7/21.
//  Copyright (c) 2015 Beijing Tendcloud Tianxia Technology Co., Ltd. All rights reserved.
//

#import "SecondInterfaceController.h"
#import "TalkingData.h"

@interface SecondInterfaceController ()

@end

@implementation SecondInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [TalkingData trackPageBegin:@"watch_second_page" withPageType:TDPageTypeWatchApp];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [TalkingData trackPageEnd:@"watch_second_page"];
}

@end



