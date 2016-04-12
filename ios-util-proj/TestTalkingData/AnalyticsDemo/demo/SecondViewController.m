//
//  SecondViewController.m
//  demo
//
//  Created by liweiqiang on 15/7/20.
//  Copyright (c) 2015 Beijing Tendcloud Tianxia Technology Co., Ltd. All rights reserved.
//

#import "SecondViewController.h"
#import "TalkingData.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"second_page";
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 20, 80, 30);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [TalkingData trackPageBegin:@"second_page"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [TalkingData trackPageEnd:@"second_page"];
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
