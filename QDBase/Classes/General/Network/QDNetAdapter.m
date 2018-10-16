//
//  QDNetAdapter.m
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  请求适配器父类

#import "QDNetAdapter.h"
#import "QDResponseModel.h"

@implementation QDNetAdapter

- (NSURLSessionDataTask *)requestSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    // 拼接 URL 和 参数
    [self formaterUrlAndParameter];
    
    return [[QDNetWork shareManager].netAgent requestMethod:self.requestMethod urlString:self.url parameters:self.parameter cacheTimeout:self.cacheTimeout netTimeout:self.netTimeout requestHeader:self.requestHeader cachePolicy:self.cachePolicy success:^(id result, BOOL isCache) {
        
        Class MClass = NSClassFromString(self.modelClass);
        id dataModel = [[MClass alloc] init];

        NSAssert([MClass isKindOfClass:[QDResponseModel class]], @"数据模型类没有继承 QDResponseModel ");
        
        [dataModel setValue:judgeString(result[@"error"]) forKey:@"errorCode"];
        [dataModel setValue:judgeString(result[@"msg"]) forKey:@"message"];
        [dataModel mj_setKeyValues:result[@"data"]];
        success(dataModel,isCache);
        
    } failure:failure];
}

-(NSURLSessionDataTask *)postImageProgress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    // 拼接 URL 和 参数
    [self formaterUrlAndParameter];
    
    return [[QDNetWork shareManager].netAgent postImageWithURLString:self.url parameters:self.parameter imageDataArr:self.imageDataArr imageNameArr:self.imageNameArr progress:progress success:success failure:failure];
}

- (void)formaterUrlAndParameter{
    /// 如果参数存在，则将用户信息拼接上去，如果不存在，则直接返回用户信息的参数
    (self.parameter && [self.parameter isKindOfClass:[NSDictionary class]] && self.parameter.allKeys.count > 0) ? [QDNetWork appendUserInfoWithDict:self.parameter] : [QDNetWork userInfoDict];
    
    /// URL
    self.url = [QDNetWork appendUrlWithString:self.url];
}

@end
