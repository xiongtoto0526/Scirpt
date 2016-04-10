//
//  ViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "TakoSdk.h"

#define  mainS  [UIScreen mainScreen].bounds.size

@interface ViewController (){
    Boolean isExtended;
}
@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)UIButton *button;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* newbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [newbt setTitle:@"悬浮按钮2" forState:UIControlStateNormal];
    newbt.frame = CGRectMake(20, 20, 100, 40);
    [newbt addTarget:self action:@selector(sayHello) forControlEvents:UIControlEventTouchUpInside];

    newbt.backgroundColor = [UIColor redColor];
    [self.view addSubview:newbt];
    
    [self performSelector:@selector(createButton) withObject:nil afterDelay:0.1];

    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)sayHello{
    NSLog(@"hello.....");
}

-(void)openNew{
   [self presentViewController:[FirstViewController new] animated:YES completion:nil];

}

- (void)createButton
{
    [[TakoSdk share] takoSdkInit];
}


@end
