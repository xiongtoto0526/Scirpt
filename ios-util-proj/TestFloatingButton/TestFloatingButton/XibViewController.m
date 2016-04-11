//
//  XibViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/10.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "XibViewController.h"

@interface XibViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bt;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation XibViewController


-(instancetype)init{
    NSBundle* bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyTako.bundle"]];

    self = [super initWithNibName:@"XibViewController" bundle:bundle];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bt addTarget:self action:@selector(showOrHidePicture:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showOrHidePicture:(id)sender{
    NSLog(@"hello, picture...");
    [self.image setHidden:!self.image.isHidden];
}

@end
