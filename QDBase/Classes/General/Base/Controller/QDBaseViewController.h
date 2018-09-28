//
//  QDBaseViewController.h
//  QDBase
//
//  Created by qiaodata100 on 2018/8/8.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 基类Controller

#import <UIKit/UIKit.h>
#import "QDRequestResultView.h"

@interface QDBaseViewController : UIViewController

/// 数据请求的结果状态
@property (nonatomic, assign) QDNetworkRequstResultState responseDataState;

/* 网络请求方法，需子类实现 */
- (void)loadData;
- (void)addMoreData;
- (void)baseRequestData;
/**
 使用自定义导航条
 */
- (void)useCustomNavigation;
/**
 @brief 回到上一页
 @discussion 开发者不用管是push进来的还是present进来的
 */
- (void)backPrePage;
/**
 添加请求到网络请求数组中

 @param URLSessionDataTask 网络请求
 */
- (void)addURLSessionDataTask:(NSURLSessionDataTask *)URLSessionDataTask;
/**
 结束当前界面的所有网络请求
 */
- (void)removeAllURLSessionDataTask;
/**
 设置状态栏为白色
 */
- (void)setStatusBarLight;
/**
 设置状态栏为黑色
 */
- (void)setStatusBarDefault;

@end

@interface QDBaseViewController (QDBaseViewControllerRequestResult)

/* 显示对应的状态view */
/**
显示错误请求页面

@return QDRequestResultView
*/
- (QDRequestResultView *)showErrorView;
/**
 显示空白数据页面
 
 @return QDRequestResultView
 */
- (QDRequestResultView *)showEmptyView;
/**
 显示加载页面
 
 @return QDRequestResultView
 */
- (QDRequestResultView *)showLoadingView;
/**
 显示无网络页面

 @return QDRequestResultView
 */
- (QDRequestResultView *)showNoNetView;
/**
 配置结果页面 QDRequestResultView 高度样式等

 @param resultView QDRequestResultView
 */
- (void)configResultView:(QDRequestResultView *)resultView;
/**
 移除当前页面的所有结果页面 QDRequestResultView
 */
- (void)removeResultView;
/**
 点击结果页面的回调方法
 */
- (void)tapResultView;
/**
 点击结果页面的详情的回调方法
 */
- (void)tapInfoBtnInResultView;

@end

@interface QDBaseViewController (QDNavigationBarButtonItem)
/**
 给导航栏增加左导航按钮

 @param leftNavigationButton 左边的导航按钮
 */
- (void)addLeftNavigationButton:(UIButton *)leftNavigationButton;
/**
 给导航栏增加多个左导航按钮

 @warning 需要传入UIButton数组
 @param leftNavigationButtons 左边的导航按钮的数组 NSArray<UIButton *>
 */
- (void)addLeftNavigationButtons:(NSArray<UIButton *> *)leftNavigationButtons;
/**
 给导航栏增加右导航按钮

 @param rightNavigationButton 右边的导航按钮
 */
- (void)addRightNavigationButton:(UIButton *)rightNavigationButton;
/**
 给导航栏增加多个右导航按钮

 @warning 需要传入UIButton数组
 @param rightNavigationButtons 右边的导航按钮的数组 NSArray<UIButton *>
 */
- (void)addRightNavigationButtons:(NSArray<UIButton *> *)rightNavigationButtons;

@end
