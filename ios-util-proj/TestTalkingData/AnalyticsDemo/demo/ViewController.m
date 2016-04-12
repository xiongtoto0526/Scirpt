//
//  ViewController.m
//  demo
//
//  Created by liweiqiang on 15/7/20.
//  Copyright (c) 2015 Beijing Tendcloud Tianxia Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "TalkingData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [TalkingData trackEvent:@"myEvent1"];
            break;
        case 2:
            [TalkingData trackEvent:@"myEvent1" label:@"label1"];
            break;
        case 3: {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"value", @"string",
                                 [NSNumber numberWithInt:10], @"int",
                                 [NSNumber numberWithShort:8], @"short",
                                 [NSNumber numberWithLongLong:7788], @"int64",
                                 [NSNumber numberWithDouble:10.3], @"double",
                                 [NSNumber numberWithBool:YES], @"bool",
                                 [NSNumber numberWithUnsignedInt:30], @"uint", nil];
            [TalkingData trackEvent:@"myEvent1" label:@"label1" parameters:dic];
            break;
        }
        case 4: {
            SecondViewController *second = [[SecondViewController alloc] init];
            [self presentViewController:second animated:YES completion:nil];
            break;
        }
        case 5:
            [[NSArray array] objectAtIndex:NSIntegerMax];
            break;
        case 6:
            raise(SIGSEGV);
            break;
        default:
            break;
    }
}

@end
