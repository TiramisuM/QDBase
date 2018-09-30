//
//  UIFont+FitSize.m
//  InsuranceAgentRelation
//
//  Created by QiaoData on 2018/8/23.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 适配不同屏幕的字体

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define kFontSizeScale  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define IOS9_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

@implementation UIFont (FitTextFont)

+ (void)load {
    Method systemFontOfSize = class_getClassMethod([self class], @selector(systemFontOfSize:));
    Method adjustFontOfSize = class_getClassMethod([self class], @selector(adjustFontOfSize:));
    method_exchangeImplementations(systemFontOfSize, adjustFontOfSize);
    
    Method boldSystemFontOfSize = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));
    Method adjustBoldSystemFontOfSize = class_getClassMethod([self class], @selector(adjustBoldFontOfSize:));
    method_exchangeImplementations(boldSystemFontOfSize, adjustBoldSystemFontOfSize);
    
    Method italicSystemFontOfSize = class_getClassMethod([self class], @selector(italicSystemFontOfSize:));
    Method adjustItalicFontOfSize = class_getClassMethod([self class], @selector(adjustItalicFontOfSize:));
    method_exchangeImplementations(italicSystemFontOfSize, adjustItalicFontOfSize);
    
}

+(UIFont *)adjustFontOfSize:(CGFloat)fontSize {
    UIFont *newFont = nil;
    CGFloat newFontSize = 0.f;
    newFontSize = fontSize * kFontSizeScale;
    
    if (IOS9_OR_LATER) {
        newFont = [UIFont fontWithName:@"PingFangSC-Regular" size:newFontSize];
    } else {
        newFont = [UIFont adjustFontOfSize:newFontSize];
    }
    
    return newFont;
}

+(UIFont *)adjustBoldFontOfSize:(CGFloat)fontSize {
    UIFont *newFont = nil;
    CGFloat newFontSize = 0.f;
    newFontSize = fontSize * kFontSizeScale;
    
    if (IOS9_OR_LATER) {
        newFont = [UIFont fontWithName:@"PingFangSC-Medium" size:newFontSize];
    } else {
        newFont = [UIFont adjustBoldFontOfSize:newFontSize];
    }
    
    return newFont;
}

+ (UIFont *)adjustItalicFontOfSize:(CGFloat)fontSize {
    UIFont *newFont = nil;
    CGFloat newFontSize = 0.f;
    newFontSize = fontSize * kFontSizeScale;
    newFont = [UIFont adjustItalicFontOfSize:newFontSize];
    return newFont;
}

@end
