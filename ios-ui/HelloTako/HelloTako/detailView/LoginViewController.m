//
//  LoginViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "ThirdViewController.h"
#import "ShareEntity.h"
#import "Constant.h"
#import "UIHelper.h"
#import "validation.h"
#import "Server.h"

@interface LoginViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator ;
@property (copy,nonatomic) NSString* authUserName;
@property (weak, nonatomic) UIImageView *authUserIcon;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBt setHidden:YES];// 返回按钮暂不展示。
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

    NSString *userAccount = self.userNameTxt.text;
    NSString *password = self.userPwd.text;
    // todo: 输入txt的格式校验。
    XHtValidation *validate=[[XHtValidation alloc] init];
    
    //====== Pass In the textField and desired textFieldName for each validation method
    [validate Email:userAccount FieldName:@"账号:"];
    [validate Required:userAccount FieldName:@"账号:"];
    [validate Required:password FieldName:@"密码:"];
    [validate MaxLength:12 textField:password FieldName:@"密码:"];
    if (![validate isValid]) {
        NSLog(@"格式校验不通过!");
        [self showLoginFailed:[validate.errorMsg objectAtIndex:0]];
        self.loginBt.selected = NO;
        [self authFinish];
        return;
    }
    
    [self showIndicator];
    
    if([self authwithUserName:userAccount password:password]){
        NSLog(@"登陆成功。");
        [XHTUIHelper writeNSUserDefaultsWithKey:USER_ACCOUNT_KEY withValue:userAccount];
        [XHTUIHelper writeNSUserDefaultsWithKey:USER_NAME_KEY withValue:self.authUserName];
        [XHTUIHelper writeNSUserDefaultsWithKey:LOGIN_KEY withValue:LOGIN_SUCCESS_KEY];
        [ShareEntity shareInstance].isLogined=true;
        [ShareEntity shareInstance].userAccount=userAccount;
        [ShareEntity shareInstance].userName=self.authUserName;
        [self gotoParentView:nil];
    }else{
        NSLog(@"登陆失败。");
        [self showLoginFailed:nil];
        self.loginBt.selected = NO;
    }
}


-(void) showLoginFailed:(NSString*) failedMsg{
    
    if (failedMsg==nil) {
     failedMsg = @"登录失败,请重试~";
    }

    [XHTUIHelper alertWithNoChoice:failedMsg view:self];
        
}


- (void)authFinish{
    [self.activityIndicator stopAnimating];
    self.loginBt.selected = NO;
}


-(BOOL)authwithUserName:(NSString*)userName password:(NSString*)password{
    TakoUser* user = [TakoServer authEmail:userName password:password];
    if (user==nil) {
        return NO;
    }
    self.authUserName=user.nickName;
    self.authUserIcon=nil;
    return YES;
}

-(void)showIndicator{
    self.loginBt.selected = YES;
    
    // 设置菊花位置
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int indicatorWidth = 60;
    int indicatorHeight = 60;
    CGFloat x = size.width/2-indicatorWidth/2;
    CGFloat y = self.loginBt.frame.origin.y-self.loginBt.frame.size.height/2;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, indicatorWidth, indicatorHeight)];
    
    [self.view addSubview:   self.activityIndicator];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator startAnimating];

}

-(IBAction) signup:(id)sender{
    NSLog(@"will do register...");
}

-(IBAction) gotoParentView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self authFinish];
    // 通知上层view刷新视图
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_BACK_TO_USER_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_BACK_TO_TEST_NOTIFICATION object:nil];

}



@end
