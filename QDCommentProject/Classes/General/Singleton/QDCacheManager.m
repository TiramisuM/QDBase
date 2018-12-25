//
//  QDCacheManager.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 缓存单例

#import "QDCacheManager.h"

@implementation QDCacheManager

static QDCacheManager *instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [QDCacheManager shareInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return [QDCacheManager shareInstance];
}

/**
 获取缓存大小
 */
+ (NSInteger)getCacheSize {
    
    NSInteger netCacheSize = [[QDCacheManager shareInstance].networkCache.diskCache totalCost];
    NSInteger addressCacheSize = [[QDCacheManager shareInstance].addressBookCache.diskCache totalCost];
    NSInteger baseDictCache = [[QDCacheManager shareInstance].baseDictCache.diskCache totalCost];
    
    return (netCacheSize + addressCacheSize + baseDictCache);
}

+ (void)clearAllCache {
    [self clearNetworkCache];
    [self clearAddressBookCache];
    [self clearUserInfoDictCache];
}

+ (void)clearNetworkCache {
    if ([QDCacheManager shareInstance].networkCache) {
        [[QDCacheManager shareInstance].networkCache removeAllObjects];
        [QDCacheManager shareInstance].networkCache = nil;
    }
}

+ (void)clearAddressBookCache {
    if ([QDCacheManager shareInstance].addressBookCache) {
        [[QDCacheManager shareInstance].addressBookCache removeAllObjects];
        [QDCacheManager shareInstance].addressBookCache = nil;
    }
}

+ (void)clearUserInfoDictCache {
    if ([QDCacheManager shareInstance].userInfoDictCache) {
        [[QDCacheManager shareInstance].userInfoDictCache removeAllObjects];
        [QDCacheManager shareInstance].userInfoDictCache = nil;
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

- (YYCache *)baseDictCache {
    if (!_baseDictCache) {
        _baseDictCache = [[YYCache alloc] initWithName:[NSString stringWithFormat:@"BaseDictCache"]];
        _baseDictCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _baseDictCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _baseDictCache;
}

- (YYCache *)userInfoDictCache {
    if (!_userInfoDictCache) {
        _userInfoDictCache = [[YYCache alloc] initWithName:[NSString stringWithFormat:@"UserCache_UserInfoDictCache"]];
        _userInfoDictCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _userInfoDictCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _userInfoDictCache;
}

@end
