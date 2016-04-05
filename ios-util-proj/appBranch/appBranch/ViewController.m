//
//  ViewController.m
//  appBranch
//
//  Created by 熊海涛 on 16/3/22.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import "XhtButtonPanel.h"
#import "SettingViewController.h"

@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UICollectionView* collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置标题
    self.title = @"appDetailDemo";
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    // 设置profileview
    UIView* appProfile = [[UIView alloc]init];
    appProfile.frame = CGRectMake(0, 20, viewWidth, 80);
    appProfile.backgroundColor = [UIColor redColor];
    [self.view addSubview:appProfile];
    
    
    // 设置segmentview
    // Minimum code required to use the segmented control with the default styling.
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"设置", @"应用详情"]];
    segmentedControl.frame = CGRectMake(0, CGRectGetHeight(appProfile.frame), viewWidth, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor blackColor];
    segmentedControl.verticalDividerWidth = 1.5f;
    
//    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    // 设置segment回调
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];

    // 设置轮播图片
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:[UIImage imageNamed:@"banner1.png"] tag:1001];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"title2" image:[UIImage imageNamed:@"banner2.png"] tag:1002];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"title3" image:[UIImage imageNamed:@"banner3.png"] tag:1003];
    SGFocusImageItem *item4 = [[SGFocusImageItem alloc] initWithTitle:@"title4" image:[UIImage imageNamed:@"banner4.png"] tag:1004];
    
    
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(appProfile.frame)+CGRectGetHeight(segmentedControl.frame), viewWidth, 100) delegate:nil focusImageItems:item1, item2, item3, item4, nil];
    __weak __typeof(&*imageFrame) weakImageFrame = imageFrame;
    imageFrame.didSelectItemBlock = ^(SGFocusImageItem *item) {
        NSLog(@"%@ tapped", item.title);
    };
    imageFrame.switchTimeInterval = 3;
    imageFrame.autoScrolling = YES;// 自动滚动
    [self.view addSubview:imageFrame];
//    [[[[UIApplication sharedApplication] delegate] window] addSubview:imageFrame];
    
    
    // 设置buttonPanel
    XhtButtonItem* xhtitem1 = [XhtButtonItem itemWithTitle:@"title1" image:[UIImage imageNamed:@"ic_mail"] tag:1];
    XhtButtonItem* xhtitem2 = [XhtButtonItem itemWithTitle:@"title2" image:[UIImage imageNamed:@"ic_pwd"] tag:2];
    XhtButtonItem* xhtitem3 = [XhtButtonItem itemWithTitle:@"title3" image:[UIImage imageNamed:@"ic_uncheck"] tag:3];
    NSArray* xhtItems = [NSArray arrayWithObjects:xhtitem1,xhtitem2,xhtitem3,nil ];
    
    XhtButtonPanel* panel = [[XhtButtonPanel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(appProfile.frame)+CGRectGetHeight(segmentedControl.frame)+CGRectGetHeight(imageFrame.frame)-20, viewWidth, 40) delegate:self items:xhtItems];
//    panel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:panel];
//    
//    // 设置 scrollview
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(appProfile.frame)+CGRectGetHeight(segmentedControl.frame)+CGRectGetHeight(imageFrame.frame)-20, viewWidth, 210)];// add xht, heitht -20 to follow the image ,,, why?
//    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.showsHorizontalScrollIndicator = YES;
//    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, 200);
//    self.scrollView.delegate = self;
//    [self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, 200) animated:NO];
//    [self.view addSubview:self.scrollView];
//    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 210)];
//    label1.text = @"Worldwide";
//    [self setApperanceForLabel:label1];
//    [self.scrollView addSubview:label1];
//    
//   
//    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, 210)];
//    label2.text = @"Local";
//    [self setApperanceForLabel:label2];
//    [self.scrollView addSubview:label2];

    // Do any additional setup after loading the view, typically from a nib.
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing =0;
//    flowLayout.
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(panel.frame), viewWidth, 200) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor grayColor]];
    
    //注册Cell，必须要有
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self presentViewController:[[SettingViewController alloc] init] animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}


- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}



-(void)didClickButton:(int)tag{
    NSLog(@"button clicked:%d",tag);
    
}

#pragma mark collection-view-delegate

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor colorWithRed:((100 * indexPath.row) / 255.0) green:((2 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(74, 74);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 2, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
    NSLog(@"section===%ld",(long)indexPath.section);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
