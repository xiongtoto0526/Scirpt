//
//  ViewController.m
//  Testme2
//
//  Created by 熊海涛 on 15/12/1.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "NSData+AES256.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* retdesc = [NSString stringWithFormat:@"收到ios_jinshan支付回调,结果描述:%@",nil];
    NSLog(@"rest :%@",retdesc);
    NSString* content = @"帝国塔防3";
    NSString* key = @"XG_45550B8C7C3242CB4CFF409AA4BB98EE";
    NSString* ret = [NSData AES256EncryptWithPlainText:content withKey:key];
    NSLog(@"ret is :%@",ret);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
