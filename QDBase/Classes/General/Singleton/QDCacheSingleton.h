//
//  QDCacheSingleton.h
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 缓存单例

#import <Foundation/Foundation.h>
#import "YYCache.h"

@interface QDCacheSingleton : NSObject

/// 单例方法
+ (instancetype)shareInstance;
/// 缓存cache
@property (nonatomic, strong) YYCache *cache;
/**
 清空缓存
 */
- (void)clearCache;

@end
