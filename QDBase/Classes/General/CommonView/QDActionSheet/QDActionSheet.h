//
//  HSActionSheet.h
//  HSNews
//
//  Created by Joychen on 15/3/3.
//  Copyright (c) 2016年 Joychen. All rights reserved.
/// 自定义ActionSheet

#import <UIKit/UIKit.h>

@protocol QDActionSheetDelegate <NSObject>

@optional
- (void)didClickOnButtonIndex:(NSInteger)buttonIndex;
- (void)didClickOnDestructiveButton;
- (void)didClickOnCancelButton;

@end

@interface QDActionSheet : UIControl

/// delegate
@property (nonatomic, assign) id<QDActionSheetDelegate>delegate;
/// 按钮点击回调block
@property (nonatomic, copy) void(^actionSheetClick)(NSInteger index);
/// 取消按钮点击回调block
@property (nonatomic, copy) void(^cancelButtonClick)(void);

/// 不带图标actionSheet
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

/// 带图标actionSheet
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray otherButtonIconArray:(NSArray *)otherButtonIconArray;

- (void)showInView:(UIView *)view;

/// 给ActionSheet赋值图标
- (void)setActionSheetImages:(NSArray *)images;

@end
