//
//  QDNetWork.h
//  QDCommentProject
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  全局网络配置工具类

#import <Foundation/Foundation.h>
#import "QDNetWorkAgent.h"

@interface QDNetWork : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong ,readonly) QDNetWorkAgent *netAgent;

/**
 获取网络请求需要的用户信息
 
 @return 用户信息
 */
+ (NSDictionary *)netUserInfoDict;

/**
 获取网络请求需要的公共信息
 
 @return 公共信息
 */
+ (NSDictionary *)netPublicParameter;

@end
