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
#import "Constant.h"
#import "Server.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UIRefreshControl* refreshControl;
@property NSArray* listData;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end


@implementation FirstViewController


-(void)viewDidAppear:(BOOL)animated{
    // t:此处不能模态alter窗口,否则崩溃。
}


-(void)receiveLoginBackNotification{
    BOOL isLogined = [ShareEntity shareInstance].isLogined;
    [self.tableview setHidden:!isLogined];
    if (isLogined && self.listData ==nil) {
         self.listData = [self fetchDataFromServer];
        [self.tableview reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginBackNotification) name:LOGIN_BACK_TO_TEST_NOTIFICATION object:nil];
    
    // 未登录时不显示
    [self.tableview setHidden:![ShareEntity shareInstance].isLogined];

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
    // 未登录时不显示tableView
//    [self.tableview setHidden:![ShareEntity shareInstance].isLogined];
    if (![ShareEntity shareInstance].isLogined) {
        self.listData = nil;
    }else{
     self.listData = [self fetchDataFromServer];
    }
    
}


-(NSArray*)fetchDataFromServer{
    return [TakoServer fetchApp];
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

// 点击单元格，暂时关闭该页面。如需激活该方法，需要修改cell中设置。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"即将进入“游戏详情”页面...");
//    GameDetailViewController* gameDetailView = [[GameDetailViewController alloc] init];
//    [self presentViewController:gameDetailView animated:YES completion:nil];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"fTablecell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    

    // todo: 需要加载不同的游戏数据。 使用for 遍历
    TakoApp *app = [self.listData objectAtIndex:indexPath.row];
    cell.appName.text=app.name;
    cell.appVersion.text = app.version;
    cell.otherInfo.text = [NSString stringWithFormat:@"%@ %@",app.createTime,app.size];
//    cell.appImage.image = app.image;
    
    UIImage *image = [UIImage imageNamed:@"3"];
    cell.appImage.image = image;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@" cell will display...");
    TableViewCell* tbCell = (TableViewCell*)cell;
    if ([self isAppDownloadedBefore:[NSString stringWithFormat:@"%@%@",tbCell.appName.text,tbCell.appVersion.text]]) {
        [tbCell.button setTitle:@"已下载" forState:UIControlStateNormal];
        [tbCell.button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor grayColor])];
        tbCell.button.enabled = NO;
    }

}


-(BOOL)isAppDownloadedBefore:(NSString*) newAppId{
    BOOL isExist = NO;
    NSDictionary* downloadAppDict = [XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_KEY];
    for (NSString *key in downloadAppDict) {
//        NSLog(@"dict key: %@ value: %@", key, downloadAppDict[key]);
        if ([key isEqualToString:newAppId]) {
            NSLog(@"该应用已保存在下载记录中...");
            isExist = YES;
            break;
        }
    }
    return isExist;
}

-(void) showDownload:(TableViewCell*) cell{
    // 显示下载栏
    [cell.btnCancel setHidden:NO];
    [cell.progressControl setHidden:NO];
    [cell.textDownload setHidden:NO];
}



-(IBAction) gotoLoginView:(id)sender{
    [self presentViewController:[LoginViewController new] animated:NO completion:^{
        NSLog(@"enter login view");
    }];
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
