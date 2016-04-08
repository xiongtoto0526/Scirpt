//
//  ViewController.m
//  TestTableView
//
//  Created by 熊海涛 on 16/4/8.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "SVPullToRefresh/SVPullToRefresh.h"


@interface ViewController ()<UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@end

@implementation ViewController


- (void)viewDidLayoutSubviews {
    // 初始化刷新控制器
    if (self.tableVIew.pullToRefreshView == nil) {
        [self.tableVIew addPullToRefreshWithActionHandler:^{
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview的delegate


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}



//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}



-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 系统原生的cell
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    return cell;
}



@end
