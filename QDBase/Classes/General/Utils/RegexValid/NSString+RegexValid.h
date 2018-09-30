//
//  NSString+RegexValid.h
//  QDBase
//
//  Created by QiaoData on 2018/9/29.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 字符串正则校验

#import <Foundation/Foundation.h>

@interface NSString (RegexValid)
/**
 身份证弱校验

 @return 返回是否为正常身份证号
 */
- (BOOL)validateIDCard;
/**
 邮箱弱校验

 @return 返回是否为正常邮箱
 */
- (BOOL)validateEmail;
/**
 手机号弱校验

 @return 是否为正常手机号码
 */
- (BOOL)validatePhoneNumber;

/**
 判断是否包含Emoji

 @return 是否包含Emoji
 */
- (BOOL)containsEmoji;
/**
 将字符串的Emoji移除

 @return 移除Emoji后的字符串
 */
- (NSString *)removeEmoji;


@end
