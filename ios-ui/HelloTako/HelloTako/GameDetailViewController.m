//
//  GameDetailViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "GameDetailViewController.h"
#import "TimeLineTableViewCell.h"
#import "UIHelper.h"

@interface GameDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

// head view
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;

// segment
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

// table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;


// content view
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *descriptText;
@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView setHidden:YES];
    
    // 隐藏多余的单元格
    [XHTUIHelper setExtraCellLineHidden:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeLineTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


//改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

// 点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"被点击...");
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"TimeLineTableViewCell";
    TimeLineTableViewCell *cell = (TimeLineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 去除cell的点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
   
    return cell;
}

// segmentControl触发的动作
-(IBAction)  segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    switch (Index) {
        case 0:
            NSLog(@"segment 0 clicked...");
            [self.contentView setHidden:YES];
            [self.tableView setHidden:NO];

            break;
            
        case 1:
            NSLog(@"segment 1 clicked...");
            [self.contentView setHidden:NO];
            [self.tableView setHidden:YES];
            break;
            
        case 2:
            break;
            
        default:
            break;
            
    }
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
