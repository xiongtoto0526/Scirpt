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

@interface DownloadTableViewController : UIViewController

@property UIRefreshControl* refreshControl;
@property NSString* cursor;
@property TableViewCell* currentCell;
@property TakoApp* currentApp;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSMutableArray* listData;

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

