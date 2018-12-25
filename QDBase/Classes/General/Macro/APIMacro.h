//
//  APIMacro.h
//  QDBase
//
//  Created by QiaoData on 2018/9/26.
//  Copyright © 2018年 QiaoData. All rights reserved.
//  放置接口方法等

#ifndef APIMacro_h
#define APIMacro_h

/*****测试、开发*********************************************************/
//开发环境
//#define BASE_URL                      @"http://dev.api.guanxiduo.com"
//测试环境
#define BASE_URL                      @"http://test.api.guanxiduo.com"

/*****线上*********************************************************/
// #define BASE_URL                  @"https://api3.agent.guanxiduo.com"

/// 苹果审核通过时间
#define approvedTime  @"2018-12-15"

#define API_VERSION @"3.1.0"

/***************************通用接口*********************************/

/// 全局地区字典值
#define API_BASE_DICT                           @"/Dictarea/getAll"
/// 筛选字典
#define API_FILTER_DICT                         @"/Dict/getAll"

#endif /* APIMacro_h */
