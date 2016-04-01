//
//  ButtonPanelViewController.h
//  appBranch
//
//  Created by 熊海涛 on 16/3/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XhtButtonItem : NSObject
@property (nonatomic, strong)  NSString     *title;
@property (nonatomic, strong)  UIImage      *image;
@property (nonatomic)          NSInteger     tag;
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
@end

@protocol XhtButtonPanelDelegate <NSObject>

-(void)didClickButton:(int)tag;

@end

@interface XhtButtonPanel : UIView

// 初始化
-(id)initWithFrame:(CGRect)frame delegate:(id) delegate items:(NSArray*) data;

@property (nonatomic, assign) id<XhtButtonPanelDelegate> delegate;
@property (nonatomic) NSInteger height;
@property (nonatomic) UIColor* color;
@end
