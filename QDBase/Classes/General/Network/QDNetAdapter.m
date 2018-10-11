//
//  QDNetAdapter.m
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  请求适配器父类

#import "QDNetAdapter.h"

@implementation QDNetAdapter


- (void)requestSuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSString *url = nil;
    if ([self respondsToSelector:@selector(url)]) {
        url = [self performSelector:@selector(url)];
    }else {
        url = @"";
    }
    _parameter = [self parameter];
    _netTimeout  = [self netTimeout];
    _cachePolicy = [self cachePolicy];
    _cacheTimeout = [self cacheTimeout];
    _requestMethod = [self requestMethod];
    _requestHeader = [self requestHeader];
    
    [[QDNetWork shareManager].netAgent requestMethod:_requestMethod urlString:url parameters:_parameter cacheTimeout:_cacheTimeout netTimeout:_netTimeout requestHeader:_requestHeader cachePolicy:_cachePolicy success:^(id result, BOOL isCache) {
        
        // 拿到 errorCode && msg
        self.errorCode = judgeString(result[@"error"]);
        self.msg = judgeString(result[@"msg"]);
        // 解析数据源
        [self mj_setKeyValues:result[@"data"]];
        success(self,isCache);
        
    } failure:failure];
}


- (void)requestArraySuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSString *url = nil;
    if ([self respondsToSelector:@selector(url)]) {
        url = [self performSelector:@selector(url)];
    }else {
        url = @"";
    }
    _parameter = [self parameter];
    _netTimeout  = [self netTimeout];
    _cachePolicy = [self cachePolicy];
    _cacheTimeout = [self cacheTimeout];
    _requestMethod = [self requestMethod];
    _requestHeader = [self requestHeader];
    
    [[QDNetWork shareManager].netAgent requestMethod:_requestMethod urlString:url parameters:_parameter cacheTimeout:_cacheTimeout netTimeout:_netTimeout requestHeader:_requestHeader cachePolicy:_cachePolicy success:^(id result, BOOL isCache) {
        
        // 拿到 errorCode && msg
        self.errorCode = judgeString(result[@"error"]);
        self.msg = judgeString(result[@"msg"]);
        // 解析数据源
        NSArray *arr = [[self class] mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
        success(arr,isCache);
        
    } failure:failure];
}

@end
