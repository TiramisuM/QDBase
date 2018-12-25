//
//  NSString+Deal.h
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/10/22.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 字符串处理

#import <Foundation/Foundation.h>

@interface NSString (Deal)


/**
 字符串部分高亮

 @param keyWords 高亮字符串数组
 @param color 高亮颜色
 @return 高亮后的字符串 NSMutableAttributedString
 */
- (NSMutableAttributedString *)getHighTextWithKeyWords:(NSArray *)keyWords color:(UIColor *)color;

/**
 获取字符串宽度
 
 @param str 字符串
 @param font 字体
 @return 字符串宽度 CGFloat
 */
+ (CGFloat)measureSinglelineStringWidth:(NSString *)str andFont:(UIFont *)font;

/**
 获取字符串高度
 
 @param str 字符串
 @param font 字体
 @return 字符串高度 CGFloat
 */
+ (CGFloat)measureSingleStringHeight:(NSString *)str andFont:(UIFont *)font width:(CGFloat)width;

/**
 判断字符长度是否是4-16位（支持中英混排）
 
 @return BOOL
 */
- (BOOL)isValidateLength;
/**
 截取字符串长度 中文为2 英文数字为1

 @param maxLength 需要的长度
 @param needAppendDot 是否需要拼...
 @return 截取后的字符串
 */
- (NSString *)subStringWithMaxLength:(NSInteger)maxLength needAppendDot:(BOOL)needAppendDot;

/**
 拼接字符串处理
 */
- (NSString *(^)(NSString *))append;
/**
 去除空格
 */
- (NSString *(^)(void))trim;

@end
