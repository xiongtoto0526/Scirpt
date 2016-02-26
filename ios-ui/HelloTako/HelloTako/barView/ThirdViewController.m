//
//  ThirdViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

/*
 todo: 有必要将tableview和view，label，checkbox分开成不同的类文件，防止viewControl内容过多，或控件太乱。
  可参考：accessory 官方demo. /Users/xionghaitao/my_git_rep/script/ios-ui/apple-demo
 */

#import "ThirdViewController.h"
#import "VersionViewController.h"
#import "DistributeAppsViewController.h"
#import "LoginViewController.h"
#import "UIHelper.h"
#import "ShareEntity.h"

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* sectionTitleArray;
    NSArray* sectionTextArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

     sectionTitleArray = [NSArray arrayWithObjects:@"应用",@"其他",nil];
     sectionTextArray =[NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:@"我发布的应用",nil],
                       [NSArray arrayWithObjects:@"关于Tako",@"退出登录",nil],nil];

    self.userAccount.text=[ShareEntity shareInstance].userAccount;
    self.userName.text=[ShareEntity shareInstance].userName;
    // todo:
//    self.userImage = [ShareEntity shareInstance].userImage;
   
    
    // 注册cell
//     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"navigateTableCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [sectionTitleArray objectAtIndex:section];
}


//改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitleArray count];
}

// section中的cell数目
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[sectionTextArray objectAtIndex:section] count];
}

// 加载单元格
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    // 此cell在storyboard中已经注册
    static NSString *CellIdentifier = @"navigateTableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text =sectionTextArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 单元格选中时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        NSLog(@"即将进入“我发布的应用”页面...");
        UIViewController* distributeAppsView = [[DistributeAppsViewController alloc] init];
        [self.navigationController pushViewController:distributeAppsView animated:YES];
        
    }else if(indexPath.section==1 && indexPath.row==0){
        NSLog(@"即将进入“关于Tako”页面...");
        UIViewController* versionView = [[VersionViewController alloc] init];
        [self.navigationController pushViewController:versionView animated:YES];
        
    }else if(indexPath.section==1 && indexPath.row==1){
        NSLog(@"即将进入“退出登录”页面...");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"您即将退出登录...");
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(IBAction) gotoLoginView:(id)sender{
    [self presentViewController:[LoginViewController new] animated:NO completion:^{
        NSLog(@"enter login view");
    }];
}

@end