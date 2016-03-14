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
#import "DownloadViewController.h"
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

#pragma mark view生命周期

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 重载数据
    [self.loginBtn setHidden:[XHTUIHelper isLogined]];
    
    if ([XHTUIHelper isLogined]) {
        self.userImage.image = [UIImage imageNamed:@"ic_user_head_logged"];
        self.userName.text = [XHTUIHelper readNSUserDefaultsObjectWithkey:USER_ACCOUNT_KEY];
        self.userAccount.text = [XHTUIHelper readNSUserDefaultsObjectWithkey:USER_NAME_KEY];
    }else{
        self.userImage.image = [UIImage imageNamed:@"ic_user_head_unlogged"];
        self.userName.text = @"";
        self.userAccount.text =@"";
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 初始化数据源
    sectionTitleArray = [NSArray arrayWithObjects:@"",nil];
    sectionTextArray =[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"关于Tako",@"下载管理",@"版本更新",@"退出登录",nil],nil];
    
    
    
    [XHTUIHelper addBorderonButton:self.loginBtn];    // button圆角化
    [self.loginBtn setHidden:[XHTUIHelper isLogined]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview的delegate

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

// 单击一次即可，不允许deselect
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPat{
    [self tableView:tableView didSelectRowAtIndexPath:indexPat];// 相当于disable双击
}

// 单元格选中时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0 && indexPath.row==0){
        NSLog(@"即将进入“关于Tako”页面...");
        UIViewController* versionView = [[VersionViewController alloc] init];
        [self.navigationController pushViewController:versionView animated:YES];
        
    }
    
    else if(indexPath.section==0 && indexPath.row==1){
        NSLog(@"即将进入“下载管理”页面...");
        UIViewController* downloadView = [[DownloadViewController alloc] init];
        [self.navigationController pushViewController:downloadView animated:YES];
    }
    
    else if(indexPath.section==0 && indexPath.row==2){
        NSLog(@"即将进入“版本更新”页面...");
        NSString* latestVersion = @"";
        BOOL isNeedUpdate = YES;
        if (isNeedUpdate) {
            NSLog(@"latest version is:%@, will update...",latestVersion);
            NSURL* url = [NSURL URLWithString:@"http://qa.tako.im:28870/clp8"];
            [[UIApplication sharedApplication] openURL:url];

        }
        }
    
    else if(indexPath.section==0 && indexPath.row==3){
        NSLog(@"即将进入“退出登录”页面...");
        if (![XHTUIHelper isLogined]) {
            [XHTUIHelper alertWithNoChoice:@"您已登出." view:self];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"登出成功...");
            self.userName.text=@"";
            self.userAccount.text=@"";
            self.userImage.image = [UIImage imageNamed:@"ic_user_head_unlogged"];
           
            // 更新用户信息
            [XHTUIHelper writeNSUserDefaultsWithKey:LOGIN_KEY withObject:LOGIN_FAILED_KEY];
            [XHTUIHelper writeNSUserDefaultsWithKey:USER_ACCOUNT_KEY withObject:@""];
            [XHTUIHelper writeNSUserDefaultsWithKey:USER_NAME_KEY withObject:@""];
            
            [self gotoLoginView:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark view的其他私有方法

// Method disabled: 暂时不允许返回。必须登录。
-(IBAction) gotoLoginView:(id)sender{
    [self presentViewController:[LoginViewController new] animated:NO completion:^{
        NSLog(@"enter login view");
    }];
}


@end