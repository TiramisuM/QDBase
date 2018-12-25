//
//  UUChangeCityViewController.h
//  RecruitmentFrog
//
//  Created by qiaodaImac on 2017/12/6.
//  Copyright © 2017年 rencaiwa. All rights reserved.
//  更换城市

#import "QDBaseViewController.h"
#import "QDAddressView.h"

@interface QDChangeCityViewController : QDBaseViewController

@property (nonatomic, assign) BOOL isMultiSelect;//是否是多选(默认单选)
@property (nonatomic, assign) BOOL haveArea;//是否包含区 默认包含
@property (nonatomic, strong) NSArray <QDAreaModel *>*defalutSelects;
@property (nonatomic, assign) BOOL haveNoNimit;// 是否含有不限城市
/// 只留下哪些省 数组内字符串为省id
@property (nonatomic, strong) NSArray <NSString *>*leftProvinces;
/// 是否包含热门
@property (nonatomic, assign) BOOL containsHotArea;

@property (nonatomic, copy) void(^changeCityBlock)(NSMutableArray<QDAreaModel *> *addressModelArray);

@end
