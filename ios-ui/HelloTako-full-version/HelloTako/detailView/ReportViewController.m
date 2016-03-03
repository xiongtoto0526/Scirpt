//
//  ReportViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSArray* listData;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"ReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"reportTableCell"];
    
    self.listData = @[@"app1",@"app2",@"app3"];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"reportTableCell";
    ReportTableViewCell *cell = (ReportTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:@"3"];
    cell.hot.text=@"100 条热度";
    cell.reportImage.image=image;
    cell.userName.text=@"xiongtoto";
    cell.reportTime.text=@"2099_12_10";
    cell.reportText.text=@"这只是一个测试反馈，无需关注~~";
    return cell;
}



//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
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
