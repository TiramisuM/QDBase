//
//  QDCitiesNetwork.m
//  InsuranceAgentRelation
//
//  Created by AngleK on 2018/10/24.
//  Copyright © 2018 QiaoData. All rights reserved.
/// 城市数据网络请求类

#import "QDBaseDictNetwork.h"
#import "QDBaseDictModel.h"
#import "QDBaseDictManager.h"

@implementation QDBaseDictNetwork
/// 获取城市字典
+ (void)getCitiesSucceed:(SuccessedModelBlock)succeed failure:(FailureBlock)failure {
    QDNetAdapter *adapter = [[QDNetAdapter alloc] init];
    adapter.url = API_BASE_DICT;
    adapter.cachePolicy = QDNetCacheRequestReturnCacheDataNoBindUser;
    adapter.cacheTimeout = 10*60*60*24;
    adapter.modelClass = @"QDBaseDictModel";

    [adapter requestSuccess:^(QDResponseModel *resultModel, BOOL isCache) {
        
        [QDBaseDictManager shareInstance].baseDictModel = (QDBaseDictModel *)resultModel;
        
        if (succeed) {
            succeed(resultModel, isCache);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/// 获取筛选字段数据
+ (void)getFilterDictSucceed:(SuccessedModelBlock)succeed failure:(FailureBlock)failure {
    QDNetAdapter *adapter = [[QDNetAdapter alloc] init];
    adapter.url = API_FILTER_DICT;
    adapter.cachePolicy = QDNetCacheRequestReturnCacheDataNoBindUser;
    adapter.cacheTimeout = 10*60*60*24;
    adapter.modelClass = @"QDFilterDictModel";
    
    [adapter requestSuccess:succeed failure:failure];
}

@end
