//
//  ViewController.m
//  TestAutoLayout
//
//  Created by 熊海涛 on 16/4/13.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "FourSplitViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)openNew:(id)sender{
    [self presentViewController:[FourSplitViewController new] animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
