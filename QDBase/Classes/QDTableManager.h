//
//  QDTableManager.h
//  QDBase
//
//  Created by AngleK on 2018/10/15.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDNetAdapter.h"

@interface QDTableManager : NSObject
+(NSURLSessionDataTask *)get:(NSDictionary *)pararmeter succeed:(SuccessBlock)succeed;
@end
