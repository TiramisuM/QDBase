//
//  QDHUD.m
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/7/4.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  HUD 提示

#import "QDHUD.h"
#import "ISAnimationLayer.h"

@implementation QDHUD

typedef NS_ENUM(NSUInteger,QDHUDType) {
    QDHUDTypeLoading  = 0,
    QDHUDTypeSuccess,
    QDHUDTypeFail,
};

// UIColor宏定义
#define HUDColorFromHexA(hexValue, alphaValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]
// UIColor宏定义
#define HUDColorFromHex(hexValue) HUDColorFromHexA(hexValue, 1.0)

#define HUD_TAG 10241024

/**
 提示框
 
 @param tips 提示内容
 @param superView 父类view 可传空
 */
+ (void)showTips:(NSString *)tips superView:(UIView *)superView {
    if (!tips) {
        return;
    }
    
    if (!superView) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    
    // 设置背景图
    __block  UIView *backgroundView  = [UIView new];
    backgroundView.backgroundColor = UIColor.blackColor;
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.cornerRadius = 8;
    [superView addSubview:backgroundView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.text = tips;
    [backgroundView addSubview:tipsLabel];

    // 获取文本宽度
    CGFloat tipsStrWidth = [tips sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}].width;
    CGFloat backgroundViewMargin = 30;
    CGFloat tipsLabelMargin = 20;
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 2 * backgroundViewMargin;
    CGFloat tipsLabelWidth = maxWidth - 2 * tipsLabelMargin;

    if (tipsStrWidth > maxWidth - 2 * tipsLabelMargin) {
        // 文字高度计算
        CGFloat tipsLabelHeight = [tipsLabel sizeThatFits:CGSizeMake(tipsLabelWidth, MAXFLOAT)].height;
        // 文字边距加上两边的留白最大各50
        tipsLabel.frame = CGRectMake(tipsLabelMargin, tipsLabelMargin, tipsLabelWidth, tipsLabelHeight);
        backgroundView.frame = CGRectMake(backgroundViewMargin, 0, maxWidth, tipsLabelHeight + 2 * tipsLabelMargin);
        backgroundView.center = superView.center;

    } else {
        
        tipsLabel.frame = CGRectMake(tipsLabelMargin, tipsLabelMargin, tipsLabelWidth , 24);
        backgroundView.frame = CGRectMake(backgroundViewMargin, 0, maxWidth, 24 + 2 * tipsLabelMargin);
        backgroundView.center = superView.center;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    });
}

/// 加载中
+ (void)showLoading {
    
    UIView *blackRoundView = [self creatLoadingViewWithTitle:nil subTitle:nil type:QDHUDTypeLoading];
    ISAnimationLayer *layer = [ISAnimationLayer layer];
    layer.animationType = AnimationTypeRotateRound;
    layer.lineWidth = 4;
    layer.strokeColor = HUDColorFromHex(0xff6600).CGColor;

    layer.frame = CGRectMake(44, 33, 43, 43);
    [blackRoundView.layer addSublayer:layer];
    [layer startAnimation];
}

+ (void)showLoadingWithTitle:(NSString *)title {
    [self showLoadingWithTitle:title subTitle:nil color:nil];
}

+ (void)showLoadingWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self showLoadingWithTitle:title subTitle:subTitle color:nil];
}

+ (void)showLoadingWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color {
    
    if (!title) {
        [self showLoading];
        return;
    }
    
    UIView *blackRoundView = [self creatLoadingViewWithTitle:title subTitle:subTitle type:QDHUDTypeLoading];
    ISAnimationLayer *layer = [ISAnimationLayer layer];
    layer.animationType = AnimationTypeRotateRound;
    layer.lineWidth = 2;
    if (color) {
        layer.strokeColor = color.CGColor;
    }else{
        layer.strokeColor = HUDColorFromHex(0xff6600).CGColor;
    }
    layer.frame = CGRectMake(5, 5, 44, 44);
    [blackRoundView.layer addSublayer:layer];
    [layer startAnimation];
    
}

/// 成功
+ (void)showSuccessWithTitle:(NSString *)title {
    [self showSuccessWithTitle:title subTitle:nil color:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self showSuccessWithTitle:title subTitle:subTitle color:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color{
    UIView *blackRoundView = [self creatLoadingViewWithTitle:title subTitle:subTitle type:QDHUDTypeSuccess];
    // 圆圈
    ISAnimationLayer *roundLayer = [ISAnimationLayer layer];
    roundLayer.animationType = AnimationTypeRound;
    roundLayer.animationDuration = 0.5;
    roundLayer.lineWidth = 2;
    if (color) {
        roundLayer.strokeColor = color.CGColor;
    }else{
        roundLayer.strokeColor = HUDColorFromHex(0x00d142).CGColor;
    }
    roundLayer.frame = CGRectMake(5, 5, 44, 44);
    [blackRoundView.layer addSublayer:roundLayer];
    [roundLayer startAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(roundLayer.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ISAnimationLayer *tickLayer = [ISAnimationLayer layer];
        tickLayer.animationType = AnimationTypeTick;
        tickLayer.lineWidth = 3;
        if (color) {
            tickLayer.strokeColor = color.CGColor;
        }else{
            tickLayer.strokeColor = HUDColorFromHex(0x00d142).CGColor;
        }
        tickLayer.frame = CGRectMake(10, 10, 34, 34);
        [blackRoundView.layer addSublayer:tickLayer];
        [tickLayer startAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddenWithType:QDHUDTypeSuccess];
        });
    });
}

/// 失败
+ (void)showFailWithTitle:(NSString *)title {
    [self showFailWithTitle:title subTitle:nil color:nil];
}

+ (void)showFailWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self showFailWithTitle:title subTitle:subTitle color:nil];
}

+ (void)showFailWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color {
    
    UIView *blackRoundView = [self creatLoadingViewWithTitle:title subTitle:subTitle type:QDHUDTypeFail];
    // 圆圈
    ISAnimationLayer *roundLayer = [ISAnimationLayer layer];
    roundLayer.animationType = AnimationTypeRound;
    roundLayer.animationDuration = 0.5;
    roundLayer.lineWidth = 2;
    if (color) {
        roundLayer.strokeColor = color.CGColor;
    }else{
        roundLayer.strokeColor = HUDColorFromHex(0xeb4b4b).CGColor;
    }
    roundLayer.frame = CGRectMake(5, 5, 44, 44);
    [blackRoundView.layer addSublayer:roundLayer];
    [roundLayer startAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(roundLayer.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ISAnimationLayer *tickLayer = [ISAnimationLayer layer];
        tickLayer.animationType = AnimationTypeFork;
        tickLayer.lineWidth = 3;
        tickLayer.animationDuration = 0.5;

        if (color) {
            tickLayer.strokeColor = color.CGColor;
        }else{
            tickLayer.strokeColor = HUDColorFromHex(0xeb4b4b).CGColor;
        }
        tickLayer.frame = CGRectMake(10, 10, 34, 34);
        [blackRoundView.layer addSublayer:tickLayer];
        [tickLayer startAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddenWithType:QDHUDTypeFail];
        });
    });
}

+ (void)hidden {
    
    [self hiddenWithType:QDHUDTypeLoading];
}

+ (void)hiddenWithType: (QDHUDType)type {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    NSInteger viewTag = HUD_TAG + type;

    if ([keyWindow viewWithTag:viewTag]) {
        if ([[keyWindow viewWithTag:viewTag] isKindOfClass:[UIView class]]) {
            [UIView animateWithDuration:0.3 animations:^{
                [keyWindow viewWithTag:viewTag].alpha = 0;
            } completion:^(BOOL finished) {
                [[keyWindow viewWithTag:viewTag] removeFromSuperview];
            }];
        }
    }
}

/// 创建初始View 并返回需要操作的圆圈View;
+ (UIView *)creatLoadingViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(QDHUDType)type{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSInteger viewTag = HUD_TAG + type;
    NSInteger loadingTag = HUD_TAG + QDHUDTypeLoading;
    
    if ([keyWindow viewWithTag:loadingTag]) {
        if ([[keyWindow viewWithTag:loadingTag] isKindOfClass:[UIView class]]) {
            [[keyWindow viewWithTag:loadingTag] removeFromSuperview];
        }
    }
    UIView *backBlackView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    backBlackView.tag = viewTag;
    backBlackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [keyWindow addSubview:backBlackView];
    
    [UIView animateWithDuration:0.3 animations:^{
        backBlackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }];
    
    UIView *hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 95)];
    hudView.backgroundColor = [UIColor clearColor];
    if (subTitle) {
        hudView.frame = CGRectMake(0, 0, 180, 123);
    }
    hudView.center = keyWindow.center;
    hudView.tag = 1000;
    [backBlackView addSubview:hudView];
    
    if (!title) {
        hudView.frame = CGRectMake(0, 0, 132, 110);
        hudView.center = keyWindow.center;
        hudView.backgroundColor = [UIColor blackColor];
        hudView.layer.cornerRadius = 8;
        return hudView;
    }
    
    // 黑色长方形
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 180, 75)];
    if (subTitle) {
        blackView.frame = CGRectMake(0, 20, 180, 103);
    }
    blackView.backgroundColor = [UIColor blackColor];
    blackView.layer.cornerRadius = 8;
    [self addShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 4) radius:blackView.layer.cornerRadius opacity:0.2 view:blackView];
    [hudView addSubview:blackView];
    
    /// 黑色圆形
    UIView *blackRoundView = [[UIView alloc]initWithFrame:CGRectMake(180/2.0 - 54/2.0, 0, 54, 54)];
    blackRoundView.backgroundColor = [UIColor blackColor];
    blackRoundView.layer.cornerRadius = blackRoundView.frame.size.width/2.0;
    [self addShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 4) radius:blackRoundView.layer.cornerRadius opacity:0.2 view:blackRoundView];
    [hudView addSubview:blackRoundView];
    

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 180 - 20, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (subTitle) {
        titleLabel.textColor = [UIColor whiteColor];
    }else{
        titleLabel.textColor = HUDColorFromHex(0x999999);
    }
    titleLabel.text = title;
    [hudView addSubview:titleLabel];
    
    if (subTitle) {
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, 180 - 20, 20)];
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = HUDColorFromHex(0x999999);
        subTitleLabel.text = subTitle;
        [hudView addSubview:subTitleLabel];
    }
    
    return blackRoundView;
}

/**
 添加阴影
 
 @param color 阴影颜色 color000000
 @param offset 阴影偏移量 CGSizeMake(0, 4)
 @param radius 阴影圆角 4
 @param opacity 阴影透明度 0.10
 */
+ (void)addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity view:(UIView *)view{
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = offset;
    view.layer.shadowOpacity = opacity;
    view.layer.shadowRadius = radius;
    view.clipsToBounds = NO;
}

@end
