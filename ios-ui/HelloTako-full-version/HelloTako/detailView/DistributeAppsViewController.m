//
//  DistributeAppsViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "DistributeAppsViewController.h"

@interface DistributeAppsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* appList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation DistributeAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appList=[NSArray arrayWithObjects:@"西游伏魔",@"帝国塔防",@"骑士法则",@"神之遗迹",nil];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [appList count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text=[appList objectAtIndex:indexPath.row];
    return cell;
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
