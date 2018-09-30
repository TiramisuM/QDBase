//
//  QDRequestResultView.h
//  QDBase
//
//  Created by QiaoData on 2018/8/10.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 请求结果后展示的页面

#import <UIKit/UIKit.h>

/// 点击页面的回调block
typedef void(^TapBlock)(void);
/// 点击更多回调block
typedef void(^InfoBlock)(void);

/// 请求结果后展示的页面
@interface QDRequestResultView : UIView

/// 数据请求的结果状态 QDNetworkRequstResultState
@property (nonatomic, assign) QDNetworkRequstResultState resultState;

@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic ,strong) UILabel *subTipLabel;
@property (nonatomic ,strong) UILabel *subClickTipLabel;

@property (nonatomic, copy) NSString *tipMsg;
@property (nonatomic, copy) NSString *subTipMsg;
@property (nonatomic, copy) NSString *subClickTipMsg;

@property (nonatomic, copy) NSString *imageName;
/// 点击页面的回调block TapBlock
@property (nonatomic, copy) TapBlock tapBlock;
/// 点击更多回调block InfoBlock
@property (nonatomic, copy) InfoBlock infoBlock;
/// 图片的y值
@property (nonatomic, assign) CGFloat imageY;
/**
 初始化方法

 @param resultState 数据请求的结果状态 QDNetworkRequstResultState
 @param tapBlock 点击页面的回调block TapBlock
 @return QDRequestResultView
 */
+ (instancetype)resultViewWithResultState:(QDNetworkRequstResultState)resultState tap:(TapBlock)tapBlock;
/**
 隐藏结果页面
 */
- (void)hide;

@end
