//
//  ViewController.m
//  dup-first
//
//  Created by 熊海涛 on 15/11/20.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
//#import "DataViewController.h"
#import "XGSDK.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XGSDK";
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //    [self.collectView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    self.datas = @[@"登录",@"统计",@"支付",@"分享"];
    //    self.bgColors = @[[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor purpleColor]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView delegate&&Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"rootViewController --row= %ld,section = %ld",(long)indexPath.item,(long)indexPath.section);
    switch (indexPath.row) {
        case 0:
        {
            //登录
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
            break;
        case 1:
        {
            //统计
//            DataViewController *dataVC = [[DataViewController alloc] init];
//            [self.navigationController pushViewController:dataVC animated:YES];
        }
            break;
        case 2:
        {
            //支付
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"购买产品" message:@"请输入产品购买信息" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.placeholder = @"输入购买的产品ID";
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = @"输入购买的产品数量";
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *productIdField = [[alertController textFields] firstObject];
                if (productIdField.text.length) {
//                    buyInfo.productId = productIdField.text;
                }
                UITextField *productAccountField = [[alertController textFields] objectAtIndex:1];
                if (productAccountField.text.length && [productAccountField.text integerValue] >0) {
//                    buyInfo.productQuantity = productAccountField.text;
                }
//                NSLog(@"buyInfo from game...%@",buyInfo);
//                [[XGSDKFactory defaultSDK] XGPaymentWithBuyInfo:buyInfo];
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        case 3:
        {
            //分享
        }
            break;
        default:
            break;
    }
   
}


@end
