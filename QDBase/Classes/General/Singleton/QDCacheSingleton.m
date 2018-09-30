//
//  QDCacheSingleton.m
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 缓存单例

#import "QDCacheSingleton.h"

@implementation QDCacheSingleton

static QDCacheSingleton *instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [QDCacheSingleton shareInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [QDCacheSingleton shareInstance];
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [[YYCache alloc] initWithName:[NSString stringWithFormat:@"UserCache"]];
        _cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _cache;
}

- (void)clearCache {
    
    if ([QDCacheSingleton shareInstance].cache) {
        [[QDCacheSingleton shareInstance].cache removeAllObjects];
        [QDCacheSingleton shareInstance].cache = nil;
    }
}

@end
