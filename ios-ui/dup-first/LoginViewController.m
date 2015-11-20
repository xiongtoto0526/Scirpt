//
//  LoginViewController.m
//  dup-first
//
//  Created by 熊海涛 on 15/11/20.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong) NSArray *datas;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    // 使用自定义的单元格
//    UINib *cellNib =[UINib nibWithNibName:@"LoginTableViewCell" bundle:nil];
//    [self.LoginTableView registerNib:cellNib forCellReuseIdentifier:@"loginCell"];
    
    // 使用系统的单元格
    [self.LoginTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"loginCellStyle"];
    
    self.datas = @[@"登录",@"注销"];
    self.LoginTableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView delegate&&datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 复用style,加载系统自带的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCellStyle" forIndexPath:indexPath];
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    return cell;

    // 复用style，加载自定义的cell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCellStyle" forIndexPath:indexPath];
//    cell.titleLabel.text = [self.datas objectAtIndex:indexPath.row];
//    cell.imgView.image = [UIImage imageNamed:@"12.png"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //登录
            //            [[XGSDKFactory defaultSDK] XGLoginWith:@""];
            
        }
            break;
        case 1:
        {
            //注销
            //            [[XGSDKFactory defaultSDK] XGLogout:@""];
        }
            break;
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
