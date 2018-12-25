//
//  QDBaseDictManager.m
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/12/6.
//  Copyright © 2018 QiaoData. All rights reserved.
/// 与用户不绑定缓存

#import "QDBaseDictManager.h"

@implementation QDBaseDictManager

static QDBaseDictManager *instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

@end
