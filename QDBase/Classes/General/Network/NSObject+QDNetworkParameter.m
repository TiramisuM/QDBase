////
////  NSObject+NetworkParameter.m
////  QDBase
////
////  Created by QiaoData on 2018/8/8.
////  Copyright © 2018年 QiaoData. All rights reserved.
///// 网络请求拼接用户信息等操作
//
//#import "NSObject+QDNetworkParameter.h"
//
//@implementation NSDictionary (QDNetworkParameter)
//
//- (NSDictionary *)networkParamWithUserInfoDict {
//    
//    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
//    [paramDict addEntriesFromDictionary:self];
//    [paramDict addEntriesFromDictionary:[NSDictionary userInfoDict]];
//    
//    return paramDict;
//}
//
//@end
//
//@implementation NSString (QDNetworkParameter)
//
//- (NSString *)networkUrlString {
//    // 处理拼接在url后面的参数
//    // apiVersion logid appVersion osType
//    NSString *apiVersion = @"2.2.0";
//    NSString *logId = @"0fa86afe69efa0eca2115f448283bfab";
//    NSString *appVersion = @"2.2.0";
//    NSString *osType = @"ios";
//    
//    NSString *networkUrlString = [NSString stringWithFormat:@"%@?apiversion=%@&logid=%@&appversion=%@&osType=%@", self, apiVersion, logId, appVersion, osType];
//    
//    return networkUrlString;
//}
//
//@end

