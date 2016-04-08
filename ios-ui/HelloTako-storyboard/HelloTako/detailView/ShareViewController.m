//
//  ShareViewController.m
//  HelloTako
//
//  Created by 熊海涛 on 15/12/13.
//  Copyright © 2015年 熊海涛. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController (){
    BOOL pageControlBeingUsed;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageControlBeingUsed = NO;
    // 加载所有scrollview中的图片
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollview.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollview.frame.size;
        
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:frame];
        NSString* imageName = [NSString stringWithFormat:@"spring%d",i];
        imageview.image=[UIImage imageNamed:imageName];
        [self.scrollview addSubview:imageview];
    }
    
    // 设置scrollview的内容大小
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * colors.count, self.scrollview.frame.size.height);
    
    self.pagecontrol.currentPage = 0;
    self.pagecontrol.numberOfPages = colors.count;
    // Do any additional setup after loading the view from its nib.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
        // 超过50%的内容被显示时，切换page的页数
        CGFloat pageWidth = self.scrollview.frame.size.width;
        int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

        // 修改页数，此时将触发scrollview页面的更新
        self.pagecontrol.currentPage = page;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}


- (IBAction)changePage {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollview.frame.size.width * self.pagecontrol.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollview.frame.size;
    [self.scrollview scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
    pageControlBeingUsed = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
