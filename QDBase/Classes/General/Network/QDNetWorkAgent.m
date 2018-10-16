//
//  QDNetWorkAgent.m
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "QDNetWorkAgent.h"
#import "YYCache.h"

#define kCommonCacheKey     @"CommonCacheKey"
#define kTimestampKey       @"CommonTimestampKey"
#define kCacheTimeOutKey    @"CacheTimeOutKey"

static  NSString *const NetCacheUrlString = BASE_URL;
static  QDNetWorkAgent *sharedClient      = nil;

@interface QDNetWorkAgent ()

@property (nonatomic, strong) YYCache *cache;
@property (nonatomic, copy)   void (^uploadProgress)(NSProgress * progress);

@end

@implementation QDNetWorkAgent

const NSString *QDNetRequestTypeStringMap[] = {
    [QDNetRequestTypeGET] = @"GET",
    [QDNetRequestTypePOST] = @"POST"
};

- (NSURLSessionDataTask *)dataTaskMethod:(QDNetRequestType)type
                           urlString:(NSString *)urlString
                          parameters:(id)parameters
                            cacheKey:(NSString *)cacheKey
                         cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                          netTimeout:(NSUInteger)netTimeout
                       requestHeader:(NSDictionary<NSString *,NSString*> *)requestHeader
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    
    // 网络请求的进度block
    void (^networkProgressBlock)(NSProgress * _Nonnull) =  ^(NSProgress * _Nonnull downloadProgress) {
        if ([QDNetWorkAgent sharedNetwork].uploadProgress) {
            [QDNetWorkAgent sharedNetwork].uploadProgress(downloadProgress);
        }
    };
    
    // 网络请求成功的block
    void (^netWorkSuccessBlock)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [QDNetWorkAgent sharedNetwork].uploadProgress = nil;
        
        responseObject = [self responseValidWithObject:responseObject successWithCache:success failure:failure];
        if (!responseObject) return;
        // 2. 处理返回数据里面的错误 异地登录等情况
        [self handleResponseDataError:responseObject];
        
        // 3. 缓存当前数据并返回
        if (cachePolicy != QDNetCacheRequestReturnNoneLoadAndStoreCache) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[QDNetWorkAgent sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
            });
            if(success) success(responseObject, NO);
        } else {
            [[QDNetWorkAgent sharedNetwork] saveCacheWithResponseObject:responseObject forKey:cacheKey];
        }
    };
    
    // 网络请求失败的block
    void (^networkFailureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n返回错误: %@",error);
        [QDNetWorkAgent sharedNetwork].uploadProgress = nil;
        if (failure) failure(error);
    };
    
    // 配置request，发起请求
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:(NSString *)QDNetRequestTypeStringMap[type] URLString:[[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                networkFailureBlock(nil, serializationError);
            });
        }
        return nil;
    }
    
    if (netTimeout > 0) {
        request.timeoutInterval = netTimeout;
    }
    
    if (requestHeader && requestHeader.allKeys.count > 0) {
        [requestHeader enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:networkProgressBlock
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               networkFailureBlock(dataTask, error);
                           } else {
                               netWorkSuccessBlock(dataTask, responseObject);
                           }
                       }];
    [dataTask resume];
    return dataTask;
}


#pragma mark 网络请求方法实现
- (NSURLSessionDataTask *)requestMethod:(QDNetRequestType)type
                              urlString:(NSString *)urlString
                             parameters:(id)parameters
                           cacheTimeout:(NSUInteger)cacheTimeout
                             netTimeout:(NSUInteger)netTimeout
                          requestHeader:(NSDictionary *)requestHeader
                            cachePolicy:(QDNetCacheRequestPolicy)cachePolicy
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        
    }
    
    NSString *cacheKey = urlString;
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) {
            if(failure) failure(nil);
            return nil;//参数不是json类型
        }
        
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
            
            NSString *sign = @"";
            NSArray *parametersKeys = [[(NSMutableDictionary *)parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSArray *sortArray = @[@"appversion", @"apiversion", @"osType", @"osVersion", @"osName", @"deviceId", @"imei", @"idfa", @"brand"];
            
            for (NSString *key in parametersKeys) {
                if (![sortArray containsObject:key]) {
                    sign = [sign stringByAppendingString:judgeString(parameters[key])];
                }
                
                cacheKey = [cacheKey stringByAppendingString:judgeString(parameters[key])];
            }
            
            sign = [sign stringByAppendingString:@"qiaodata"];
            parameters[@"sign"] = [[sign MD5String] MD5String];
            
        } else {
            NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            cacheKey = [urlString stringByAppendingString:paramStr];
        }
    }
    
    cacheKey = [cacheKey MD5String];
    
    // 打印请求参数
    [self printRequestWithUrlString:urlString parameters:parameters];
    
    if (cacheTimeout > 0) {
        [QDNetWorkAgent sharedNetwork].cacheTimeoutInterval = cacheTimeout;
    } else {
        // 如果缓存时间为0, 默认为不缓存数据,直接请求
        cachePolicy = QDNetCacheRequestReloadIgnoringCacheData;
    }
    NSDictionary *cacheDict = (NSDictionary *)[[QDNetWorkAgent sharedNetwork].cache objectForKey:cacheKey];
    NSDate *timestamp       = [cacheDict objectForKey:kTimestampKey];
    NSDictionary *object    = [cacheDict objectForKey:kCommonCacheKey];
    NSInteger cacheTimeOut  = [[cacheDict objectForKey:kCacheTimeOutKey] integerValue];
    
    switch (cachePolicy) {
            
        case QDNetCacheRequestTimestampLoad: {//返回时效内的缓存缓存
            if (object) {
                if (timestamp && ![QDNetWorkAgent ifTimeOut:timestamp cacheTimeOut:cacheTimeOut]) {
                    if(success) success(object, YES);
                    return nil;
                } else {
                    [[QDNetWorkAgent sharedNetwork].cache removeObjectForKey:cacheKey];
                }
            }
            break;
        }
        case QDNetCacheRequestReturnCacheDataThenLoad: {//先返回缓存，同时请求
            if (object) {
                if(success) success(object, YES);
            }
            break;
        }
        case QDNetCacheRequestReloadIgnoringCacheData: {//忽略本地缓存直接请求
            //不做处理，直接请求
            break;
        }
        case QDNetCacheRequestReturnCacheDataElseLoad: {//有缓存就返回缓存，没有就请求
            if (object) {//有缓存
                if(success) success(object, YES);
                return nil;
            }
            break;
        }
        case QDNetCacheRequestReturnCacheDataDontLoad: {//有缓存就返回缓存,从不请求（用于没有网络）
            if (object) {//有缓存
                if(success) success(object, YES);
            }
            return nil;//退出从不请求
        }
        case QDNetCacheRequestReturnNoneLoadAndStoreCache: {//不返回缓存，也不返回请求，只请求并且缓存
            break;
        }
        default: {
            break;
        }
    }
    
    return [self dataTaskMethod:type urlString:urlString parameters:parameters cacheKey:cacheKey cachePolicy:cachePolicy netTimeout:netTimeout requestHeader:requestHeader success:success failure:failure];
}

- (void)handleResponseDataError:(id)responseData {
    NSString *errorCode = judgeString(responseData[@"error"]);
    if (errorCode.integerValue == -3 || errorCode.integerValue == -1) {
        // 异地登陆
    }
}


#pragma mark - ============== 图片上传 ================
- (NSURLSessionDataTask *)postImageWithURLString:(NSString *)URLString
                                      parameters:(id)parameters
                                    imageDataArr:(NSArray<NSData *> *)imageDataArr
                                    imageNameArr:(NSArray<NSString *> *)imageNameArr
                                        progress:(ProgressBlock)progress
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure {
    
    [QDNetWorkAgent sharedNetwork].uploadProgress = progress;
    
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
    
    return [[QDNetWorkAgent sharedNetwork] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
        
        if ([QDNetWorkAgent sharedNetwork].uploadProgress) {
            [QDNetWorkAgent sharedNetwork].uploadProgress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [QDNetWorkAgent sharedNetwork].uploadProgress = nil;
        responseObject = [self responseValidWithObject:responseObject successWithCache:success failure:failure];
        if (responseObject) {
            if(success) success(responseObject, NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [QDNetWorkAgent sharedNetwork].uploadProgress = nil;
        if(failure) failure(error);
    }];
}

#pragma mark - ============== 上传文件 ================
+ (NSURLSessionUploadTask *)postFileWithPath:(NSString *)URLString
                                  parameters:(id)parameters
                              uploadFilePath:(NSString *)uploadFilePath
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure {
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *fileUrl = [NSURL fileURLWithPath:uploadFilePath];
    NSURLSessionUploadTask *uploadTask = [[QDNetWorkAgent sharedNetwork] uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
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
- (id)responseValidWithObject:(id)responseObject successWithCache:(SuccessBlock)success failure:(FailureBlock)failure {
    // 1. 判断当前返回的数据的类型
    if ([responseObject isKindOfClass:[NSData class]]) {
        
        /// 将data类型处理成JSON字符串
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (response) {
            responseObject = response;
        } else {
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
    [cacheDict setObject:@([QDNetWorkAgent sharedNetwork].cacheTimeoutInterval) forKey:kCacheTimeOutKey];
    [self.cache setObject:cacheDict forKey:cacheKey];//YYCache 已经做了responseObject为空处理
}

#pragma mark 超时校验
+ (BOOL)ifTimeOut:(NSDate *)date cacheTimeOut:(NSInteger)timeOut {
    NSDate *hisDate = (NSDate *)date;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSinceDate:hisDate];
    NSLog(@"timeinterval:%f",time);
    return (time > timeOut);
}

#pragma mark 打印请求参数
- (void)printRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    
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
+ (instancetype)sharedNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:NetCacheUrlString]];
        sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 证书验证
//        sharedClient.securityPolicy = [self customSecurityPolicy];
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    });
    return sharedClient;
}

#pragma mark https证书验证
+ (AFSecurityPolicy *)customSecurityPolicy {
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
    [[QDCacheSingleton shareInstance] clearNetworkCache];
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [QDCacheSingleton shareInstance].networkCache;
    }
    return _cache;
}


@end
