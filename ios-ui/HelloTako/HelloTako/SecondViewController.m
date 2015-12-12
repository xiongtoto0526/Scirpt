//
//  SecondViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "SecondViewController.h"
#import "TableViewCell.h"
#import "ReportViewController.h"
#import "GameDetailViewController.h"
#import "UIHelper.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* listData;
}
@property UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listData = @[@"app1",@"app2",@"app3"];
    
    // 初始化刷新控制器.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataWhenRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // 隐藏刷新按钮
    [self.refreshControl endRefreshing];
    
    // 添加refresh
    [self.tableview addSubview:self.refreshControl];

    
    // 隐藏多余的单元格
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"fTablecell"];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)reloadDataWhenRefresh{
    NSLog(@"即将更新表数据...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"fTablecell";
    
    // firstViewController中已经注册，无需再次注册？
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:@"3"];
    cell.appImage.image = image;
    cell.appName.text= @"测试游戏";
    cell.otherInfo.text=@"2015-12-08  3MB";
    cell.appVersion.text=@"1.2.1";
    [cell.button setTitle:@"反馈" forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];

    return cell;
}


// 点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"即将进入“游戏详情”页面...");
    GameDetailViewController* gameDetailView = [[GameDetailViewController alloc] init];
    [self presentViewController:gameDetailView animated:YES completion:nil];
}



-(IBAction) buttonClicked:(id)sender {
    NSLog(@"即将进入“反馈”页面...");
    ReportViewController* reportView = [[ReportViewController alloc] init];
    [self presentViewController:reportView animated:YES completion:nil];
}
@end
