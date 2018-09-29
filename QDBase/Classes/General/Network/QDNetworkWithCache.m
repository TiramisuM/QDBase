//
//  QDNetworkWithCache.m
//  QDBase
//
//  Created by qiaodata100 on 2018/8/6.
//  Copyright © 2018年 qiaodata100. All rights reserved.
//

#import "QDNetworkWithCache.h"
#import "YYCache.h"
#import "NSObject+QDNetworkParameter.h"

static  NSString *const     NetCacheUrlString       = BASE_URL;
static  NSString *const     NetCacheTimeCache       = @"NetCommonCacheTimeCache";
static  QDNetworkWithCache  *sharedClient     = nil;
NSUInteger          NetCommonWorkTimeout            = 120;

#define kCommonCacheKey     @"CommonCacheKey"
#define kTimestampKey       @"CommonTimestampKey"
#define kCacheTimeOutKey    @"CacheTimeOutKey"

@interface QDNetworkWithCache ()

@property (nonatomic, strong) YYCache *cache;
@property (nonatomic, assign) NSUInteger networkCacheTimeout;
@property (nonatomic, copy)   void (^uploadProgress)(NSProgress * progress);
@end

@implementation QDNetworkWithCache

#pragma mark - ============== 网络请求 ================
#pragma mark 外部接口
// 返回时效内的缓存
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                 cacheTimeout:(NSUInteger)cacheTimeout
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    return [self requestMethod:QDNetCacheRequestTypeGET urlString:URLString parameters:parameters cacheTimeout:cacheTimeout cachePolicy:QDNetCacheRequestTimestampLoad success:success failure:failure];
}
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    return [self requestMethod:QDNetCacheRequestTypePOST urlString:URLString parameters:parameters cacheTimeout:NetCommonWorkTimeout cachePolicy:cachePolicy success:success failure:failure];
}
// 返回时效内的缓存
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                  cacheTimeout:(NSUInteger)cacheTimeout
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    return [self requestMethod:QDNetCacheRequestTypePOST urlString:URLString parameters:parameters cacheTimeout:cacheTimeout cachePolicy:QDNetCacheRequestTimestampLoad success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                   cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    return [self requestMethod:QDNetCacheRequestTypePOST urlString:URLString parameters:parameters cacheTimeout:NetCommonWorkTimeout cachePolicy:cachePolicy success:success failure:failure];
}
// 带进度条请求 忽略缓存
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(ProgressBlock)uploadProgress
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    [QDNetworkWithCache sharedNetwork].uploadProgress = uploadProgress;
    
    return [self requestMethod:QDNetCacheRequestTypePOST urlString:URLString parameters:parameters cacheTimeout:NetCommonWorkTimeout cachePolicy:QDNetCacheRequestReloadIgnoringCacheData success:success failure:failure];
}


+ (NSURLSessionDataTask *)requestWithType:(QDNetCacheRequestType)requestType
                                urlString:(NSString *)URLString
                               parameters:(id)parameters
                             cacheTimeout:(NSUInteger)cacheTimeout
                              cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                                 progress:(ProgressBlock)progress
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure {
    return [self requestMethod:requestType urlString:URLString parameters:parameters cacheTimeout:cacheTimeout cachePolicy:cachePolicy success:success failure:failure];
}

#pragma mark 网络请求方法实现
+ (NSURLSessionDataTask *)requestMethod:(QDNetCacheRequestType)type
                              urlString:(NSString *)urlString
                             parameters:(id)parameters
                           cacheTimeout:(NSUInteger)cacheTimeout
                            cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure
{
    
    /// 如果参数存在，则将用户信息拼接上去，如果不存在，则直接返回用户信息的参数
    parameters = (parameters && [parameters isKindOfClass:[NSDictionary class]]) ? [parameters networkParamWithUserInfoDict] : [NSDictionary userInfoDict];
    urlString = [urlString networkUrlString];
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        
    }
    
    NSString *cacheKey = urlString;
    if (parameters)
    {
        if (![NSJSONSerialization isValidJSONObject:parameters])
        {
            if(failure) failure(nil);
            return nil;//参数不是json类型
        }
        
        if ([parameters isKindOfClass:[NSDictionary class]])
        {
            
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
            
            NSString *sign = @"";
            NSArray *parametersKeys = [[(NSMutableDictionary *)parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSArray *sortArray = @[@"appversion",@"apiversion",@"osType",@"osVersion",@"osName",@"deviceId",@"imei",@"idfa",@"brand"];
            
            for (NSString *key in parametersKeys)
            {
                if (![sortArray containsObject:key])
                {
                    sign = [sign stringByAppendingString:judgeString(parameters[key])];
                }
                
                cacheKey = [cacheKey stringByAppendingString:judgeString(parameters[key])];
            }
            
            sign = [sign stringByAppendingString:@"qiaodata"];
            parameters[@"sign"] = [[sign MD5String] MD5String];
            
        }else{
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            cacheKey = [urlString stringByAppendingString:paramStr];
        }
    }
    
    cacheKey = [cacheKey MD5String];
    
    // 打印请求参数
    [self printRequestWithUrlString:urlString parameters:parameters];
    
    if (cacheTimeout > 0) {
        [QDNetworkWithCache sharedNetwork].networkCacheTimeout = cacheTimeout;
    } else {
        // 如果缓存时间为0, 默认为不缓存数据,直接请求
        cachePolicy = QDNetCacheRequestReloadIgnoringCacheData;
    }
    NSDictionary *cacheDict = (NSDictionary *)[[QDNetworkWithCache sharedNetwork].cache objectForKey:cacheKey];
    NSDate *timestamp       = [cacheDict objectForKey:kTimestampKey];
    NSDictionary *object    = [cacheDict objectForKey:kCommonCacheKey];
    NSInteger catchTimeOut  = [[cacheDict objectForKey:kCacheTimeOutKey] integerValue];
    switch (cachePolicy)
    {
        case QDNetCacheRequestTimestampLoad: {//返回时效内的缓存缓存
            if (object) {
                if (timestamp && ![QDNetworkWithCache ifTimeOut:timestamp catchTimeOut:catchTimeOut]) {
                    if(success) success(object, YES);
                    return nil;
                } else {
                    [[QDNetworkWithCache sharedNetwork].cache removeObjectForKey:cacheKey];
                }
            }
            break;
        }
        case QDNetCacheRequestReturnCacheDataThenLoad: {//先返回缓存，同时请求
            if (object)
            {
                if(success) success(object, YES);
            }
            break;
        }
        case QDNetCacheRequestReloadIgnoringCacheData: {//忽略本地缓存直接请求
            //不做处理，直接请求
            break;
        }
        case QDNetCacheRequestReturnCacheDataElseLoad: {//有缓存就返回缓存，没有就请求
            if (object)
            {//有缓存
                if(success) success(object, YES);
                return nil;
            }
            break;
        }
        case QDNetCacheRequestReturnCacheDataDontLoad: {//有缓存就返回缓存,从不请求（用于没有网络）
            if (object)
            {//有缓存
                if(success) success(object, YES);
                
            }
            return nil;//退出从不请求
        }
        case QDNetCacheRequestReturnNoneLoadAndStoreCache: {//不返回缓存，也不返回请求，只请求并且缓存
        }
        default: {
            break;
        }
    }
    return [self requestMethod:type urlString:urlString parameters:parameters cacheKey:cacheKey cachePolicy:cachePolicy success:success failure:failure];
}

+ (NSURLSessionDataTask *)requestMethod:(QDNetCacheRequestType)type
                              urlString:(NSString *)urlString
                             parameters:(id)parameters
                               cacheKey:(NSString *)cacheKey
                            cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    
    switch (type)
    {
        case QDNetCacheRequestTypeGET:
        {
            
            return [[QDNetworkWithCache sharedNetwork] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
                    {
                        if ([QDNetworkWithCache sharedNetwork].uploadProgress) {
                            [QDNetworkWithCache sharedNetwork].uploadProgress(downloadProgress);
                        }
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                    {
                        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;
                        
                        responseObject = [self responseValidWithObject:responseObject successWithCache:success failure:failure];
                        if (!responseObject) return;
                        // 2. 处理返回数据里面的错误 异地登录等情况
                        [self handleResponseDataError:responseObject];
                        
                        // 3. 缓存当前数据并返回
                        if (cachePolicy != QDNetCacheRequestReturnNoneLoadAndStoreCache) {
                            
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [[QDNetworkWithCache sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
                            });
                            if(success) success(responseObject, NO);
                        } else {
                            [[QDNetworkWithCache sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
                        }
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                    {
                        NSLog(@"\n返回错误: %@",error);
                        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;
                        if (failure) failure(error);
                    }];
            
            break;
        }
        case QDNetCacheRequestTypePOST:
        {
            return [[QDNetworkWithCache sharedNetwork] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress)
                    {
                        if ([QDNetworkWithCache sharedNetwork].uploadProgress) {
                            [QDNetworkWithCache sharedNetwork].uploadProgress(uploadProgress);
                        }
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                    {
                        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;

                        responseObject = [self responseValidWithObject:responseObject successWithCache:success failure:failure];
                        if (!responseObject) return;
                        // 2. 处理返回数据里面的错误
                        [self handleResponseDataError:responseObject];
                        
                        // 3. 缓存当前数据并返回
                        if (cachePolicy != QDNetCacheRequestReturnNoneLoadAndStoreCache) {
                            
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [[QDNetworkWithCache sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
                            });
                            if(success) success(responseObject, NO);
                        } else {
                            [[QDNetworkWithCache sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                    {
                        
                        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;
                        if (failure) failure(error);
                    }];
            
            break;
        }
        default:
            break;
    }
    
}

+ (void)handleResponseDataError:(id)responseData {
    NSString *errorCode = judgeString(responseData[@"error"]);
    if (errorCode.integerValue == -3 || errorCode.integerValue == -1) {
        // 异地登陆
    }
}


#pragma mark - ============== 图片上传 ================
#pragma mark 接口
+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                       imageData:(NSData *)imageData
                                       imageName:(NSString *)imageName
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    return [self postImageWithURLString:URLString parameters:parameters imageDataArr:@[imageData] imageNameArr:@[imageName] progress:nil success:success failure:failure];
}

+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    return [self postImageWithURLString:URLString parameters:parameters imageDataArr:imageDataArr imageNameArr:imageNameArr progress:nil success:success failure:failure];
}

#pragma mark 方法实现
+ (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
                                        progress:(ProgressBlock)progress
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    
    parameters = (parameters && [parameters isKindOfClass:[NSDictionary class]]) ? [parameters networkParamWithUserInfoDict] : [NSDictionary userInfoDict];
    NSString *tempUrlStr = [URLString networkUrlString];
    [QDNetworkWithCache sharedNetwork].uploadProgress = progress;
    
    /// 处理imageName与imageData个数不相等问题
    NSMutableArray *imageNames = [NSMutableArray arrayWithArray:imageNameArr];
    NSInteger imageNameCount = imageNameArr.count;
    NSInteger imageDataCount = imageDataArr.count;
    // 如果imageNameArray个数大于imageDataArray的个数，将imageNameArray多余部分删除
    if (imageNameCount > imageDataCount) {
        [imageNames removeObjectsInRange:NSMakeRange(imageDataCount, imageNameCount - imageDataCount)];
        
    } else if (imageNameCount < imageDataCount) {
        
        // 如果imageNameArray个数大于imageDataArray的个数，在imageNameArray中拼接上少的部分名字
        for (NSInteger i = 0; i < imageDataCount - imageNameCount; i++) {
            [imageNames addObject:[NSString stringWithFormat:@"noNameImage%ld", (i + 1)]];
        }
    }
    
    return [[QDNetworkWithCache sharedNetwork] POST:tempUrlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < imageDataArr.count; i++) {
            NSString *imageName = imageNames[i];
            NSData *imageData = imageDataArr[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"application/octet-stream"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if ([QDNetworkWithCache sharedNetwork].uploadProgress) {
            [QDNetworkWithCache sharedNetwork].uploadProgress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;
        responseObject = [self responseValidWithObject:responseObject successWithCache:success failure:failure];
        if (responseObject) {
            if(success) success(responseObject, NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [QDNetworkWithCache sharedNetwork].uploadProgress = nil;
        if(failure) failure(error);
    }];
}

#pragma mark - ============== 上传文件 ================
+ (NSURLSessionUploadTask *)postFileWithPath:(NSString *)URLString
                                  parameters:(id)parameters
                              uploadFilePath:(NSString *)uploadFilePath
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *fileUrl = [NSURL fileURLWithPath:uploadFilePath];
    NSURLSessionUploadTask *uploadTask = [[QDNetworkWithCache sharedNetwork] uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                          {
                                              if (error) {
                                                  if(failure) failure(error);
                                              } else {
                                                  if(success) success(responseObject, NO);
                                              }
                                          }];
    [uploadTask resume];
    return uploadTask;
}

#pragma mark - ============== 私有方法 ================
#pragma mark 请求回来之后,校验返回值类型
+ (id)responseValidWithObject:(id)responseObject successWithCache:(SuccessBlock)success failure:(FailureBlock)failure {
    // 1. 判断当前返回的数据的类型
    if ([responseObject isKindOfClass:[NSData class]]) {
        
        /// 将data类型处理成JSON字符串
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (response) {
            responseObject = response;
        }else{
            responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"\n服务器返回错误: %@",responseObject);
            if (failure) failure(nil);
            return nil;
        }
        
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) { /// NSDictionary类型则不做任何处理
        
        // 判断是否有值，没有的话直接返回failure
        if (!responseObject) {
            NSLog(@"服务器未返回任何数据");
            if (failure) failure(nil);
            return nil;
        }
        
    } else { /// 其他类型 则直接返回错误
        NSLog(@"\n返回结果: %@",[responseObject mj_JSONString]);
        if (success) success(nil, NO);
        return nil;
    }
    return responseObject;
}

#pragma mark 存入缓存的方法
- (void)saveCacheWithResponseObject:(id)responseObject forKey:(NSString *)cacheKey {
    
    NSMutableDictionary *cacheDict = [NSMutableDictionary new];
    [cacheDict setObject:responseObject forKey:kCommonCacheKey];
    [cacheDict setObject:[NSDate date] forKey:kTimestampKey];
    [cacheDict setObject:@([QDNetworkWithCache sharedNetwork].networkCacheTimeout) forKey:kCacheTimeOutKey];
    [self.cache setObject:cacheDict forKey:cacheKey];//YYCache 已经做了responseObject为空处理
}

#pragma mark 超时校验
+ (BOOL)ifTimeOut:(NSDate *)date catchTimeOut:(NSInteger)timeOut
{
    NSDate *hisDate = (NSDate *)date;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSinceDate:hisDate];
    NSLog(@"timeinterval:%f",time);
    return (time > timeOut);
}

#pragma mark 打印请求参数
+ (void)printRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    
    NSArray *keyArray = [parameters allKeys];
    NSMutableString *absoluteUrl = [NSMutableString stringWithFormat:@"%@%@", BASE_URL, urlString];
    for (NSInteger i = 0; i < keyArray.count; i++) {
        NSString *keyString = keyArray[i];
        NSString *appendString = [NSString stringWithFormat:@"&%@=%@", keyString, parameters[keyString]];
        [absoluteUrl appendString:appendString];
    }
    NSLog(@"\n请求参数：\n%@", absoluteUrl);
}


#pragma mark - ============== 单例 ================
+ (instancetype)sharedNetwork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:NetCacheUrlString]];
        // 相应的默认形式是http格式的,请求默认也是http'格式的,都是普通的二进制
        sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 证书验证
        //        sharedClient.securityPolicy = [self customSecurityPolicy];
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
        sharedClient.requestSerializer.timeoutInterval = NetCommonWorkTimeout;
    });
    return sharedClient;
}

#pragma mark https证书验证
+ (AFSecurityPolicy *)customSecurityPolicy
{
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式 (AFSSLPinningModeCertificate是证书所有字段都一样才通过认证，AFSSLPinningModePublicKey只认证公钥那一段，AFSSLPinningModeCertificate更安全。但是单向认证不能防止“中间人攻击”)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // validatesDomainName 是否需要验证域名，默认为YES；
    // 假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 设置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = (NSSet *)@[certData];
    return securityPolicy;
}



#pragma mark - ============== 缓存 ================
+ (void)clearCache {
    [[QDCacheSingleton shareInstance] clearCache];
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [QDCacheSingleton shareInstance].cache;
    }
    return _cache;
}
@end

