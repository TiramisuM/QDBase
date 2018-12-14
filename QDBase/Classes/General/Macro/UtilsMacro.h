//
//  UtilsMacro.h
//  QDBase
//
//  Created by QiaoData on 2018/9/26.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  工具宏

#ifndef UtilsMacro_h
#define UtilsMacro_h


#pragma mark - 屏幕上的一些高度
// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 是否为iPhoneX
#define kIPhoneX (kScreenHeight == 812 ? YES : NO)
// 导航栏高度
#define UI_NAVIGATION_BAR_HEIGHT 44
// 工具栏高度
#define UI_TOOL_BAR_HEIGHT       44
// 底部tabBar高度
#define UI_TAB_BAR_HEIGHT        49
// 状态栏高度
#define UI_STATUS_BAR_HEIGHT     (kIPhoneX ? 44 : 20)
// 安全高度
#define UI_BOTTOM_SAFE_HEIGHT    (kIPhoneX ? 34 : 0)

#pragma mark - 设备及用户信息
// 系统版本号判断
#define SYSTEMVERSION  ([[[UIDevice currentDevice] systemVersion] floatValue])

#pragma mark - 判空处理
// 字符串判空
#define IS_NOT_EMPTY(string) (string != nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@"<null>"] && ![string isEqualToString:@"(null)"])
// 字符串消除异常
#define judgeString(key)  (IS_NOT_EMPTY(key) || [key isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",key] : @"")

#pragma mark - 颜色处理
// UIColor宏定义
#define UIColorFromHexA(hexValue, alphaValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]
// UIColor宏定义
#define UIColorFromHex(hexValue) UIColorFromHexA(hexValue, 1.0)

#pragma mark - 日志
//打印输出
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define NSLog(...) ;
#endif

#pragma mark - 其他方法
// 弱引用self
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// 防止重复点击
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


#endif /* UtilsMacro_h */
