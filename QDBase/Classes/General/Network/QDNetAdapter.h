//
//  QDNetAdapter.h
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  QDNetAdapterProtocol：请求适配器协议    QDNetAdapter：请求适配器父类

#import <Foundation/Foundation.h>
#import "QDNetWork.h"

@protocol QDNetAdapterProtocol<NSObject>

/**
 请求URL （必须实现）

 @return 请求URL
 */
- (NSString *)url;

@optional

/**
 请求参数：默认nil

 @return 请求参数
 */
- (NSDictionary *)parameter;

/**
 缓存超时时间：默认0

 @return 缓存超时时间
 */
- (NSUInteger)cacheTimeout;

/**
 请求超时时间：默认0

 @return 请求超时时间
 */
- (NSUInteger)netTimeout;

/**
 请求方式：默认GET

 @return 请求方式
 */
- (QDNetCacheRequestType)requestMethod;

/**
 请求头：默认nil

 @return 请求头
 */
- (NSDictionary *)requestHeader;

/**
 缓存策略：默认QDNetCacheRequestTimestampLoad 有缓存就先返回在时效性之内的缓存，没有或过了时效性请求数据

 @return 缓存策略
 */
- (QDNetCacheRequestPolicy)cachePolicy;

@end


@interface QDNetAdapter : NSObject

/**
 此处属性用于初始化默认的值
 子类修改方式有两种：
 1. 实现协议中的方法（属性的get方法），返回固定的值
 2. 直接赋值，子类不需要实现协议中的方法，可用于参数的传入
 推荐：固定的，单一的值，通过方法一实现，动态的值，通过方式二实现
 */
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, assign) NSUInteger cacheTimeout;
@property (nonatomic, assign) NSUInteger netTimeout;
@property (nonatomic, assign) NSDictionary *requestHeader;
@property (nonatomic, assign) QDNetCacheRequestType requestMethod;
@property (nonatomic, assign) QDNetCacheRequestPolicy cachePolicy;

// 返回数据通用属性：错误码
@property (nonatomic, copy) NSString *errorCode;

// 返回数据通用属性：描述信息
@property (nonatomic, copy) NSString *msg;

/**
 发起请求：单个数据模型请求

 @param success 成功回调：返回解析好的数据模型
 @param failure 失败回调：返回错误信息
 */
- (void)requestSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 发起请求：List数据模型请求

 @param success 成功回调：返回解析好的数据模型数组
 @param failure 失败回调：返回错误信息
 */
- (void)requestArraySuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
