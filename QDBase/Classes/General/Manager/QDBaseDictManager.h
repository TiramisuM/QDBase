//
//  QDBaseDictManager.h
//  InsuranceAgentRelation
//
//  Created by qiaodaImac on 2018/12/6.
//  Copyright © 2018 QiaoData. All rights reserved.
/// 与用户不绑定缓存

#import <Foundation/Foundation.h>
#import "QDBaseDictModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDBaseDictManager : NSObject

/// 单例方法
+ (instancetype)shareInstance;

/// 地区缓存
@property (nonatomic, strong) QDBaseDictModel *baseDictModel;

@end

NS_ASSUME_NONNULL_END
