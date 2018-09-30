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
/// 网络请求cache
@property (nonatomic, strong) YYCache *networkCache;
/// 通讯录cache
@property (nonatomic, strong) YYCache *addressBookCache;
/**
 清空网络请求缓存
 */
- (void)clearNetworkCache;
/**
 清空通讯录缓存
 */
- (void)clearAddressBookCache;
/**
 清空所有缓存
 */
- (void)clearAllCache;

@end
