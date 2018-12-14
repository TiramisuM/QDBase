//
//  NSString+NetworkSign.m
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/10/18.
//  Copyright © 2018年 QiaoData. All rights reserved.
///  网络请求sign

#import "NSString+NetworkSign.h"

static  NSString *const SIGNSTR = @"qiaodata";

@implementation NSString (NetworkSign)

- (NSString *)creatNetworkSign {
    NSString *signStr = [self stringByAppendingString:SIGNSTR];
    signStr = [[signStr MD5String] MD5String];
    return signStr;
}

@end
