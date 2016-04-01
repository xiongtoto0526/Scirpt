//
//  ButtonPanelViewController.m
//  appBranch
//
//  Created by 熊海涛 on 16/3/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "XhtButtonPanel.h"
#import <objc/runtime.h>

@interface XhtButtonPanel()
@property(nonatomic,retain) NSArray* items;
@end

static const void *XHT_FOCUS_ITEM_ASS_KEY = &XHT_FOCUS_ITEM_ASS_KEY;

#define  DEFAULT_BUTTON_HEIGHT 30
#define  DEFAULT_IMAGE_HEIGHT 20
#define  DEFAULT_IMAGE_X_BUFFER 5

@implementation XhtButtonItem

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag{
    XhtButtonItem* item = [[XhtButtonItem alloc]init];
    item.title = title;
    item.image = image;
    item.tag = tag;
    return item;
}

@end


@implementation XhtButtonPanel

-(id)initWithFrame:(CGRect)frame delegate:(id) delegate items:(NSArray*) items{
    NSLog(@"will init a XhtButtonPanel");
    
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        self.delegate = delegate;
        [self initPanel];
    }
    return self;
}

// todo: 三个button，每个button上面画viewimage.image不单独占据空间

-(void)initPanel{
    
    // 设置背景颜色
//    if(self.color==nil){
//        self.backgroundColor = [UIColor whiteColor];//默认背景颜色
//    }
    
    self.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];//默认背景颜色

    
    CGFloat mainWith = self.frame.size.width;
//    CGFloat mainHeight = self.frame.size.height;
    int buttonWith = 0;
    if (self.height == 0) {
        self.height = DEFAULT_BUTTON_HEIGHT;
    }
    buttonWith = (float)mainWith/[self.items count];
    
    CGSize btSize = CGSizeMake(buttonWith, self.height);
    
    for (int i=0;i< [self.items count];i++) {
        XhtButtonItem* item = [self.items objectAtIndex:i];
       
        CGSize imageSize = item.image.size;

        // 添加image
        UIImageView* tempImageView = [[UIImageView alloc] initWithImage:item.image];
        // 如果image高度大于 button高度，则使用button的高度
        if(imageSize.height> btSize.height){
            imageSize.height = btSize.height;// 直接引用？
        }
        
       
//        tempImageView.frame = CGRectMake(imageSize.width*(i)+btSize.width*(i), 0, imageSize.width, imageSize.height);
        // force to default
        tempImageView.frame = CGRectMake(btSize.width*(i)+DEFAULT_IMAGE_X_BUFFER*(i+1), DEFAULT_BUTTON_HEIGHT/2-DEFAULT_IMAGE_HEIGHT/2, DEFAULT_IMAGE_HEIGHT, DEFAULT_IMAGE_HEIGHT);
        [self addSubview:tempImageView];
        
        NSLog(@"image frame:%@",tempImageView);
        
        // 添加button
//        UIButton* tempButton = [[UIButton alloc] initWithFrame:CGRectMake((imageSize.width*2 + btSize.width)*i, 0, btSize.width, btSize.height)];
        // cut imageview with
        UIButton* tempButton = [[UIButton alloc] initWithFrame:CGRectMake((btSize.width)*i, 0, btSize.width, btSize.height)];
        tempButton.backgroundColor = [UIColor clearColor]; // button的默认颜色
//        tempButton.layer.borderWidth = 0.5;
        

        // todo: is layer possible? is pressed animate possible?
        if (i!=0) {
                   UIView* divider = [[UIView alloc] initWithFrame:CGRectMake((btSize.width)*i, 4, 1.5, DEFAULT_BUTTON_HEIGHT- 4)];// 4 is the divider_y_buffer,1.5 is with
                   divider.backgroundColor = [UIColor grayColor];
        [self addSubview:divider];
        }

        
//        [tempButton.layer ]
        [tempButton setTitle:item.title forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempButton.tag = item.tag;// 注意：不允许用户输入重复的tag
        
        NSLog(@"buttom frame:%@",tempButton);
        
        [tempButton addTarget:self action:@selector(receiveButtonClickEvent:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:tempButton];
    }
}



-(void)receiveButtonClickEvent:(UIButton*)button{
    NSLog(@"receive button click event...");
    [self.delegate didClickButton:(int)button.tag];
}


//- (void)dealloc
//{
//}



@end
