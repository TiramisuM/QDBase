//
//  QDFactory.h
//  QDBase
//
//  Created by qiaodata100 on 2018/9/10.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 工厂类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QDFactory : NSObject

@end

@interface QDFactory (UILabel)
/**
 工厂方法创建UILabel

 @param frame 大小及位置
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param textAlignment 文字对齐方式
 @return 返回UILabel
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

@end

@interface QDFactory (UIButton)
/**
 工厂方法创建文字UIButton

 @param frame 大小及位置
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param target 按钮相应的对象
 @param action 按钮相应的方法
 @return 返回UIButton
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font target:(id)target action:(SEL)action;

/**
 工厂方法创建图片UIButton

 @param frame 大小及位置
 @param imageName 正常状况下的图片名称
 @param highlightedImageName 高亮状态下的图片名称
 @param target 按钮相应的对象
 @param action 按钮相应的方法
 @return 返回UIButton
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

@end

@interface QDFactory (UITextField)
/**
 工厂方法创建UITextField

 @param frame 大小及文字
 @param placeholder 占位文字
 @param font 文字字体
 @param textColor 文字颜色
 @return 返回UITextField
 */
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor;

@end

@interface QDFactory (UIAlertController)

/// 点击alert确认的响应事件回调
typedef void (^AlertAction)(UIAlertAction *action);
/**
 工厂方法创建UIAlertController alert样式

 @param title Alert标题
 @param message Alert描述信息
 @param sureAction 确认按钮点击回调 AlertAction
 @return 返回UIAlertController
 */
+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title message:(NSString *)message sureAction:(AlertAction)sureAction;
/**
 工厂方法创建UIAlertController actionSheet样式
 
 @param title Alert标题
 @param message Alert描述信息
 @param sureAction 确认按钮点击回调
 @return 返回UIAlertController AlertAction
 */
+ (UIAlertController *)createAlertActionControllerWithTitle:(NSString *)title message:(NSString *)message sureAction:(AlertAction)sureAction;

@end
