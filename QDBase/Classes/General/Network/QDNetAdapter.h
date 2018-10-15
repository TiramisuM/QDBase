//
//  QDNetAdapter.h
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
///  QDNetAdapterProtocol：请求适配器协议    QDNetAdapter：请求适配器父类

#import <Foundation/Foundation.h>
#import "QDNetWork.h"

@interface QDNetAdapter : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *modelClass;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, assign) NSUInteger cacheTimeout;
@property (nonatomic, assign) NSUInteger netTimeout;
@property (nonatomic, assign) NSDictionary *requestHeader;
@property (nonatomic, assign) QDNetRequestType requestMethod;
@property (nonatomic, assign) QDNetCacheRequestPolicy cachePolicy;

/// 返回数据通用属性：错误码
@property (nonatomic, copy) NSString *errorCode;

/// 返回数据通用属性：描述信息
@property (nonatomic, copy) NSString *msg;

/**
 发起请求

 @param success 成功回调：返回解析好的数据模型
 @param failure 失败回调：返回错误信息
 */
- (NSURLSessionDataTask *)requestSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
