//
//  RoundAnimationLayer.h
//
//
//  Created by qiaodaImac on 2018/6/23.
//  Copyright © 2018年 巧达数据. All rights reserved.
/// 带动画layer

#import <UIKit/UIKit.h>

/// AnimationLayer动画类型
typedef NS_ENUM (NSInteger, QDAnimationLayerType){
    /// 一直旋转的圆圈
    QDAnimationLayerTypeRotateRound = 0,
    /// 绘制一个圆圈
    QDAnimationLayerTypeRound       = 1,
    /// 绘制一个对勾
    QDAnimationLayerTypeTick        = 2,
    /// 绘制一个叉号
    QDAnimationLayerTypeFork        = 3
};

@interface QDAnimationLayer : CAShapeLayer

/**
 开始动画
 */
- (void)startAnimation;

/**
 结束动画
 */
- (void)stopAnimation;

/**
 可设置属性
 
 frame 图层位置大小
 fillColor 填充色(默认透明)
 strokeColor 线条颜色(默认白色)
 lineWidth 线条宽度(默认 4)
 superView  图层父视图
 */
@property (nonatomic, strong) UIView *superView;

/// 动画类型 QDAnimationLayerType
@property (nonatomic, assign) QDAnimationLayerType animationLayerType;
/// 动画时长(非必须)
@property (nonatomic, assign) CGFloat animationDuration;
@end
