//
//  QDNetWork.m
//  QDCommentProject
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  全局网络配置工具类

#import "QDNetWork.h"

/**
 全局网络配置项
 */
typedef struct {
    
    NSUInteger netTimeoutInterval;
    NSUInteger cacheTimeoutInterval;
    QDNetRequestType requestType;
    CFTypeRef requestHeader;
} QDNetGlobleConfig;

/**
 全局网络管理类
 */
static QDNetWork *sharedManger = nil;

@implementation QDNetWork

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化默认全局网络配置
        QDNetGlobleConfig config = {
            config.netTimeoutInterval = 60,
            config.cacheTimeoutInterval = 120,
            config.requestType = QDNetRequestTypeGET,
            config.requestHeader = (__bridge_retained CFTypeRef)(@{})
        };
        //配置网络管理类
        sharedManger = [[QDNetWork alloc] initWithConfig:config];
    });
    return sharedManger;
}

/**
 初始化工具类

 @param config 全局配置项
 @return 工具类实例
 */
- (instancetype)initWithConfig:(QDNetGlobleConfig)config {
    self = [super init];
    if (self != nil) {
        _netAgent = [QDNetWorkAgent sharedNetwork];
        _netAgent.requestSerializer.timeoutInterval = config.netTimeoutInterval;
        _netAgent.cacheTimeoutInterval = config.cacheTimeoutInterval;
        NSDictionary<NSString *,NSString *> *dic = (__bridge_transfer NSDictionary<NSString *,NSString *> *)(config.requestHeader);
        if (dic && dic.allKeys.count > 0) {
            __weak QDNetWork *wSelf = self;
            [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [wSelf.netAgent.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    return self;
}

+ (NSDictionary *)netUserInfoDict {
    // 处理放在param里面的用户信息等隐私操作
    // token、userId
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    userInfoDict[@"token"] = @"";
    userInfoDict[@"userId"] = @"";
    userInfoDict[@"logId"] = [QDDeviceTool getLogId];
    return [userInfoDict copy];
}

+ (NSDictionary *)netPublicParameter{
    return @{
             @"apiVersion" : API_VERSION,
             @"appVersion" : [QDDeviceTool getAppVersion],
             @"osType" : @"ios",
             };
}

@end

