//
//  VersionViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "VersionViewController.h"
#import "UIHelper.h"
#import "Constant.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
   NSString* verionName = [XHTUIHelper readNSUserDefaultsObjectWithkey:APP_VERSION_KEY];
    self.version.text = [NSString stringWithFormat:@"Tako %@",verionName];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction) gotoParentView:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
