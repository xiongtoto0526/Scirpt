//
//  ViewController.m
//  TestSubInteface
//
//  Created by 熊海涛 on 16/4/28.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "RootInterface.h"

//@implementation RootInterface
//
//@end

//@interface SubInterface : RootInterface
//
//@end
//
//@implementation SubInterface
//
//@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
////    RootInterface* r = [RootInterface new];
////    NSLog(@"root is;%@",r);
//    SubInterface* s = [SubInterface new];
    id myObj = NSClassFromString(@"RootInterface");
    

    NSLog(@"root is;%@",myObj);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
