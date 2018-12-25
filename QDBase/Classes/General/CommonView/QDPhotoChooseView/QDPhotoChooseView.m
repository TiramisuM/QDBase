//
//  QDPhotoChooseView.m
//  RecruitmentFrog
//
//  Created by QiaoData on 2017/4/23.
//  Copyright © 2017年 QiaoData. All rights reserved.
/// 图片选择器

#import "QDPhotoChooseView.h"
#import "QDActionSheet.h"

static QDPhotoChooseView *_pickView;
@interface QDPhotoChooseView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) UIViewController *viewController;

@property (nonatomic, copy) ImageChooseBlock imageChooseBlock;

@end

@implementation QDPhotoChooseView


+ (void)showPhotoChooseViewWithViewController:(UIViewController *)viewController imageChooseBlock:(ImageChooseBlock)imageChooseBlock {
    
    _pickView = [[QDPhotoChooseView alloc] init];
    _pickView.imageChooseBlock = imageChooseBlock;
    _pickView.viewController = viewController;
    
    QDActionSheet *actionSheet = [[QDActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册选择"]];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    actionSheet.actionSheetClick = ^(NSInteger index) {
        
        UIImagePickerControllerSourceType sourceType = 0;
        
        if (index == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if (index == 1) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [_pickView chooseImageWithPickerControllerSourceType:sourceType];
    };
}

- (void)chooseImageWithPickerControllerSourceType:(UIImagePickerControllerSourceType)type {
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ============== PickerViewDelegate ================

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if (self.imageChooseBlock) {
        self.imageChooseBlock(image);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    _pickView = nil;
}

@end
