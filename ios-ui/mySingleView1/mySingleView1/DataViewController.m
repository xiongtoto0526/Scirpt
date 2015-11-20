//
//  DataViewController.m
//  mySingleView1
//
//  Created by 熊海涛 on 15/11/19.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "DataViewController.h"
#import "XGSDK.h"
#import "Util.h"
@interface DataViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) XGRoleInfo* roleInfo;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计";
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.dataArray = @[@"任务开始",@"任务失败",@"任务成功",@"购买货币",@"消耗货币",@"赠送货币",@"等级提升"];
    
//    self.roleInfo = [XGRoleInfo new];
//    self.roleInfo.roleLevel=@"1";
//    self.roleInfo.roleName=@"小月";
//    self.roleInfo.uid=@"33";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //任务开始
//            [[XGSDKFactory defaultSDK] onMissionBegin:self.roleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
            
        }
            break;
        case 1:
        {
            // 任务失败后调用
//            [[XGSDKFactory defaultSDK] onMissionFail:self.roleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
            
        }
            break;
        case 2:
        {
            //任务成功
//            [[XGSDKFactory defaultSDK] onMissionSuccess:self.roleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
        }
            break;
        case 3:
        {
            //购买货币
//            [[XGSDKFactory defaultSDK] onVirtualCurrencyReward:self.roleInfo reason:@"reason 1" amount:@"1" customParams:@"custominfo"];
            
        }
            break;
        case 4:
        {
            //消耗货币
//            [[XGSDKFactory defaultSDK] onVirtualCurrencyConsume:self.roleInfo itemName:@"item4" amount:@"4" customParams:@"custom info"];
        }
            break;
        case 5:
        {
            //赠送货币
//            [[XGSDKFactory defaultSDK] onVirtualCurrencyReward:self.roleInfo reason:@"reason 1" amount:@"1" customParams:@"custom info"];
        }
            break;
        case 6:
        {
            //等级提升
            self.roleInfo.roleLevel=@"19";
//            [[XGSDKFactory defaultSDK] onRoleLevelUp:self.roleInfo];
            
        }
            break;
        default:
            break;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
