//
//  EnumMacro.h
//  QDCommentProject
//
//  Created by QiaoData on 2018/9/26.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  枚举 通常放置全局的一些枚举

#ifndef EnumMacro_h
#define EnumMacro_h

#import <Foundation/Foundation.h>
#pragma mark - 网络请求相关枚举
/// 数据请求的结果状态
typedef NS_ENUM(NSUInteger, QDNetworkRequstResultState) {
    /// 空数据或者没有请求数据
    QDNetworkRequstResultStateEmpty,
    /// 正在加载数据
    QDNetworkRequstResultStateLoading,
    /// 数据返回正常 显示正常数据页面
    QDNetworkRequstResultStateSuccess,
    /// 错误请求，显示错误页面
    QDNetworkRequstResultStateError,
    /// 没有网络
    QDNetworkRequstResultStateNoNet
};

/// 网络缓存机制
typedef NS_ENUM(NSInteger, QDNetCacheRequestPolicy) {
    /// 忽略缓存，重新请求
    QDNetCacheRequestReloadIgnoringCacheData = 0,
    /// 有缓存就先返回在时效性之内的缓存，没有或过了时效性请求数据
    QDNetCacheRequestTimestampLoad,
    /// 有缓存就先返回缓存，同步请求数据
    QDNetCacheRequestReturnCacheDataThenLoad,
    /// 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    QDNetCacheRequestReturnCacheDataElseLoad,
    /// 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    QDNetCacheRequestReturnCacheDataDontLoad,
    /// 不返回缓存，也不返回请求，只请求并且缓存
    QDNetCacheRequestReturnNoneLoadAndStoreCache,
    /// 不与用户绑定的缓存 默认缓存3分钟, 退出登录不清理
    QDNetCacheRequestReturnCacheDataNoBindUser,
};

#endif /* EnumMacro_h */
