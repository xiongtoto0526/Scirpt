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

// notes: this mehod maybe do nothing if your xib is auto-layout enabled
-(void) addBorderonButton:(UIButton*) btn cornerSize:(int) size{
    UIColor* systemBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    btn.layer.borderColor = systemBlue.CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = size;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UIButton* newbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [newbt setTitle:@"悬浮按钮2" forState:UIControlStateNormal];
    newbt.frame = CGRectMake(20, 20, 100, 40);
    [newbt addTarget:self action:@selector(sayHello) forControlEvents:UIControlEventTouchUpInside];

    newbt.backgroundColor = [UIColor redColor];
    [self.view addSubview:newbt];
    
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];

    
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
