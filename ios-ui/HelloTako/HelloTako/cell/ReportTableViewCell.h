//
//  ReportTableViewCell.h
//  HelloTako
//
//  Created by 熊海涛 on 15/12/10.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *reportText;
@property (weak, nonatomic) IBOutlet UIImageView *reportImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *reportTime;
@property (weak, nonatomic) IBOutlet UILabel *hot;
@property (weak, nonatomic) IBOutlet UIButton *discussButton;
@property (weak, nonatomic) IBOutlet UIButton *greatButton;
@end
