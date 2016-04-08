//
//  LoginViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "LoginViewController.h"
#import "TestViewController.h"
#import "MineViewController.h"
#import "Constant.h"
#import "UIHelper.h"
#import "validation.h"
#import "Server.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    MBProgressHUD* hub;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;

@property (copy,nonatomic) NSString* authUserName;
@property (weak, nonatomic) UIImageView *authUserIcon;

@end

@implementation LoginViewController

#pragma mark view生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [XHTUIHelper addBorderonButton:self.loginBt cornerSize:8];
    [self.userNameTxt setDelegate:self];
    [self.userPwd setDelegate:self];
    self.userNameTxt.tag=0;
    self.userPwd.tag=1;
    self.userNameTxt.borderStyle = UITextBorderStyleNone;
    self.userPwd.borderStyle = UITextBorderStyleNone;
    self.userPwd .secureTextEntry = YES; // 掩码

    self.navigateBar.barTintColor = [XHTUIHelper navigateColor];

    [XHTUIHelper addRightViewforText:self.userNameTxt image:@"ic_mail.png"];
    [XHTUIHelper addRightViewforText:self.userPwd image:@"ic_pwd.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark view的其他私有方法

-(IBAction) signin:(id)sender{
    
    if(self.loginBt.selected) return;
    
    self.loginBt.selected = YES;
    
    NSString *userAccount = self.userNameTxt.text;
    NSString *password = self.userPwd.text;
    
    // kingsoft邮箱无需后缀
    if (![userAccount containsString:@"@"]) {
        userAccount = [NSString stringWithFormat:@"%@@kingsoft.com",userAccount];
    }
    
    // 输入校验
    XHtValidation *validate=[[XHtValidation alloc] init];
    [validate Email:userAccount FieldName:@"账号:"];
    [validate Required:userAccount FieldName:@"账号:"];
    [validate Required:password FieldName:@"密码:"];
    [validate MaxLength:12 textField:password FieldName:@"密码:"];
    if (![validate isValid]) {
        NSLog(@"格式校验不通过!");
        [self showLoginFailed:[validate.errorMsg objectAtIndex:0]];
        self.loginBt.selected = NO;
        self.loginBt.backgroundColor = [UIColor clearColor];
        [self authFinish];
        return;
    }
    
    [self showIndicator];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        BOOL isAuthOk = [self authwithUserName:userAccount password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isAuthOk){
                NSLog(@"登陆成功。");
                
                // 记录用户信息
                [XHTUIHelper writeNSUserDefaultsWithKey:USER_ACCOUNT_KEY withValue:userAccount];
                [XHTUIHelper writeNSUserDefaultsWithKey:USER_NAME_KEY withValue:self.authUserName];
                [XHTUIHelper writeNSUserDefaultsWithKey:LOGIN_KEY withValue:LOGIN_SUCCESS_KEY];
                [XHTUIHelper addNewAccount:userAccount];
                
                if ([XHTUIHelper isAppLoadBefore]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self presentViewController:[XHTUIHelper initTabbar] animated:YES completion:nil];
                }
                
            }else{
                NSLog(@"登陆失败。");
                [self showLoginFailed:nil];
                self.loginBt.backgroundColor = [UIColor clearColor];
                self.loginBt.selected = NO;
            }

        });
        
    });
   }


-(void) showLoginFailed:(NSString*) failedMsg{
    
    if (failedMsg==nil) {
        failedMsg = @"登录失败,请重试~";
    }
    [self authFinish];
    
    [XHTUIHelper alertWithNoChoice:failedMsg view:self];
    
}


- (void)authFinish{
//    [self.activityIndicator stopAnimating];
    [hub hideAnimated:YES];
    self.loginBt.selected = NO;
}


-(BOOL)authwithUserName:(NSString*)userName password:(NSString*)password{
    TakoUser* user = [TakoServer authEmail:userName password:password];
    if (user==nil) {
        return NO;
    }
    self.authUserName=user.nickName;
    [XHTUIHelper writeNSUserDefaultsWithKey:USER_ID_KEY withObject:user.userId];
//    [XHTUIHelper writeNSUserDefaultsWithKey:USER_TOKEN_KEY withObject:user.userToken];
    [XHTUIHelper saveLoginCookie];
    self.authUserIcon=nil;
    return YES;
}

-(void)showIndicator{
    self.loginBt.selected = YES;
    self.loginBt.backgroundColor = [XHTUIHelper systemColor];
    hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(IBAction) signup:(id)sender{
    NSLog(@"will do register...");
}


#pragma mark textField回调

// 当输入框获得焦点时，改变下拉框演示。
- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
    if (textField.tag == 0) {
        [self.emailLineimage setBackgroundColor:[XHTUIHelper systemColor]];
        [self.passwordLineimage setBackgroundColor:[UIColor grayColor]];
    }else if (textField.tag == 1) {
        [self.passwordLineimage setBackgroundColor:[XHTUIHelper systemColor]];
        [self.emailLineimage setBackgroundColor:[UIColor grayColor]];
    }
}




@end
