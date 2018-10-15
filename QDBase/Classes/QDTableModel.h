//
//  QDTableModel.h
//  QDBase
//
//  Created by AngleK on 2018/10/15.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDResponseModel.h"
#import "QDSaleModel.h"

@interface QDTableModel : QDResponseModel

@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *update;
@property (nonatomic, copy) NSArray<QDSaleModel *> *list;

@end
