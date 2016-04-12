//
//  EditImageViewController.h
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/12.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageEditDelegate <NSObject>

-(void)imageEditFinish:(UIImage*)image;

@end

@interface EditImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong,nonatomic) UIImage* preImage;
@property id<ImageEditDelegate> delegate;
@end
