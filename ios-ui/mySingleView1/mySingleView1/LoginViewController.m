//
//  LoginViewController.m
//  mySingleView1
//
//  Created by 熊海涛 on 15/11/19.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    UINib *cellNib =[UINib nibWithNibName:@"LoginTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"loginCell"];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.datas = @[@"登录",@"注销"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell" forIndexPath:indexPath];
    cell.titleLabel.text = [self.datas objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:@"12.png"];
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
