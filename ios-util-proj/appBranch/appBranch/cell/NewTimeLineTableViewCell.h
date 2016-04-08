//
//  NewTimeLineTableViewCell.h
//  Tako
//
//  Created by 熊海涛 on 16/4/5.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTimeLineTableViewCell : UITableViewCell

@property (weak, nonatomic)  UIButton *downloadButton;
@property (weak, nonatomic)  UIImageView *lineImage;
@property (weak, nonatomic)  UIImageView *tagImage;
@property (weak, nonatomic)  UILabel *releaseTime;
@property (weak, nonatomic)  UILabel *appSize;
@property (weak, nonatomic)  UILabel *versionName;
@property (weak, nonatomic)  UILabel *appDesc;
@property (weak, nonatomic)  UIButton *moreButton;

@end
