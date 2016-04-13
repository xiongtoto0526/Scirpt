//
//  FeedBackDetailViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/12.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "FeedBackDetailViewController.h"
#import "EditImageViewController.h"
#import "UIHelper.h"
//#import "UploadImage.h"

#define SELECTED 9999
#define NO_SELECTED 1111




@interface FeedBackDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageEditDelegate,UIActionSheetDelegate,UITextViewDelegate>{
    BOOL isModified;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (strong,nonatomic) UIActionSheet* actionSheet;
@property (strong,nonatomic) UIImage* currentImage;
@property (strong,nonatomic) UIButton* currentButton;
@end

@implementation FeedBackDetailViewController

// 重写返回按钮，以便监听编辑时撤销事件
-(void)backButtonClicked{
    NSLog(@"will back...");
    [self.textView resignFirstResponder];
    if (isModified) {
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未提交,是否退出此次编辑?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
        [vc addAction:cancel];
        [vc addAction:ok];
        [self presentViewController:vc animated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交反馈";
    self.selectButton.tag =NO_SELECTED;
    self.secondSelectButton.tag =NO_SELECTED;
    self.thirdSelectButton.tag = NO_SELECTED;
    isModified = NO;

    // 重写返回按钮
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                      style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // 提交按钮
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = submitButtonItem;
    
    // 单击空白处收起键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    // 初始化隐藏第二，第三个button，并隐藏
    [self.secondSelectButton setHidden:YES];
    [self.thirdSelectButton setHidden:YES];
    [self.selectButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchDown];
    [self.secondSelectButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchDown];
    [self.thirdSelectButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchDown];
    
    // 文本编辑框
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, mainS.height/3);
    self.textView.delegate = self;
    
    // 添加删除按钮
    
    
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textView resignFirstResponder];
}

-(void)submitButtonClicked{
    NSLog(@"will send feedback to tako server...");
    isModified = YES;
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)selectImage:(UIButton*)bt{
    
    self.currentButton = bt;
    if (bt.tag == SELECTED) {
        EditImageViewController* editVc = [EditImageViewController new];
        editVc.preImage = bt.currentBackgroundImage;
        editVc.delegate = self;
        [self.navigationController pushViewController:editVc animated:NO];
    }else{
        [self callActionSheetFunc];
    }
}



/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        [self.actionSheet showInView:self.view];
        self.actionSheet.delegate = self;
        return;
    }
    
    UIAlertController* alertC = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertAction* camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"pai zhao...");
            [self showImageSelectView:UIImagePickerControllerSourceTypeCamera];
            
        }];
        [alertC addAction:camera];
    }
    
    UIAlertAction* pictures = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"pictures...");
        [self showImageSelectView:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel ...");
//        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    [alertC addAction:pictures];
    [alertC addAction:cancel];
    
    [self presentViewController:alertC animated:NO completion:nil];
}


-(void)showImageSelectView:(UIImagePickerControllerSourceType) sourceType{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];

}

#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}


// 选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.currentImage = image;
    [self.currentButton setBackgroundImage:image forState:UIControlStateNormal];
    self.currentButton.tag = SELECTED;
    
    // 显示剩余待上传图片
    if (self.currentButton == self.selectButton) {
        [self.secondSelectButton setHidden:NO];
    }else if (self.currentButton == self.secondSelectButton){
        [self.thirdSelectButton setHidden:NO];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        EditImageViewController* editVc = [EditImageViewController new];
        editVc.preImage = self.currentImage;
        editVc.delegate = self;
        [self.navigationController pushViewController:editVc animated:NO];
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        return;
    }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark 编辑图片完成
-(void)imageEditFinish:(UIImage*)image{
    self.currentImage = image;
    [self.currentButton setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark 编辑文字开始
- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"txet edit finish:%@",textView.text);
    isModified = YES;
}


@end

