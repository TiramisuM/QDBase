//
//  QDHUD.m
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/7/4.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  HUD 提示

#import "QDHUD.h"
#import "QDAnimationLayer.h"

@implementation QDHUD

/// HUD指示器类型
typedef NS_ENUM(NSUInteger,QDHUDType) {
    /// 加载中
    QDHUDTypeLoading  = 0,
    /// 警告
    QDHUDTypeWarning,
    /// 成功
    QDHUDTypeSuccess,
    /// 失败
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
/// 提示框默认宽度
#define HUD_WIDTH 160
/// 提示框默认高度
#define HUD_HEIGHT 91
/// 提示语边距
#define HUD_MARGIN 14

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
    
    if (tipsStrWidth > maxWidth - 2 * tipsLabelMargin) {
        
        CGFloat tipsLabelWidth = maxWidth - 2 * tipsLabelMargin;
        // 文字高度计算
        CGFloat tipsLabelHeight = [tipsLabel sizeThatFits:CGSizeMake(tipsLabelWidth, MAXFLOAT)].height;
        // 文字边距加上两边的留白最大各50
        tipsLabel.frame = CGRectMake(tipsLabelMargin, tipsLabelMargin, tipsLabelWidth, tipsLabelHeight);
        backgroundView.frame = CGRectMake(backgroundViewMargin, 0, maxWidth, tipsLabelHeight + 2 * tipsLabelMargin);
        
    } else {
        
        tipsLabel.frame = CGRectMake(tipsLabelMargin, tipsLabelMargin, tipsStrWidth, 24);
        backgroundView.frame = CGRectMake(0, 0, tipsStrWidth + tipsLabelMargin * 2, 24 + 2 * tipsLabelMargin);
        
    }
    
    backgroundView.center = CGPointMake(superView.width/2.0, superView.center.y);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    });
}

/// 加载中
+ (void)showLoading {
    [self showLoadingWithTitle:nil subTitle:nil color:nil];
}

+ (void)showLoadingWithTitle:(NSString *)title {
    [self showLoadingWithTitle:title subTitle:nil color:nil];
}

+ (void)showLoadingWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self showLoadingWithTitle:title subTitle:subTitle color:nil];
}

+ (void)showLoadingWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color {
    
    UIView *blackRoundView = [self creatLoadingViewWithTitle:title subTitle:subTitle type:QDHUDTypeLoading];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator setTransform:CGAffineTransformMakeScale(1.35, 1.35)];
    [blackRoundView addSubview:activityIndicator];
    // 设置小菊花的frame
    activityIndicator.frame= blackRoundView.bounds;
    // 设置背景颜色
    activityIndicator.backgroundColor = HUDColorFromHex(0x474752);
    // 刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:blackRoundView.bounds];
    imageView.image = [UIImage imageNamed:@"hudSuccessIcon"];
    [blackRoundView addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenWithType:QDHUDTypeSuccess];
    });
}

/// 警告
+ (void)showWarningWithTitle:(NSString *)title {
    [self showWarningWithTitle:title subTitle:nil];
}

+ (void)showWarningWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    UIView *blackRoundView = [self creatLoadingViewWithTitle:title subTitle:subTitle type:QDHUDTypeWarning];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:blackRoundView.bounds];
    imageView.image = [UIImage imageNamed:@"hunWarningIcon"];
    [blackRoundView addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenWithType:QDHUDTypeWarning];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:blackRoundView.bounds];
    imageView.image = [UIImage imageNamed:@"hunErrorIcon"];
    [blackRoundView addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenWithType:QDHUDTypeFail];
    });
}

+ (void)hidden {
    
    [self hiddenWithType:QDHUDTypeLoading];
}

+ (void)hiddenWithType:(QDHUDType)type {
    
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

/// 创建初始View 并返回需要操作的loadingView;
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
    
    CGRect hudViewFrame = CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT);
    
    UIView *hudView = [[UIView alloc]initWithFrame:hudViewFrame];
    hudView.backgroundColor = HUDColorFromHex(0x474752);
    if (subTitle) {
        hudView.frame = CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT + 9);
    }
    hudView.center = backBlackView.center;
    hudView.tag = 1000;
    [backBlackView addSubview:hudView];
    
    /// loading
    UIView *blackRoundView = [[UIView alloc]initWithFrame:CGRectMake(HUD_WIDTH/2.0 - 24/2.0, 18, 24, 24)];
    blackRoundView.backgroundColor = HUDColorFromHex(0x474752);
    [hudView addSubview:blackRoundView];
    
    // 没有标题,单独显示loading
    if (!title) {
        hudView.frame = CGRectMake(0, 0, 132, 110);
        hudView.layer.cornerRadius = 8;
        hudView.center = keyWindow.center;
        blackRoundView.center = CGPointMake(hudView.bounds.size.width/2.0, hudView.bounds.size.height/2.0);
        return blackRoundView;
    }
    
    CGFloat titleStrWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    
    //    CGFloat titleLabelHeight = 20;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.text = title;
    [hudView addSubview:titleLabel];
    
    if (titleStrWidth > HUD_WIDTH - HUD_MARGIN * 2) {
        
        if (titleStrWidth < kScreenWidth - HUD_MARGIN * 4) {
            hudViewFrame.size.width = titleStrWidth + HUD_MARGIN * 2;
        } else {
            hudViewFrame.size.width = kScreenWidth - HUD_MARGIN * 4;
        }
    }
    
    // 文字高度计算
    CGFloat titleLabelHeight = [titleLabel sizeThatFits:CGSizeMake(hudViewFrame.size.width - HUD_MARGIN * 2, MAXFLOAT)].height;
    
    titleLabel.frame = CGRectMake(HUD_MARGIN, CGRectGetMaxY(blackRoundView.frame) + 11, hudViewFrame.size.width - HUD_MARGIN * 2, titleLabelHeight);
    
    hudViewFrame.size.height = CGRectGetMaxY(titleLabel.frame) + 10;
    
    // 如果有subTitle
    if (subTitle) {
        
        CGFloat subTitleStrWidth = [subTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = HUDColorFromHex(0xBFBFBF);
        subTitleLabel.text = subTitle;
        [hudView addSubview:subTitleLabel];
        
        if (subTitleStrWidth > titleStrWidth) {
            
            if (subTitleStrWidth < kScreenWidth - HUD_MARGIN * 4) {
                hudViewFrame.size.width = subTitleStrWidth + HUD_MARGIN * 2;
            } else {
                hudViewFrame.size.width = kScreenWidth - HUD_MARGIN * 4;
            }
            
            titleLabel.frame = CGRectMake(HUD_MARGIN, CGRectGetMaxY(blackRoundView.frame) + 11, hudViewFrame.size.width - HUD_MARGIN * 2, titleLabelHeight);
        }
        
        // 文字高度计算
        CGFloat subTitleLabelHeight = [subTitleLabel sizeThatFits:CGSizeMake(hudViewFrame.size.width - HUD_MARGIN * 2, MAXFLOAT)].height;
        
        subTitleLabel.frame = CGRectMake(HUD_MARGIN, CGRectGetMaxY(titleLabel.frame), titleLabel.size.width, subTitleLabelHeight);
        
        hudViewFrame.size.height = CGRectGetMaxY(subTitleLabel.frame) + 10;
    }
    
    hudView.frame = hudViewFrame;
    hudView.center = backBlackView.center;
    blackRoundView.center = CGPointMake(hudView.width/2.0, blackRoundView.center.y);
    hudView.layer.cornerRadius = 8;
    
    return blackRoundView;
}

@end
