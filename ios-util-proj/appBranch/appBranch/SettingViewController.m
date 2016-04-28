//
//  SettingViewController.m
//  appBranch
//
//  Created by 熊海涛 on 16/4/1.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "SettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

#define  MAIN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  MAIN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,QRCodeReaderDelegate>
@property (nonatomic,strong) NSMutableArray* listData;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData = [NSMutableArray arrayWithObjects:@"测试",@"二维码扫描",@"测试开关",@"测试stepper",@"测试picker",@"测试本地推送",@"退出",nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    NSLog(@"clicked...");
    
    // 二维码扫描
    if (indexPath.row == 1) {
        if (![QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
             NSLog(@"Reader not supported by the current device");
            return;
        }
        static QRCodeReaderViewController *vc = nil;
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if (indexPath.row == 4) {
        NSLog(@"DataPicker 测试");
        UIViewController* dataController = [[UIViewController alloc] init];
        UIDatePicker* dp = [[UIDatePicker alloc] init];
        dp.datePickerMode = UIDatePickerModeDateAndTime;
        [dp addTarget:self action:@selector(dpValueChange:) forControlEvents:UIControlEventValueChanged];
        dataController.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
        dataController.view.backgroundColor = [UIColor whiteColor];
        [dataController.view addSubview:dp];
        UIButton* bt = [[UIButton alloc] initWithFrame:CGRectMake(10,200,40,40)];
        [bt addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchDown];
        [bt setTitle:@"返回" forState:UIControlStateNormal];
        bt.backgroundColor =[UIColor blackColor];
        [dataController.view addSubview:bt];

         [self presentViewController:dataController animated:NO completion:nil];
    }else if (indexPath.row == 5){
//        [self testLocalNotification];
    }
    else if (indexPath.row == 6){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


-(void)dpValueChange:(UIDatePicker*) sender{
    NSLog(@"datapicker value changed...%@",sender.date);
}

-(void)goback{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 系统原生的cell
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    UISwitch *switchControl = [[UISwitch alloc]initWithFrame:CGRectMake(0, 8, 25, 20)];
    [switchControl addTarget:self action:@selector(swValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIStepper *stepControl = [[UIStepper alloc]initWithFrame:CGRectMake(0, 8, 20, 20)];
    stepControl.minimumValue = 20;
    stepControl.maximumValue = 100;
    stepControl.stepValue = 20;
    stepControl.value = 21;
    [stepControl addTarget:self action:@selector(stepValueChanged:) forControlEvents:UIControlEventValueChanged];

    if (indexPath.row == 2) {
      cell.accessoryView = switchControl;
    }
    if (indexPath.row == 3) {
        cell.accessoryView = stepControl;
    }
    

    return cell;

}


-(void)stepValueChanged:(UIStepper*) sender{
    NSLog(@"new step value...%f",sender.value);
}

-(void)swValueChanged:(UISwitch*) sender{
    NSLog(@"new switch value...");
    if (sender.isOn) {
        NSLog(@"on");
    }else{
        NSLog(@"off");}

}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"扫描结束" message:result preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                                    [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"取消");
}


@end
