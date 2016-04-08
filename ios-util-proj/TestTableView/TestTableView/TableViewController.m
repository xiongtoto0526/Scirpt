//
//  TableViewController.m
//  TestTableView
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "TableViewController.h"
#import "SVPullToRefresh/SVPullToRefresh.h"

@interface TableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TableViewController

- (void)viewDidLayoutSubviews {
    // 初始化刷新控制器
    if (self.tableView.pullToRefreshView == nil) {
        [self.tableView addPullToRefreshWithActionHandler:^{
        }];
    }
}

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

@end
