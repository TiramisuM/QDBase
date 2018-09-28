//
//  NSObject+NetworkParameter.m
//  QDBase
//
//  Created by qiaodata100 on 2018/8/8.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 网络请求拼接用户信息等操作

#import "NSObject+QDNetworkParameter.h"

@implementation NSObject (QDNetworkParameter)

@end

@implementation NSDictionary (QDNetworkParameter)

- (NSDictionary *)networkParamWithUserInfoDict {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict addEntriesFromDictionary:self];
    [paramDict addEntriesFromDictionary:[NSDictionary userInfoDict]];
    
    return paramDict;
}

+ (NSDictionary *)userInfoDict {
    // 处理放在param里面的用户信息等隐私操作
    // token、userId
    NSString *token = @"T2hEbFJqZXF5RTVrVlM2OVczSTFTVU9pZ0xzYUFHaEJxZzQ9";
    NSString *userId = @"WUZaMGdqTkZBRzhUZURVTlJhR2FkNzg9";
    NSDictionary *userInfoDict = @{@"token" : token,
                                   @"userId" : userId
                                   };
    return userInfoDict;
}

@end

@implementation NSString (QDNetworkParameter)

- (NSString *)networkUrlString {
    // 处理拼接在url后面的参数
    // apiVersion logid appVersion osType
    NSString *apiVersion = @"2.2.0";
    NSString *logId = @"cc6e8de71832e62aed9148c1a12e4ffd";
    NSString *appVersion = @"2.2.0";
    NSString *osType = @"ios";
    
    NSString *networkUrlString = [NSString stringWithFormat:@"%@?apiversion=%@&logid=%@&appversion=%@&osType=%@", self, apiVersion, logId, appVersion, osType];
    
    return networkUrlString;
}

@end
