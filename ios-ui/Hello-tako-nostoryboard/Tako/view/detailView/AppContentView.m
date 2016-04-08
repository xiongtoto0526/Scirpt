//
//  AppContentView.m
//  Tako
//
//  Created by 熊海涛 on 16/3/29.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "AppContentView.h"


@implementation AppContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame content:(NSString*)contentText{

    self.textContent = contentText;
    
    CGRect mainFrame = [ UIScreen mainScreen ].bounds;
    
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), mainFrame.size.height-CGRectGetMinY(frame))];
    
//    self.backgroundColor = [UIColor redColor];
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, 8)];
    header.backgroundColor = [UIColor colorWithRed:234/255.f green:234/255.f blue:234/255.f alpha:0.3];
    [self addSubview:header];
    
    UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 80, 20)];
    titleLable.text = @"应用描述";
    titleLable.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:titleLable];
    

    UITextView* content = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMaxY(titleLable.frame), mainFrame.size.width-2*CGRectGetMinX(titleLable.frame)+3, 300)];
//    content.backgroundColor = [UIColor blueColor];
    content.text = self.textContent;
    content.editable = NO;
    content.textColor = [UIColor grayColor];
    content.showsHorizontalScrollIndicator = YES;
    content.scrollEnabled = YES;
    content.userInteractionEnabled = YES;

    [self addSubview:content];

    return self;
}

@end
