//
//  NewTimeLineTableViewCell.m
//  Tako
//
//  Created by 熊海涛 on 16/4/5.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "NewTimeLineTableViewCell.h"
#import "MyLayout.h"

@implementation NewTimeLineTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"newTimeLineTableViewCell";
    // 1.缓存中取
    NewTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[NewTimeLineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}



/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
//    @property (weak, nonatomic)  UIButton *downloadButton;
//    @property (weak, nonatomic)  UIImageView *lineImage;
//    @property (weak, nonatomic)  UILabel *releaseTime;
//    @property (weak, nonatomic)  UILabel *appSize;
//    @property (weak, nonatomic)  UILabel *versionName;
//    @property (weak, nonatomic)  UILabel *appDesc;
//    @property (weak, nonatomic)  UIButton *moreButton;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        // 1.创建line
        UIImageView *lineImage = [[UIImageView alloc] init];
        [self.contentView addSubview:lineImage];
        self.lineImage = lineImage;
        UIImageView *tagImage = [[UIImageView alloc] init];
        tagImage.image = [UIImage imageNamed:@"selected_button.png"];
        [self.contentView addSubview:lineImage];
        self.tagImage = tagImage;
        
        // 2.创建releasetime
        UILabel *releaseTime = [[UILabel alloc] init];
//        releaseTime.font = NJNameFont;
        [self.contentView addSubview:releaseTime];
        self.releaseTime = releaseTime;
        
        // 3.创建appsize
        UILabel *appSize = [[UILabel alloc] init];
        //        releaseTime.font = NJNameFont;
        [self.contentView addSubview:appSize];
        self.appSize = appSize;
        
        // 4.创建versionName
        UILabel *versionName = [[UILabel alloc] init];
        //        releaseTime.font = NJNameFont;
        [self.contentView addSubview:versionName];
        self.versionName = versionName;
        

        // 5.创建appDesc
        UILabel *appDesc = [[UILabel alloc] init];
        //        releaseTime.font = NJNameFont;
        [self.contentView addSubview:appDesc];
        self.appDesc = appDesc;
        
        // 6.创建moreButton
        UIButton* moreButton = [[UIButton alloc] init];
        [self.contentView addSubview:moreButton];
        self.moreButton = moreButton;
        
        // 7.创建downloadButton
        UIButton* downloadButton = [[UIButton alloc] init];
        [self.contentView addSubview:downloadButton];
        self.downloadButton = downloadButton;
        
    }
    return self;
}

@end
