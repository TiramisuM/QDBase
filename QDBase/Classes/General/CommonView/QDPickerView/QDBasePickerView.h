//
//  QDBasePickerView.h
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// PickerView基类

#import <UIKit/UIKit.h>
@class PickerModel;

@interface QDBasePickerView : UIView

/// 默认的pickerView
@property (nonatomic, strong) UIPickerView *pickerView;
/// 确定按钮点击block
@property (nonatomic, copy) void(^sureBtnActionBlock)(void);
/// 取消按钮点击和点击空白页隐藏block
@property (nonatomic, copy) void(^cancelBtnActionBlock)(void);
/// 点击空白页隐藏的block
@property (nonatomic, copy) void(^tapBlankViewActionBlock)(void);
/**
 切换pickerView 标题
 
 @param title 标题内容
 */
- (void)changePickerViewTitle:(NSString *)title;
/**
 更新确认按钮标题
 
 @param sureTitle 确认按钮标题
 */
- (void)updateSureButtonTitle:(NSString *)sureTitle;
/**
 更新取消按钮标题
 
 @param cancelTitle 取消按钮标题
 */
- (void)updateCancelButtonTitle:(NSString *)cancelTitle;

@end

@interface PickerModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;

@end
