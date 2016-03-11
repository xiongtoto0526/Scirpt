//
//  DownloadTableViewController.h
//  HelloTako
//
//  Created by 熊海涛 on 16/3/5.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "App.h"
#import "Constant.h"
#import "DownloadHistory.h"


/* 
 说明：
 tableviewcell复用后，“测试”和”下载管理“页面的大量方法重复，为复用部分代码，新增此类。该类将被两个viewcontroller继承：TestViewController和DownloadViewController
 */

@interface DownloadTableViewController : UIViewController

@property UIRefreshControl* refreshControl;
@property NSString* cursor;
@property TableViewCell* currentCell;
@property TakoApp* currentApp;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSMutableArray* listData;

// 被复用的接口
-(void)showPasswordConfirm;
-(void)receiveClickDownloadNotification:(NSNotification*)notice;
-(void)receiveCancelDownloadNotification:(NSNotification*)notice;
-(void)downloadApp;
-(void)hideProgressUI:(BOOL)isShow cell:(TableViewCell*)cell;
-(void)updateApp:(TakoApp*)app cell:(TableViewCell*)cell status:(enum APPSTATUS)status;
-(void)saveCurrentAppStatus:(int) status tag:(NSString*)tag;


// 下载回调
-(void)receiveDownloadProgressNotification:(NSNotification*)notice;
-(void)receiveDownloadFinishNotification:(NSNotification*)notice;
@end

