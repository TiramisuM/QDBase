//
//  QDTableAdaper.h
//  QDBase
//
//  Created by AngleK on 2018/10/11.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDNetAdapter.h"

@interface QDTableAdaper : QDNetAdapter<QDNetAdapterProtocol>

@property (nonatomic, copy) NSString *name;

@end
