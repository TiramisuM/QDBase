//
//  QDHUD.h
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/7/4.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  HUD 提示器

#import <UIKit/UIKit.h>

@interface QDHUD : UIView

/**
 提示框
 
 @param tips 提示内容
 @param superView 父类view 可传空
 */
+ (void)showTips:(NSString *)tips superView:(UIView *)superView;

/// 加载中 ✳
+ (void)showLoading;
+ (void)showLoadingWithTitle:(NSString *)title;
+ (void)showLoadingWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

/// 成功 ✅
+ (void)showSuccessWithTitle:(NSString *)title;
+ (void)showSuccessWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

/// 警告 ❗
+ (void)showWarningWithTitle:(NSString *)title;
+ (void)showWarningWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

/// 失败 ❎
+ (void)showFailWithTitle:(NSString *)title;
+ (void)showFailWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

/// 隐藏
+ (void)hidden;
@end
