//
//  EAuthViewController.m
//  demo
//
//  Created by liweiqiang on 15/11/30.
//  Copyright © 2015年 liweiqiang. All rights reserved.
//

#import "EAuthViewController.h"
#import "TalkingDataSMS.h"

@interface EAuthViewController() <TalkingDataSMSDelegate>

@property (nonatomic, weak) IBOutlet UITextField *field1;
@property (nonatomic, weak) IBOutlet UITextField *field2;
@property (nonatomic, weak) IBOutlet UITextField *field3;
@property (nonatomic, weak) IBOutlet UITextField *field4;

@end


@implementation EAuthViewController

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)apply:(UIButton *)sender {
    [TalkingDataSMS applyAuthCode:self.field1.text mobile:self.field2.text delegate:self];
}

- (IBAction)reapple:(UIButton *)sender {
    [TalkingDataSMS reapplyAuthCode:self.field1.text mobile:self.field2.text requestId:self.field4.text delegate:self];
}

- (IBAction)verify:(UIButton *)sender {
    [TalkingDataSMS verifyAuthCode:self.field1.text mobile:self.field2.text authCode:self.field3.text delegate:self];
}

- (void)onApplySucc:(NSString *)requestId {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    UIAlertView *aletr = [[UIAlertView alloc] initWithTitle:@"申请成功" message:@"验证码已下发至您的手机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletr show];
    self.field4.text = requestId;
}

- (void)onApplyFailed:(int)errorCode errorMessage:(NSString *)errorMessage {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    UIAlertView *aletr = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"申请失败%d", errorCode] message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletr show];
}

- (void)onVerifySucc:(NSString *)requestId {
    UIAlertView *aletr = [[UIAlertView alloc] initWithTitle:@"验证成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletr show];
    self.field4.text = requestId;
}

- (void)onVerifyFailed:(int)errorCode errorMessage:(NSString *)errorMessage {
    UIAlertView *aletr = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"验证失败%d", errorCode] message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletr show];
}

@end
