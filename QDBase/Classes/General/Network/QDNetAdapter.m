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

- (NSURLSessionDataTask *)requestSuccess:(SuccessedModelBlock)success failure:(FailureBlock)failure {
    
    // 拼接 URL 和 参数
    [self formaterUrlAndParameter];
    
    return [[QDNetWork shareManager].netAgent requestMethod:self.requestMethod urlString:self.url parameters:self.parameter cacheTimeout:self.cacheTimeout netTimeout:self.netTimeout requestHeader:self.requestHeader cachePolicy:self.cachePolicy success:^(id result, BOOL isCache) {
        
        if (!IS_NOT_EMPTY(self.modelClass)) {
            self.modelClass = @"QDResponseModel";
        }
        Class MClass = NSClassFromString(self.modelClass);
        id dataModel = [[MClass alloc] init];
        if (![dataModel isKindOfClass:[QDResponseModel class]]) {
            dataModel = [QDResponseModel class];
        }
        
        [dataModel setValue:judgeString(result[@"error"]) forKey:@"errorCode"];
        [dataModel setValue:judgeString(result[@"msg"]) forKey:@"message"];
        
        if (result[@"data"]) {
            [dataModel setValue:result[@"data"] forKey:@"data"];
            [dataModel mj_setKeyValues:result[@"data"]];
        }

        success ? success(dataModel,isCache) : nil;
        
    } failure:^(NSError *error) {
        failure ? failure(error) : nil;
    }];
}

-(NSURLSessionDataTask *)postImageProgress:(ProgressBlock)progress success:(SuccessedModelBlock)success failure:(FailureBlock)failure{
    
    // 拼接 URL 和 参数
    [self formaterUrlAndParameter];
    
    return [[QDNetWork shareManager].netAgent postImageWithURLString:self.url parameters:self.parameter imageDataArr:self.imageDataArr imageNameArr:self.imageNameArr progress:progress success:^(id result, BOOL isCache) {
        
        QDResponseModel *response = [[QDResponseModel alloc] init];
        response.errorCode = judgeString(result[@"error"]);
        response.message = judgeString(result[@"msg"]);
        success ? success(response,isCache) : nil;
        
    } failure:^(NSError *error) {
        failure ? failure(error) : nil;
    }];
}

- (void)formaterUrlAndParameter{
    
    /// 如果参数存在，则将用户信息拼接上去，如果不存在，则直接返回用户信息的参数
    self.parameter = (self.parameter && [self.parameter isKindOfClass:[NSDictionary class]] && self.parameter.allKeys.count > 0) ? [self appendUserInfo] : [QDNetWork netUserInfoDict];
    
    /// URL
    self.url = [self appendUrl];
}

- (NSString *)appendUrl{
    
    NSDictionary *urlDic = [QDNetWork netPublicParameter];
    return [NSString stringWithFormat:@"%@?apiversion=%@&appversion=%@&osType=%@", self.url, urlDic[@"apiVersion"], urlDic[@"appVersion"], urlDic[@"osType"]];
}

- (NSDictionary *)appendUserInfo{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict addEntriesFromDictionary:self.parameter];
    [paramDict addEntriesFromDictionary:[QDNetWork netUserInfoDict]];
    return paramDict;
}


@end

