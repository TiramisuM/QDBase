//
//  NSString+RegexValid.m
//  QDBase
//
//  Created by qiaodata100 on 2018/9/29.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 字符串正则校验

#import "NSString+RegexValid.h"

@implementation NSString (RegexValid)

// 弱校验身份证信息
- (BOOL)validateIDCard {
    NSString *IDCardRegex = @"^(\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDCardRegex];
    return [predicate evaluateWithObject:self];
}

// 弱校验邮箱
- (BOOL)validateEmail {
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:self];
}

// 弱校验手机号
- (BOOL)validatePhoneNumber {
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [predicate evaluateWithObject:self];
}

// 判断是否包含Emoji
- (BOOL)containsEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (NSString *)removeEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

@end
