//
//  QDNetWork.h
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  全局网络配置工具类

#import <Foundation/Foundation.h>
#import "QDNetWorkAgent.h"

@interface QDNetWork : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong ,readonly) QDNetWorkAgent *netAgent;

@end
