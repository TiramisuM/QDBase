//
//  QDNetWorkAgent.h
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  网络请求工具类


#import <AFNetworking/AFNetworking.h>

/// 请求类型 GET 和POST
typedef NS_ENUM(NSUInteger, QDNetCacheRequestType)
{
    /// GET请求
    QDNetCacheRequestTypeGET = 0,
    /// POST请求
    QDNetCacheRequestTypePOST,
};

/// 成功回调
typedef void(^SuccessBlock)(id result, BOOL isCache);
/// 失败回调
typedef void(^FailureBlock)(NSError *error);
/// 进度回调
typedef void(^ProgressBlock)(NSProgress *progress);


@interface QDNetWorkAgent : AFHTTPSessionManager

@property (nonatomic, assign) NSUInteger   cacheTimeoutInterval;

+ (instancetype)sharedNetwork;

- (NSURLSessionDataTask *)requestMethod:(QDNetCacheRequestType)type
                              urlString:(NSString *)urlString
                             parameters:(id)parameters
                           cacheTimeout:(NSUInteger)cacheTimeout
                             netTimeout:(NSUInteger)netTimeout
                          requestHeader:(NSDictionary<NSString *,NSString*> *)requestHeader
                            cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;


- (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                       imageData:(NSData *)imageData
                                       imageName:(NSString *)imageName
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;

- (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
                                        progress:(ProgressBlock)progress
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;

@end

