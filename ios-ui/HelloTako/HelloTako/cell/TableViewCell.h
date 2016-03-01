//
//  TableViewCell.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/9.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *otherInfo;
@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressControl;
@property (weak, nonatomic) IBOutlet UILabel *textDownload;
@property (nonatomic,copy) NSString* logourl;
@property (nonatomic,copy) NSString *versionId;
@property (nonatomic,copy) NSString* myCellIndex;
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *downloadUrl;
@property (nonatomic) BOOL isNeedPassword;
@property (nonatomic,copy) NSString* downloadPassword;

// progress info
@property BOOL isStarted;
@property BOOL isPaused;
@property NSString* progress;

@end
