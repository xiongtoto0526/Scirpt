//
//  ViewController.m
//  TestCoding
//
//  Created by 熊海涛 on 16/4/11.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"constant XUserName is:%@",XUserName);
    NSString* testString = @"d";
    [testString isEqualToString:XUserName];
    [testString isEqualToString:TEST_STR];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
