//
//  QDTableAdaper.m
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "QDTableAdaper.h"
#import "QDNetWork.h"

@implementation QDTableAdaper


- (NSString *)url {
    return @"/Introduce/list";
}

-(QDNetCacheRequestType)requestMethod{
    return QDNetCacheRequestTypePOST;
}

//-(NSDictionary *)parameter{
//    return @{@"keyword":@"李",@"page":@1};
//}

@end
