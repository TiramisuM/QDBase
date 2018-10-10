//
//  RoundAnimationLayer.m
//  
//
//  Created by qiaodaImac on 2018/6/23.
//  Copyright © 2018年 巧达数据. All rights reserved.
/// 带动画layer

#import "QDAnimationLayer.h"

@implementation QDAnimationLayer

+ (instancetype)layer{
    return [[QDAnimationLayer alloc]init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineWidth = 4;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineCap = kCALineCapRound;
        self.lineJoin = kCALineJoinRound;
    }
    return self;
}

- (void)setSuperView:(UIView *)superView{
    _superView = superView;
    [superView.layer addSublayer:self];
}

- (void)startAnimation{
    
    switch (self.animationLayerType) {
            
        case QDAnimationLayerTypeRotateRound:// 一直旋转的圆圈
            [self drawRotateRound];
            break;
        case QDAnimationLayerTypeRound:// 绘制一个圆圈
            [self drawRound];
            break;
        case QDAnimationLayerTypeTick:// 绘制一个对勾
            [self drawTick];
            break;
        case QDAnimationLayerTypeFork:// 绘制一个叉号
            [self drawFork];
            break;
        default:
            break;
    }
}

- (void)stopAnimation{
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}

/**
 绘制一直旋转的圆圈
 */
- (void)drawRotateRound{
    
    const int STROKE_WIDTH = self.lineWidth;
    
    if (self.frame.size.width == 0) {
        self.frame = self.superlayer.bounds;
    }
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath addArcWithCenter: CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - STROKE_WIDTH startAngle: 0 endAngle: 2 * M_PI clockwise: YES];
    
    self.fillColor = [UIColor clearColor].CGColor;
    self.path = progressPath.CGPath;
    
    CAMediaTimingFunction *progressRotateTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.80 :0.75 :1.00];
    
    // 开始划线的动画
    CABasicAnimation *progressLongAnimation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
    progressLongAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    progressLongAnimation.toValue = [NSNumber numberWithFloat: 1.0];
    progressLongAnimation.duration = 2;
    progressLongAnimation.timingFunction = progressRotateTimingFunction;
    progressLongAnimation.repeatCount = 10000;
    // 线条逐渐变短收缩的动画
    CABasicAnimation *progressLongEndAnimation = [CABasicAnimation animationWithKeyPath: @"strokeStart"];
    progressLongEndAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    progressLongEndAnimation.toValue = [NSNumber numberWithFloat: 1.0];
    progressLongEndAnimation.duration = 2;
    CAMediaTimingFunction *strokeStartTimingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints: 0.65 : 0.0 :1.0 : 1.0];
    progressLongEndAnimation.timingFunction = strokeStartTimingFunction;
    progressLongEndAnimation.repeatCount = 10000;
    // 线条不断旋转的动画
    CABasicAnimation *progressRotateAnimation = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    progressRotateAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    progressRotateAnimation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
    progressRotateAnimation.repeatCount = 10000;
    progressRotateAnimation.duration = 4;
    
    [self addAnimation:progressLongAnimation forKey: @"strokeEnd"];
    [self addAnimation:progressRotateAnimation forKey: @"transfrom.rotation.x"];
    [self addAnimation: progressLongEndAnimation forKey: @"strokeStart"];
}

/**
 绘制圆圈
 */
- (void)drawRound{
    
    const int STROKE_WIDTH = self.lineWidth;
    // 画圈
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter: CGPointMake(self.frame.size.width / 2,self.frame.size.height / 2) radius:self.frame.size.width / 2 - STROKE_WIDTH startAngle: - M_PI * 3/4 endAngle: M_PI * 5/4 clockwise: YES];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    // 新建图层——绘制上面的圆圈
    self.path = path.CGPath;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    if (self.animationDuration != 0) {
        animation.duration = self.animationDuration;
    }else{
        animation.duration = 0.5;
    }

    [self addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

/**
 绘制对勾
 */
- (void)drawTick{
    
    self.lineCap = kCALineCapButt;
    self.lineJoin = kCALineJoinMiter;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/4 - 3, self.frame.size.height/2 - 3)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2 - 3, self.frame.size.height/4*3 - 3)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/4*3 + 3, self.frame.size.height/3 - 2)];
    
    // 新建图层——绘制上面的对勾
    self.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    
    if (self.animationDuration != 0) {
        animation.duration = self.animationDuration;
    }else{
        animation.duration = 0.5;
    }

    [self addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

/**
 绘制叉号
 */
- (void)drawFork{
    self.lineCap = kCALineCapButt;
    self.lineJoin = kCALineJoinMiter;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/4, self.frame.size.height/4)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/4*3, self.frame.size.height/4*3)];
    [path moveToPoint:CGPointMake(self.frame.size.width/4*3, self.frame.size.height/4)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/4, self.frame.size.height/4*3)];

    // 新建图层——绘制上面的叉号
    self.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    
    if (self.animationDuration != 0) {
        animation.duration = self.animationDuration;
    }else{
        animation.duration = 0.5;
    }
    
    [self addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

@end
