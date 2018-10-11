////
////  QDNetworkWithCache.h
////  QDBase
////
////  Created by QiaoData on 2018/8/6.
////  Copyright © 2018年 QiaoData. All rights reserved.
/////  网络请求类
//
//#import <AFNetworking/AFNetworking.h>
//
/////// 请求类型 GET 和POST
////typedef NS_ENUM(NSUInteger, QDNetCacheRequestType)
////{
////    /// GET请求
////    QDNetCacheRequestTypeGET = 0,
////    /// POST请求
////    QDNetCacheRequestTypePOST,
////};
//
///// 成功回调
//typedef void(^SuccessBlock)(id result, BOOL isCache);
///// 失败回调
//typedef void(^FailureBlock)(NSError *error);
///// 进度回调
//typedef void(^ProgressBlock)(NSProgress *progress);
//
///// 网络请求工具类
//@interface QDNetworkWithCache : AFHTTPSessionManager
//
//@property (nonatomic, assign) NSUInteger networkCacheTimeout;
//@property (nonatomic, strong) NSDictionary *HTTPRequestHeaders;
//
///**
// QDNetCacheRequestPolicy 默认 QDNetCacheRequestTimestampLoad 的缓存方式 (默认缓存120s)
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                      success:(SuccessBlock)success
//                      failure:(FailureBlock)failure;
//
///**
// QDNetCacheRequestPolicy 默认 QDNetCacheRequestTimestampLoad 的缓存方式 自定义缓存时效
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param cacheTimeout 缓存时效
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                 cacheTimeout:(NSUInteger)cacheTimeout
//                      success:(SuccessBlock)success
//                      failure:(FailureBlock)failure;
//
///**
// QDNetCacheRequestPolicy 的缓存方式 (默认缓存120s)
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param cachePolicy  缓存类型 QDNetCacheRequestPolicy
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                  cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
//                      success:(SuccessBlock)success
//                      failure:(FailureBlock)failure;
//
///**
// QDNetCacheRequestPolicy 默认 QDNetCacheRequestTimestampLoad 的缓存方式 (默认缓存120s)
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)POST:(NSString *)URLString
//                    parameters:(id)parameters
//                       success:(SuccessBlock)success
//                       failure:(FailureBlock)failure;
//
///**
// QDNetCacheRequestPolicy 默认 QDNetCacheRequestTimestampLoad 的缓存方式  自定义缓存时效
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param cacheTimeout 缓存时效
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)POST:(NSString *)URLString
//                    parameters:(id)parameters
//                  cacheTimeout:(NSUInteger)cacheTimeout
//                       success:(SuccessBlock)success
//                       failure:(FailureBlock)failure;
//
///**
// QDNetCacheRequestPolicy 的缓存方式(默认缓存180s)
// 
// @param URLString    请求url
// @param parameters   请求参数
// @param cachePolicy  缓存类型 QDNetCacheRequestPolicy
// @param success      请求成功回调 SuccessBlock
// @param failure      请求失败回调 FailureBlock
// @return             NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)POST:(NSString *)URLString
//                    parameters:(id)parameters
//                   cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
//                       success:(SuccessBlock)success
//                       failure:(FailureBlock)failure;
//
///**
// 带上传进度的POST请求
// @discussion QDNetCacheRequestPolicy 默认 QDNetCacheRequestReloadIgnoringCacheData 缓存机制
// 
// @param URLString          请求url
// @param parameters         请求参数
// @param uploadProgress     进度条
// @param success            请求成功回调 SuccessBlock
// @param failure            请求失败回调 FailureBlock
// @return                   NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)POST:(NSString *)URLString
//                    parameters:(id)parameters
//                      progress:(ProgressBlock)uploadProgress
//                       success:(SuccessBlock)success
//                       failure:(FailureBlock)failure;
//
//
///**
// 带上传进度的请求
// 
// @param requestType        请求类型 QDNetCacheRequestType
// @param URLString          请求url
// @param parameters         请求参数
// @param cacheTimeout       缓存时效
// @param cachePolicy        缓存策略 QDNetCacheRequestPolicy
// @param progress           进度条 ProgressBlock
// @param success            请求成功回调 SuccessBlock
// @param failure            请求失败回调 FailureBlock
// @return                   NSURLSessionDataTask
// 
// */
//+ (NSURLSessionDataTask *)requestWithType:(QDNetCacheRequestType)requestType
//                                urlString:(NSString *)URLString
//                               parameters:(id)parameters
//                             cacheTimeout:(NSUInteger)cacheTimeout
//                              cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
//                                 progress:(ProgressBlock)progress
//                                  success:(SuccessBlock)success
//                                  failure:(FailureBlock)failure;
///**
// 带图片上传
// 
// @param URLString   url
// @param parameters  请求参数
// @param imageData   图片
// @param imageName   图片名
// @param success     请求成功回调 SuccessBlock
// @param failure     请求失败回调 FailureBlock
// @return NSURLSessionDataTask
// */
//+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
//                                      parameters:(id)parameters
//                                       imageData:(NSData *)imageData
//                                       imageName:(NSString *)imageName
//                                         success:(SuccessBlock)success
//                                         failure:(FailureBlock)failure;
//
///**
// 带图片上传(多张图片)
// 
// @param URLString     url
// @param parameters    请求参数
// @param imageDataArr  图片数据数组
// @param imageNameArr  图片名称数组
// @param success       请求成功回调 SuccessBlock
// @param failure       请求失败回调 FailureBlock
// @return NSURLSessionDataTask
// */
//+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
//                                      parameters:(id)parameters
//                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
//                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
//                                         success:(SuccessBlock)success
//                                         failure:(FailureBlock)failure;
//
///**
// 带图片、进度条上传(多张图片)
// @param URLString     url
// @param parameters    请求参数
// @param imageDataArr  图片数据数组
// @param imageNameArr  图片名称数组
// @param progress      上传进度    ProgressBlock
// @param success       请求成功回调 SuccessBlock
// @param failure       请求失败回调 FailureBlock
// @return NSURLSessionDataTask
// */
//+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
//                                      parameters:(id)parameters
//                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
//                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
//                                        progress:(ProgressBlock)progress
//                                         success:(SuccessBlock)success
//                                         failure:(FailureBlock)failure;
//
///**
// 上传文件
// @param URLString      url
// @param parameters     请求参数
// @param uploadFilePath 需要上传的文件路径
// @param success       请求成功回调 SuccessBlock
// @param failure       请求失败回调 FailureBlock
// @return NSURLSessionDataTask
// */
//+ (NSURLSessionUploadTask *)postFileWithPath:(NSString *)URLString
//                                  parameters:(id)parameters
//                              uploadFilePath:(NSString *)uploadFilePath
//                                     success:(SuccessBlock)success
//                                     failure:(FailureBlock)failure;
//
///**
// 清除缓存
// */
//+ (void)clearCache;
//
//
//@end

