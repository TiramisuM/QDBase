//
//  QDNetAdapter.m
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  请求适配器父类

#import "QDNetAdapter.h"

@implementation QDNetAdapter

- (NSURLSessionDataTask *)requestSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    return [[QDNetWork shareManager].netAgent requestMethod:self.requestMethod urlString:self.url parameters:self.parameter cacheTimeout:self.cacheTimeout netTimeout:self.netTimeout requestHeader:self.requestHeader cachePolicy:self.cachePolicy success:^(id result, BOOL isCache) {
        
        Class MClass = NSClassFromString(self.modelClass);
        id dataModel = [[MClass alloc] init];
        // 加判断
        [dataModel setValue:judgeString(result[@"error"]) forKey:@"errorCode"];
        [dataModel setValue:judgeString(result[@"msg"]) forKey:@"message"];
        [dataModel mj_setKeyValues:result[@"data"]];
        success(dataModel,isCache);
        
    } failure:failure];
}

@end
