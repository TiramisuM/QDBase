//
//  QDTableManager.m
//  QDBase
//
//  Created by AngleK on 2018/10/15.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "QDTableManager.h"

@implementation QDTableManager

+(NSURLSessionDataTask *)get:(NSDictionary *)pararmeter succeed:(SuccessBlock)succeed{
    QDNetAdapter *adapter = [[QDNetAdapter alloc] init];
    adapter.url = @"/sale/list";
    adapter.parameter = pararmeter;
    adapter.modelClass = @"QDTableModel";
    return [adapter requestSuccess:^(id result, BOOL isCache) {
        succeed(result, isCache);
    } failure:nil];
}

@end
