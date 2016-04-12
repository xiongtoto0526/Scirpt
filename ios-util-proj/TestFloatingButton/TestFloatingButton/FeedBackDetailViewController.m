//
//  FeedBackDetailViewController.m
//  TestFloatingButton
//
//  Created by 熊海涛 on 16/4/12.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "FeedBackDetailViewController.h"
#import "EditImageViewController.h"

//#import "DRPReporter.h"

@interface FeedBackDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageEditDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (strong,nonatomic) UIActionSheet* actionSheet;
@property (strong,nonatomic) UIImage* currentImage;
//@property (strong,nonatomic) UIImagePickerController* picker;
@end

@implementation FeedBackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交反馈";
    self.selectButton.tag =0;
    [self.selectButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = submitButtonItem;
    
}

-(void)submitButtonClicked{
    NSLog(@"will send feedback to tako server...");
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)selectImage:(UIButton*)bt{
    
    NSLog(@"will show all image...");
    
    // TODO：出现多个button时，需要将button和image绑定
    if (bt.tag == 9999) {
        EditImageViewController* editVc = [EditImageViewController new];
        editVc.preImage = self.currentImage;
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
    self.selectButton.tag = 9999;
    [self.selectButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        EditImageViewController* editVc = [EditImageViewController new];
        editVc.preImage = self.currentImage;
        editVc.delegate = self;
        [self.navigationController pushViewController:editVc animated:NO];
    }];
    
    
    // 开始监听编辑事件
//    [DRPReporter startListeningShake];
//    [DRPReporter registerReporterViewControllerDelegate:self];
    
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

//// 绘制完成
//- (void)reporterViewController:(DRPReporterViewController *)reporterViewController didFinishDrawingImage:(UIImage *)image withNoteText:(NSString *)noteText{
//    self.textView.text = noteText;
//    self.currentImage = image;
//    [self.selectButton setBackgroundImage:image forState:UIControlStateNormal];
//    [reporterViewController dismissViewControllerAnimated:NO completion:nil];
//}

#pragma mark 编辑图片完成
-(void)imageEditFinish:(UIImage*)image{
    self.currentImage = image;
    [self.selectButton setBackgroundImage:image forState:UIControlStateNormal];
}

@end
