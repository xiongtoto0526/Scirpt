//
//  LoginViewController.h
//  dup-first
//
//  Created by 熊海涛 on 15/11/20.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

// 通过拖拽建立联系，并需要在xib中设置tableview的datasource和delegate
@property (weak, nonatomic) IBOutlet UITableView *LoginTableView;

@end
