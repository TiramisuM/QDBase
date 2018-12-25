//
//  NSString+Deal.m
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/10/22.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 字符串处理

#import "NSString+Deal.h"

@implementation NSString (Deal)

/// 字符串高亮
- (NSMutableAttributedString *)getHighTextWithKeyWords:(NSArray *)keyWords color:(UIColor *)color {
    
    NSString *lowStr = [self lowercaseString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *searchStr in keyWords) {
        
        NSArray *matches = [self rangeOfSubString:searchStr.lowercaseString inString:lowStr];
        
        for(NSValue *value in matches) {
            NSRange matchRange = [value rangeValue];
            [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil] range:matchRange];
        }
    }
    
    return attributeString;
}

/// 查找字符串所在位置
- (NSArray *)rangeOfSubString:(NSString *)subStr inString:(NSString *)string {
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:subStr];
    
    for(int i = 0; i < string.length; i++) {
        
        NSString *temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i,subStr.length};
            if (range.location+range.length <= string.length) {
                [rangeArray addObject: [NSValue valueWithRange:range]];
            }
        }
    }
    return rangeArray;
}

+ (CGFloat)measureSinglelineStringWidth:(NSString *)str andFont:(UIFont*)font {
    if (str == nil) {
        return 0;
    }
    CGSize measureSize;
    measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    return ceil(measureSize.width);
}

+ (CGFloat)measureSingleStringHeight:(NSString *)str andFont:(UIFont *)font width:(CGFloat)width {
    CGSize sizeToFit = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] // 文字的属性
                                         context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height;
}

//判断字符串为4～16位“字符”
- (BOOL)isValidateLength {
    NSUInteger  character = 0;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa5){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (character >=4 && character <=16) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)subStringWithMaxLength:(NSInteger)maxLength needAppendDot:(BOOL)needAppendDot {
    if (self.length <= (maxLength / 2)) {
        return self;
    }
    int count = 0;
    NSMutableString *stringM = [NSMutableString string];
    for (NSInteger i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        count += [subString lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 1 ? 2 : 1;
        [stringM appendString:subString];
        if (count == maxLength) {
            if (needAppendDot) {
                return i == self.length - 1 ? [stringM copy] : [NSString stringWithFormat:@"%@...", [stringM copy]];
            } else {
                return [stringM copy];
            }
        } else if (count > maxLength) {
            
            if (needAppendDot) {
                return i == self.length - 1 ? [stringM substringToIndex:stringM.length - 1] : [NSString stringWithFormat:@"%@...", [stringM substringToIndex:stringM.length - 1]];
            } else {
                return [stringM substringToIndex:stringM.length - 1];
            }
        }
    }
    return self;
}

- (NSString *(^)(NSString *))append {
    return ^NSString *(NSString * str){
        if (!str) {
            return @"";
        }
        return [self stringByAppendingString:str];
    };
}

- (NSString *(^)(void))trim {
    return ^NSString *{
        return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    };
}

@end
