//
//  CustomPhotoChooseView.h
//  RecruitmentFrog
//
//  Created by QiaoData on 2017/4/23.
//  Copyright © 2017年 QiaoData. All rights reserved.
/// 图片选择器

#import <UIKit/UIKit.h>

typedef void(^ImageChooseBlock)(UIImage *image);

@interface QDPhotoChooseView : NSObject

+ (void)showPhotoChooseViewWithViewController:(UIViewController *)viewController imageChooseBlock:(ImageChooseBlock)imageChooseBlock;

@end
