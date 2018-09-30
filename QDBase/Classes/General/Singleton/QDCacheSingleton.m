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

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return [QDCacheSingleton shareInstance];
}

- (void)clearAllCache {
    [self clearNetworkCache];
    [self clearAddressBookCache];
}

- (void)clearNetworkCache {
    if ([QDCacheSingleton shareInstance].networkCache) {
        [[QDCacheSingleton shareInstance].networkCache removeAllObjects];
        [QDCacheSingleton shareInstance].networkCache = nil;
    }
}

- (void)clearAddressBookCache {
    if ([QDCacheSingleton shareInstance].addressBookCache) {
        [[QDCacheSingleton shareInstance].addressBookCache removeAllObjects];
        [QDCacheSingleton shareInstance].addressBookCache = nil;
    }
}

#pragma mark - ============== Lazy Load ================
- (YYCache *)networkCache {
    if (!_networkCache) {
        _networkCache = [[YYCache alloc] initWithName:[NSString stringWithFormat:@"UserCache_NetworkCache"]];
        _networkCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _networkCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _networkCache;
}

- (YYCache *)addressBookCache {
    if (!_addressBookCache) {
        _addressBookCache = [[YYCache alloc] initWithName:[NSString stringWithFormat:@"UserCache_AddressBookCache"]];
        _addressBookCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _addressBookCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _addressBookCache;
}

@end
