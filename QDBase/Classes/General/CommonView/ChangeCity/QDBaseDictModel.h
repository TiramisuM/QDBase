//
//  QDBaseDictModel.h
//  DigitalTalent
//
//  Created by qiaodaImac on 2018/1/19.
//  Copyright © 2018年 数字英才. All rights reserved.
//  全局字典model

#import <Foundation/Foundation.h>
@class QDAreaModel;

@interface QDBaseDictModel : QDResponseModel

@property (nonatomic, strong) NSArray <QDAreaModel *> *hot;
@property (nonatomic, strong) NSArray <QDAreaModel *> *area;

@end

@interface QDAreaModel: NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pid;// 省ID
@property (nonatomic, copy) NSString *pname;// 省ID

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *enName; 
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *orderTag;
@property (nonatomic, copy) NSString *hotArea;
@property (nonatomic, copy) NSString *ishot;
@property (nonatomic, copy) NSArray *children;
@property (nonatomic, strong) NSMutableArray *childrenModelArray;

@property (nonatomic, assign) BOOL isSelect;


@end
