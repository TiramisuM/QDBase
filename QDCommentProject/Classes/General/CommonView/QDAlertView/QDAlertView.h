//
//  QDAlertView.h
//  InsuranceAgentRelation
//
//  Created by AngleK on 2018/11/9.
//  Copyright © 2018 QiaoData. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureActionBlcok)(NSString *text);
typedef void(^CancelActionBlcok)(void);

/// 弹窗类型
typedef NS_ENUM(NSInteger, QDAlertViewType) {
    /// 默认弹窗 有title,message,sureButton,cancelButton
    QDAlertViewTypeDefault,
    /// 带输入框的弹窗
    QDAlertViewTypeInput,
    /// 带下次不再提示的弹窗
    QDAlertViewTypeNoRemind,
};


@interface QDAlertView : UIView

/**
 带输入框的弹窗

 @param title 标题
 @param message 描述信息
 @param maxInputCount 最长输入内容
 @param sureAction 确认按钮
 @param cancelAction 取消按钮
 */
+ (void)showInputAlertWithTitle:(NSString *)title
                        message:(NSString *)message
                  maxInputCount:(NSInteger)maxInputCount
                     sureAction:(SureActionBlcok)sureAction
                   cancelAction:(CancelActionBlcok)cancelAction;

/**
 弹框 默认带有确认取消按钮

 @param type 弹框类型
 @param title 标题
 @param message 描述信息
 @param sureAction 确认按钮
 @param cancelAction 取消按钮
 */
+ (void)showAlertWithType:(QDAlertViewType)type
                    title:(NSString *)title
                  message:(NSString *)message
               sureAction:(__nullable SureActionBlcok)sureAction
             cancelAction:(__nullable CancelActionBlcok)cancelAction;
/**
 弹窗 如果输入确认标题则带确认按钮 如果输入取消标题则带取消按钮

 @param type 弹框类型
 @param title 标题
 @param message 描述信息
 @param sureButtonTitle 确认按钮信息
 @param cancelButtonTitle 取消按钮信息
 @param sureAction 确认按钮的点击事件
 @param cancelAction 取消按钮的点击事件
 */
+ (void)showAlertWithType:(QDAlertViewType)type
                    title:(NSString *)title
                  message:(NSString *)message
          sureButtonTitle:(NSString *)sureButtonTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
               sureAction:(SureActionBlcok)sureAction
             cancelAction:(CancelActionBlcok)cancelAction;
/**
 显示强更页面
 
 @param title 标题
 @param message 描述信息
 @param sureButtonTitle 确认按钮信息
 @param cancelButtonTitle 取消按钮信息
 @param sureAction 确认按钮的点击事件
 */
+ (void)showUpdateAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                         isForce:(BOOL)isForce
                 sureButtonTitle:(NSString *)sureButtonTitle
               cancelButtonTitle:(NSString *)cancelButtonTitle
                      sureAction:(SureActionBlcok)sureAction;
/**
 弹窗 带有顶部提示标题的弹窗

 @param type 弹窗类型
 @param tipTitle 提示标题
 @param title 标题
 @param message 描述信息
 @param maxInputCount 最长输入内容
 @param sureButtonTitle 确认按钮信息
 @param cancelButtonTitle 取消按钮信息
 @param sureAction 确认按钮的点击事件
 @param cancelAction 取消按钮的点击事件
 */
+ (void)showAlertWithType:(QDAlertViewType)type
                 tipTitle:(NSString *)tipTitle
                    title:(NSString *)title
                  message:(NSString *)message
            maxInputCount:(NSInteger)maxInputCount
          sureButtonTitle:(NSString *)sureButtonTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
               sureAction:(SureActionBlcok)sureAction
             cancelAction:(CancelActionBlcok)cancelAction;

@end
