//
//  NSObject+NetworkParameter.h
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 网络请求拼接用户信息等操作

#import <Foundation/Foundation.h>

/// 网络请求拼接在网络请求体的内容
@interface NSDictionary (QDNetworkParameter)
/**
 拼接在网络请求体的内容
 
 @return @{@"token" : token, @"userId" : userId}
 */
- (NSDictionary *)networkParamWithUserInfoDict;
/**
 用于网络请求

 @return @{@"token" : token, @"userId" : userId}
 */
+ (NSDictionary *)userInfoDict;

@end

/// 网络请求拼接在url后面的参数
@interface NSString (QDNetworkParameter)
/**
 处理拼接在url后面的参数 参数apiversion logid appversion
 
 @return NSString
 */
- (NSString *)networkUrlString;

@end
