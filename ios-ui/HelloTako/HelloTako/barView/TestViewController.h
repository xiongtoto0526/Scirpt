//
//  FirstViewController.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareEntity.h"
#import "DownloadTableViewController.h"

// 对应底部的 “测试”栏
@interface TestViewController : DownloadTableViewController

+(TestViewController*)share;

@end

