//
//  NSObject+QDBaseModel.h
//  QDBase
//
//  Created by QiaoData on 2018/8/9.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 给所有的model添加一个id字段

#import <Foundation/Foundation.h>

@interface NSObject (QDBaseModel)

/// id
@property (nonatomic, copy) NSString *id;

@end
