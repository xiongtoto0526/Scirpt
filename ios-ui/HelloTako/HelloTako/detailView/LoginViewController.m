//
//  LoginViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "ShareEntity.h"
#import "Constant.h"
#import "UIHelper.h"

@interface LoginViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator ;


@property (copy,nonatomic) NSString* authUserName;
@property (weak, nonatomic) UIImageView *authUserIcon;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction) signin:(id)sender{
    if(self.loginBt.selected) return;
   self.loginBt.selected = YES;
   self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    [self.view addSubview:   self.activityIndicator];
       self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator startAnimating];
    
    NSString *userAccount = self.userNameTxt.text;
    NSString *password = self.userPwd.text;
    // todo: 输入txt的格式校验。
    
    if([self authwithUserName:userAccount password:password]){
        NSLog(@"登陆成功。");
        [XHTUIHelper writeNSUserDefaultsWithKey:USER_KEY withValue:userAccount];
        [XHTUIHelper writeNSUserDefaultsWithKey:LOGIN_KEY withValue:LOGIN_SUCCESS_KEY];
        [ShareEntity shareInstance].isLogined=true;
        [ShareEntity shareInstance].userAccount=userAccount;
        [ShareEntity shareInstance].userName=self.authUserName;
        [self gotoParentView:nil];
    }else{
        NSLog(@"登陆失败。");
        [self showLoginFailed];
    }
}

-(void) showLoginFailed{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败,请重试~" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"will back to login view...");
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)authFinish{
    [self.activityIndicator stopAnimating];
    self.loginBt.selected = NO;
}


-(BOOL)authwithUserName:(NSString*)userName password:(NSString*)password{
    // 模拟鉴权过程
    [self performSelector:@selector(authFinish) withObject:nil afterDelay:3.0]; //使用延时进行限制。
    
    //todo: 解析用户信息
    self.authUserName=@"authUserName";
    self.authUserIcon=nil;
    return YES;
}


-(IBAction) signup:(id)sender{
    
    NSLog(@"will do register...");
    
}

-(IBAction) gotoParentView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
