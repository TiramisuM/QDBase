//
//  QDAddressViewController.h
//  DigitalTalent
//
//  Created by qiaodaImac on 2018/1/2.
//  Copyright © 2018年 数字英才. All rights reserved.
//  选择地址View

#import <UIKit/UIKit.h>
#import "QDBaseDictModel.h"

@interface QDAddressView : UIView

@property (nonatomic, assign) BOOL isMultiSelect;//是否是多选
@property (nonatomic, assign) BOOL haveArea;//是否包含区 默认包含
@property (nonatomic, strong) NSArray <QDAreaModel *>*defalutSelects; // 默认选中的数据

@property (nonatomic, assign) BOOL haveNoNimit;// 是否含有不限城市
/// 只留下哪些省 数组内字符串为省id
@property (nonatomic, strong) NSArray <NSString *>*leftProvinces;
/// 是否包含热门
@property (nonatomic, assign) BOOL containsHotArea;

@property (nonatomic, copy) void(^changeCityBlock)(NSMutableArray<QDAreaModel *> *addressModelArray);

@end
