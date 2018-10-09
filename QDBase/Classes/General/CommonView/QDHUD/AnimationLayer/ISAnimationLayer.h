//
//  RoundAnimationLayer.h
//
//
//  Created by qiaodaImac on 2018/6/23.
//  Copyright © 2018年 巧达数据. All rights reserved.
/// 带动画layer

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, AnimationType){
    AnimationTypeRotateRound = 0,// 一直旋转的圆圈
    AnimationTypeRound       = 1,// 绘制一个圆圈
    AnimationTypeTick        = 2,// 绘制一个对勾
    AnimationTypeFork        = 3 // 绘制一个叉号
};

@interface ISAnimationLayer : CAShapeLayer

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

/// 动画类型
@property (nonatomic, assign) AnimationType animationType;
/// 动画时长(非必须)
@property (nonatomic, assign) CGFloat animationDuration;
@end
