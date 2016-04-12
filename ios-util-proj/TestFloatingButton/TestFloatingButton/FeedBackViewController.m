//
//  FeedBackViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/12.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackDetailViewController.h"

@interface FeedBackViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray* listData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择游戏";
    listData = [NSMutableArray arrayWithObjects:@"仙剑", @"神奇四侠",@"西游伏魔",nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"will do feedback for index:%ld",(long)indexPath.row);
    [self.navigationController pushViewController:[FeedBackDetailViewController new] animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  listData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"UITableViewCell";

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [listData objectAtIndex:indexPath.row];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}

@end
