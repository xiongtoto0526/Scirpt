//
//  FirstViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "FirstViewController.h"
#import "TableViewCell.h"
#import "ThirdViewController.h"
#import "LoginViewController.h"
#import "GameDetailViewController.h"
#import "ShareEntity.h"
#import "UIHelper.h"
#import "App.h"
#import "DownloadWorker.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,XHtDownLoadDelegate>
@property UIRefreshControl* refreshControl;
@property NSArray* listData;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end


@implementation FirstViewController


-(void)viewDidAppear:(BOOL)animated{
    
    if (![self checkIsLogin]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，请先登录~" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self presentViewController:[LoginViewController new] animated:YES completion:nil];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(![ShareEntity shareInstance].isLogined){
        // 用户未登录，需要强制加载整个view，实现refresh
        self.view= nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(![ShareEntity shareInstance].isLogined){
        return;
    }
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
//   [self presentViewController:alertController animated:YES completion:nil];
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
    
    // 隐藏tableview中多余的单元格线条
    [XHTUIHelper setExtraCellLineHidden:self.tableview];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"fTablecell"];
   
    // todo : 获取用户所有游戏，需取top10，分页。
    self.listData = [self fetchDataFromServer];
//    self.listData = @[@"app1",@"app2",@"app3"];
    
}


// todo: 模拟从server取数据
-(NSArray*)fetchDataFromServer{
        NSMutableArray* result = [NSMutableArray new];
    for (int i=0; i<3; i++) {
        App* app = [App new];
        app.name=[NSString stringWithFormat:@"app%d",i+1];
        app.version=[NSString stringWithFormat:@"%d.%d.%d",i+1,i+1,i+1];
        app.createTime=@"2015-11-09";
        app.size=@"3.1M";
        [result addObject:app];
    }
    return result;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkIsLogin{
    return [ShareEntity shareInstance].isLogined;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}


//改变行的高度,todo: 为何自定义的cell本身未生效？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

// 点击单元格，暂时关闭该页面。如需激活该方法，需要修改cell中设置：cell.selectionStyle = UITableViewCellSelectionStyleNone;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"即将进入“游戏详情”页面...");
    GameDetailViewController* gameDetailView = [[GameDetailViewController alloc] init];
    [self presentViewController:gameDetailView animated:YES completion:nil];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"fTablecell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    

    // todo: 需要加载不同的游戏数据。 使用for 遍历
    App *app = [self.listData objectAtIndex:indexPath.row];
    cell.appName.text=app.name;
    cell.appVersion.text = app.version;
    cell.otherInfo.text = [NSString stringWithFormat:@"%@ %@",app.createTime,app.size];
//    cell.appImage.image = app.image;
    
    UIImage *image = [UIImage imageNamed:@"3"];
    cell.appImage.image = image;
   
//    cell.appName.text= @"测试游戏";
//    cell.otherInfo.text=@"2015-12-08  3MB";
//    cell.appVersion.text=@"1.2.1";
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"hello , refresh...");
}


-(void) showDownload:(TableViewCell*) cell{
    // 显示下载栏
    [cell.btnCancel setHidden:NO];
    [cell.progressControl setHidden:NO];
    [cell.textDownload setHidden:NO];
}



- (void)reloadDataWhenRefresh
{
    // Reload table data
    [self.tableview reloadData];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd,hh:mm a"];
        NSString *title = [NSString stringWithFormat:@"松开刷新，上次更新时间: %@", [formatter stringFromDate:[NSDate date]]];
        
        // 黑色字体
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        // 隐藏刷新栏
        [self.refreshControl endRefreshing];
    }
}



@end
