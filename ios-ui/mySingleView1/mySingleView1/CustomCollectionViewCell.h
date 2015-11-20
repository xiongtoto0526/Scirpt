//
//  CustomCollectionViewCell.h
//  mySingleView1
//
//  Created by 熊海涛 on 15/11/19.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
