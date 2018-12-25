//
//  QDCitiesNetwork.h
//  InsuranceAgentRelation
//
//  Created by AngleK on 2018/10/24.
//  Copyright © 2018 QiaoData. All rights reserved.
/// 程序基础字典网络请求类

#import <Foundation/Foundation.h>

@interface QDBaseDictNetwork : NSObject

/**
  获取缓存城市数据

 @param succeed 成功回调
 @param failure 失败回调
 */
+ (void)getCitiesSucceed:(SuccessedModelBlock)succeed failure:(FailureBlock)failure;

/**
 获取筛选字典数据

 @param succeed 成功回调
 @param failure 失败回调
 */
+ (void)getFilterDictSucceed:(SuccessedModelBlock)succeed failure:(FailureBlock)failure;

@end
