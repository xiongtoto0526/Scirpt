//
//  EditImageViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/12.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "EditImageViewController.h"
#import "DRPDrawView.h"
#import "UIHelper.h"
#import "TakoSdk.h"

@interface EditImageViewController ()<DRPDrawViewDelegate>{
    BOOL isDrawed;
    UIBarButtonItem* saveButtonItem;
    UIBarButtonItem* space;
    UIBarButtonItem* clearButtonItem;
}
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic)  DRPDrawView *drawView;

@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏touchAssist,防止影响截屏
    [[TakoSdk share] hide];
    
    isDrawed = NO;
    [super viewDidLoad];
    [self.image setImage:self.preImage];
    // 防止图片尺寸被压缩或拉伸，将contentMode收属性设置为：UIViewContentModeScaleAspectFit。
    [self.image setContentMode:UIViewContentModeScaleAspectFit];
    self.image.clipsToBounds  = YES;

    [self.clearButton addTarget:self action:@selector(clearDrawView) forControlEvents:UIControlEventTouchDown];
    self.title = @"涂鸦";
    DRPDrawView *drawView = [[DRPDrawView alloc] initWithFrame:self.image.frame];
    drawView.delegate = self;
    [self.view addSubview:drawView];
    self.drawView = drawView;
    
    self.navigationController.navigationBar.translucent = YES;//????
     saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                       style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    
    
    space =  [[UIBarButtonItem alloc] initWithTitle:@" "
                                                  style:UIBarButtonItemStyleDone target:nil action:nil];
    
    clearButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"擦除"
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonClicked)];
    

    
    NSArray* items = [NSArray arrayWithObjects:saveButtonItem,nil];
    self.navigationItem.rightBarButtonItems = items;

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 恢复touchAssist
    [[TakoSdk share] show];
}

-(void)clearButtonClicked{
    [self.drawView clearDrawing];
    NSArray* items = [NSArray arrayWithObjects:saveButtonItem,nil];
    self.navigationItem.rightBarButtonItems = items;
}

-(void)saveButtonClicked{
    
    // 防止截屏时引入将导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    UIImage* image =  [UIHelper takeScreenshot];
    [self.navigationController.navigationBar setHidden:NO];
    [self.delegate imageEditFinish:image];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)clearDrawView{
    [self.drawView clearDrawing];
    isDrawed = NO;
    NSArray* items = [NSArray arrayWithObjects:saveButtonItem,nil];
    self.navigationItem.rightBarButtonItems = items;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 涂鸦回调
- (void)didStartDrawingInView:(DRPDrawView *)drawView{
//    NSLog(@"begin draw...");
    
}
-(void)drawingInView:(DRPDrawView *)drawView{
    isDrawed = YES;
    NSArray* items = [NSArray arrayWithObjects:saveButtonItem,space,clearButtonItem,nil];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)didStopDrawingInView:(DRPDrawView *)drawView{
//    NSLog(@"end draw...");
  
}

//todo: 1.sdk-hide,sdk-show 2.将button和image对应

@end
