//
//  QDResponseModel.h
//  QDBase
//
//  Created by AngleK on 2018/10/15.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 网络请求返回的model基类

#import <Foundation/Foundation.h>

@interface QDResponseModel : NSObject
/// 返回的错误码
@property (nonatomic, copy) NSString *errorCode;
/// 返回的描述信息
@property (nonatomic, copy) NSString *message;
/// 返回data数据
@property (nonatomic, strong) id data;
@end
