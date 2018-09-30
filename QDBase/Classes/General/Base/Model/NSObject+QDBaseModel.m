//
//  NSObject+QDBaseModel.m
//  QDBase
//
//  Created by QiaoData on 2018/8/9.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 给所有的model添加一个id字段

#import "NSObject+QDBaseModel.h"
#import <objc/runtime.h>

const void *kPropertyId = @"kPropertyId";

@implementation NSObject (QDBaseModel)

- (void)setId:(NSString *)id {
    objc_setAssociatedObject(self, kPropertyId, id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)id {
    id modelId = objc_getAssociatedObject(self, kPropertyId);
    NSString *modelIdStr = judgeString(modelId);
    return modelIdStr;
    
}

@end
