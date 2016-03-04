//
//  ThirdViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//


#import "MineViewController.h"
#import "VersionViewController.h"
#import "LoginViewController.h"
#import "UIHelper.h"
#import "ShareEntity.h"
#import "Constant.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* sectionTitleArray;
    NSArray* sectionTextArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineViewController

-(void)receiveLoginBackNotification{
    NSLog(@"receive login back notification...");
    
    // 刷新页面。
    [self.loginBtn setHidden:[XHTUIHelper isLogined]];
    self.userName.text = [ShareEntity shareInstance].userName;
    self.userAccount.text = [ShareEntity shareInstance].userAccount;
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear...");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginBackNotification) name:LOGIN_BACK_TO_USER_NOTIFICATION object:nil];
    
    sectionTitleArray = [NSArray arrayWithObjects:@"",nil];
    sectionTextArray =[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"关于Tako",@"退出登录",nil],nil];
    
    [XHTUIHelper addBorderonButton:self.loginBtn];    // button圆角化
    [self.loginBtn setHidden:[XHTUIHelper isLogined]];
    self.userAccount.text = [ShareEntity shareInstance].userAccount;
    self.userName.text = [ShareEntity shareInstance].userName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitleArray objectAtIndex:section];
}


// 改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

// section数目
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

    if(indexPath.section==0 && indexPath.row==0){
        NSLog(@"即将进入“关于Tako”页面...");
        UIViewController* versionView = [[VersionViewController alloc] init];
        [self.navigationController pushViewController:versionView animated:YES];
        
    }else if(indexPath.section==0 && indexPath.row==1){
        NSLog(@"即将进入“退出登录”页面...");
        if (![XHTUIHelper isLogined]) {
            [XHTUIHelper alertWithNoChoice:@"您已登出." view:self];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"您已登出...");
            self.userName.text=@"";
            self.userAccount.text=@"";
            [ShareEntity shareInstance].userName=@"";
            [ShareEntity shareInstance].userAccount=@"";
            [XHTUIHelper writeNSUserDefaultsWithKey:LOGIN_KEY withObject:LOGIN_FAILED_KEY];
            
            // 通知上层view刷新视图
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_BACK_TO_USER_NOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_BACK_TO_TEST_NOTIFICATION object:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// Method disabled: 暂时不允许返回。必须登录。
-(IBAction) gotoLoginView:(id)sender{
    [self presentViewController:[LoginViewController new] animated:NO completion:^{
        NSLog(@"enter login view");
    }];
}


@end