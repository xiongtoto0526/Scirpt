//
//  ViewController.m
//  XGSDK_Demo
//
//  Created by xgsdk on 15/11/16.
//  Copyright © 2015年 xgsdk. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"
#import "LoginViewController.h"
#import "DataViewController.h"
#import "XGSDK.h"

//动态获取设备高度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>


//@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *bgColors;
@end

static CGFloat margin = 20;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XGSDK";
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self.collectView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    self.datas = @[@"登录",@"统计",@"支付",@"分享"];
//    self.bgColors = @[[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor purpleColor]];
    
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

#pragma mark -
#pragma mark UIColllection Delegate&&Datasource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.datas count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =  (IPHONE_WIDTH - 3*margin)/2;
    CGSize size = {width,width};
    return size;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"row= %ld,section = %ld",(long)indexPath.item,(long)indexPath.section);
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
            DataViewController *dataVC = [[DataViewController alloc] init];
            [self.navigationController pushViewController:dataVC animated:YES];
        }
            break;
        case 2:
        {
//            //支付
//            XGBuyInfo *buyInfo = [[XGBuyInfo alloc] init];
//            buyInfo.accountID=@"1";
//            buyInfo.productId= @"com.xsj.rok0300";//xyfm app
//            buyInfo.productName = @"1";
//            buyInfo.productDesc = @"1";
//            buyInfo.productQuantity = @"1";
//            buyInfo.productUnitPrice =@"1";
//            buyInfo.payAmount =@"1";
//            buyInfo.roleId = @"1";
//            buyInfo.roleName = @"1";
//            buyInfo.serverId = @"1";
//            buyInfo.currencyName = @"1";
//            buyInfo.customInfo =@"1";
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"购买产品" message:@"请输入产品购买信息" preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.keyboardType = UIKeyboardTypeDefault;
//                textField.placeholder = @"输入购买的产品ID";
//            }];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.keyboardType = UIKeyboardTypeNumberPad;
//                textField.placeholder = @"输入购买的产品数量";
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField *productIdField = [[alertController textFields] firstObject];
//                if (productIdField.text.length) {
//                    buyInfo.productId = productIdField.text;
//                }
//                UITextField *productAccountField = [[alertController textFields] objectAtIndex:1];
//                if (productAccountField.text.length && [productAccountField.text integerValue] >0) {
//                    buyInfo.productQuantity = productAccountField.text;
//                }
//                NSLog(@"buyInfo from game...%@",buyInfo);
//                [[XGSDKFactory defaultSDK] XGPaymentWithBuyInfo:buyInfo];
//                
//            }];
//            [alertController addAction:cancelAction];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
            
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
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    collectCell.titleLabel.text = [self.datas objectAtIndex:indexPath.item];
    collectCell.backgroundColor = [self.bgColors objectAtIndex:(indexPath.item%4)];
    return collectCell;
}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"row= %ld,section = %ld",(long)indexPath.item,(long)indexPath.section);
//    switch (indexPath.item) {
//        case 0:
//        {
//            //登录
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:loginVC animated:YES];
//        }
//            break;
//        case 1:
//        {
//            //统计
//            DataViewController *dataVC = [[DataViewController alloc] init];
//            [self.navigationController pushViewController:dataVC animated:YES];
//        }
//            break;
//        case 2:
//        {
//            //支付
//            XGBuyInfo *buyInfo = [[XGBuyInfo alloc] init];
//            buyInfo.accountID=@"1";
//            buyInfo.productId= @"com.xsj.rok0300";//xyfm app
//            buyInfo.productName = @"1";
//            buyInfo.productDesc = @"1";
//            buyInfo.productQuantity = @"1";
//            buyInfo.productUnitPrice =@"1";
//            buyInfo.payAmount =@"1";
//            buyInfo.roleId = @"1";
//            buyInfo.roleName = @"1";
//            buyInfo.serverId = @"1";
//            buyInfo.currencyName = @"1";
//            buyInfo.customInfo =@"1";
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"购买产品" message:@"请输入产品购买信息" preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.keyboardType = UIKeyboardTypeDefault;
//                textField.placeholder = @"输入购买的产品ID";
//            }];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.keyboardType = UIKeyboardTypeNumberPad;
//                textField.placeholder = @"输入购买的产品数量";
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField *productIdField = [[alertController textFields] firstObject];
//                if (productIdField.text.length) {
//                    buyInfo.productId = productIdField.text;
//                }
//                UITextField *productAccountField = [[alertController textFields] objectAtIndex:1];
//                if (productAccountField.text.length && [productAccountField.text integerValue] >0) {
//                    buyInfo.productQuantity = productAccountField.text;
//                }
//                NSLog(@"buyInfo from game...%@",buyInfo);
//                [[XGSDKFactory defaultSDK] XGPaymentWithBuyInfo:buyInfo];
//                
//            }];
//            [alertController addAction:cancelAction];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//        }
//            break;
//        case 3:
//        {
//            //分享
//        }
//            break;
//        default:
//            break;
//    }
//}


@end
