//
//  QDNavigationBarView.h
//  QDBase
//
//  Created by qiaodata100 on 2018/9/13.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义导航条

#import <UIKit/UIKit.h>

@interface QDNavigationBarView : UIView
/**
 生成控制器顶部的导航条

 @warning 使用的时候要将原先的NavigationBarHidden设置为NO
 @param viewController 展示的控制器
 @return QDNavigationBarView
 */
+ (instancetype)navigationBarViewWithViewController:(UIViewController *)viewController;
/**
 设置顶部导航条的标题文字

 @param title 标题文字
 */
- (void)setTitle:(NSString *)title;
/**
 给自定义导航条增加左按钮

 @warning 如果不添加，则使用默认的返回按钮及关闭按钮
 @param leftButton 自定义导航条的左边按钮
 */
- (void)addLeftButton:(UIButton *)leftButton;
/**
 给自定义导航条增加多个左按钮
 
 @warning 如果不添加，则使用默认的返回按钮及关闭按钮
 @param leftButtons 自定义导航条的多个左边按钮
 */
- (void)addLeftButtons:(NSArray<UIButton *> *)leftButtons;
/**
 给自定义导航条增加右按钮
 
 @warning 如果不添加，则使用默认的返回按钮及关闭按钮
 @param rightButton 自定义导航条的右边按钮
 */
- (void)addRightButton:(UIButton *)rightButton;
/**
 给自定义导航条增加多个右按钮
 
 @warning 如果不添加，则使用默认的返回按钮及关闭按钮
 @param rightButtons 自定义导航条的多个右边按钮
 */
- (void)addRightButtons:(NSArray<UIButton *> *)rightButtons;
/**
 @brief 回到上一页
 @discussion 开发者不用管是push进来的还是present进来的
 */
- (void)backPrePage;
@end
