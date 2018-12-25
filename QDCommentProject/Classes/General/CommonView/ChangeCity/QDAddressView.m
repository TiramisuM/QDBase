//
//  QDAddressViewController.m
//  DigitalTalent
//
//  Created by qiaodaImac on 2018/1/2.
//  Copyright © 2018年 数字英才. All rights reserved.
//

#import "QDAddressView.h"
#import "QDAddressTableViewCell.h"
#import "QDBaseDictModel.h"
#import "QDBaseDictNetwork.h"
#import "QDBaseDictManager.h"

#define SCREEN_WIDTH_AUTO kScreenWidth/375
#define SCREEN_HEIGHT_AUTO kScreenHeight/667

@interface QDAddressView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *provinceTableView;
@property(nonatomic, strong) UITableView *cityTableView;
@property(nonatomic, strong) UITableView *areaTableView;

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *areaArray;


@property (nonatomic, strong) NSMutableArray *addressModelArray;

@property (nonatomic, strong) QDAreaModel *provinceBaseModel;

@property (nonatomic, strong) QDAreaModel *cityBaseModel;

@property (nonatomic, strong) QDBaseDictModel *baseDictModel;

@property (nonatomic, assign) NSInteger defaultSelectProvice;
@property (nonatomic, assign) NSInteger defaultSelectCity;

@end

@implementation QDAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.containsHotArea = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initBaseDictData];
        });
    }
    return self;
}

- (void)initView {

    if (self.haveNoNimit && self.provinceArray.count > 1) {
//        self.provinceBaseModel = self.provinceArray[1];
//        self.provinceBaseModel.isSelect = YES;
//        [self tableView:self.provinceTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.provinceBaseModel = self.provinceArray[0];
        self.provinceBaseModel.isSelect = YES;
    } else {
        if (self.provinceArray.count > 0) {
            self.provinceBaseModel = self.provinceArray.firstObject;
            self.provinceBaseModel.isSelect = YES;
            [self tableView:self.provinceTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    
    self.cityArray = [NSMutableArray arrayWithArray:self.provinceBaseModel.children];
    
    if (self.haveArea) {
        QDAreaModel *model = self.cityArray.firstObject;
        self.cityBaseModel = model;
        model.isSelect = YES;
        self.areaArray = [NSMutableArray arrayWithArray:model.children];
        [self tableView:self.cityTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    [self addSubview:self.provinceTableView];
    [self addSubview:self.cityTableView];
    
    if (self.haveArea) {
        [self addSubview:self.areaTableView];

        [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@(100 * SCREEN_WIDTH_AUTO));
        }];
        [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.provinceTableView.mas_right);
            make.width.equalTo(@(120 * SCREEN_WIDTH_AUTO));
        }];
        [self.areaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.cityTableView);
            make.right.equalTo(self);
        }];
    } else {
        
        [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@(100));
        }];
        [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self.provinceTableView.mas_right);
        }];
    }
    [self handleHotArea];
    [self handleLeftProvince];
    [self selectDefaultCity];
    [self.provinceTableView reloadData];
}

#pragma mark - ============== Data ================
- (void)initBaseDictData {
    
    WS(weakSelf)
    
    if ([QDBaseDictManager shareInstance].baseDictModel) {
        self.baseDictModel = [QDBaseDictManager shareInstance].baseDictModel;
        [self constructData];
        return;
    }
    
    [QDBaseDictNetwork getCitiesSucceed:^(QDResponseModel *resultModel, BOOL isCache) {
           
        if([judgeString(resultModel.errorCode) isEqualToString:@"0"]){
            weakSelf.baseDictModel = [QDBaseDictManager shareInstance].baseDictModel;
            [weakSelf constructData];
            }
        } failure:^(NSError *error) {
           
    }];
}

/// 初始化数据
- (void)constructData {
    
    self.provinceArray = [[NSMutableArray alloc] init];
    [self.provinceArray addObjectsFromArray:self.baseDictModel.area];
    if (self.baseDictModel.hot.count > 0) {
        QDAreaModel *hotModel = [QDAreaModel new];
        hotModel.areaName = @"热门";
        hotModel.children = self.baseDictModel.hot;
        
        [self.provinceArray insertObject:hotModel atIndex:0];
    }
    
    if (self.haveNoNimit) {
        QDAreaModel *unlimitedModel = [QDAreaModel new];
        unlimitedModel.areaName = @"不限";
        unlimitedModel.pid = @"";
        unlimitedModel.children = @[];
        [self.provinceArray insertObject:unlimitedModel atIndex:0];
    }
    
    [self initView];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.provinceTableView) {
        return self.provinceArray.count;
    }else if (tableView == self.cityTableView){
        return self.cityArray.count;
    }
    return self.areaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QDAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDAddressTableViewCell"];
    if (!cell) {
        cell = [[QDAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QDAddressTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        if (tableView == self.provinceTableView) {
            cell.selectAddressBtn.hidden = YES;
        }
        if (self.haveArea) {
            if (tableView == self.cityTableView) {
                cell.selectAddressBtn.hidden = YES;
            }
        }
    }
    
    NSArray *IDs = nil;
    if (self.addressModelArray.count > 0) {
        IDs = [self.addressModelArray valueForKeyPath:@"@distinctUnionOfObjects.code"];
    }
    
    QDAreaModel *model = nil;
    if (tableView == self.provinceTableView) {
        model = self.provinceArray[indexPath.row];
    }else if (tableView == self.cityTableView){
        model = self.cityArray[indexPath.row];
    }else{
        model = self.areaArray[indexPath.row];
    }
    
    // 省份数据去掉后两位相似于ID 可以判断数据该省份下面是否有选中的
    BOOL contains = NO;
    if (IDs.count > 0 && judgeString(model.code).length == 6) {
        
        NSString *cityShort = [model.code substringWithRange:NSMakeRange(0, 4)];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self BEGINSWITH %@ AND self != %@", cityShort, model.code];
        NSArray *res = [IDs filteredArrayUsingPredicate:pred];
        
        contains = res.count > 0;
    }
    
    if (tableView == self.provinceTableView) {
        if ([model.areaName isEqualToString:self.provinceBaseModel.areaName] || contains) {
            cell.backgroundColor = UIColorFromHex(0xFFFFFF);
            self.provinceBaseModel = model;
            
        }else{
            cell.backgroundColor = tableView.backgroundColor;
        }
    }
    
    cell.addressNameLabel.text = model.areaName;
    if (self.haveArea) {
        if (tableView == self.cityTableView) {
            if ([model.code isEqualToString:self.cityBaseModel.code]) {
                cell.backgroundColor = UIColorFromHex(0xFFFFFF);
            }else{
                cell.backgroundColor = tableView.backgroundColor;
            }
        }
    } else {
        if (tableView == self.cityTableView) {
            cell.backgroundColor = tableView.backgroundColor;
            cell.selectAddressBtn.selected = NO;
            for (QDAreaModel *addressModel in self.addressModelArray) {
                if ([addressModel.code isEqualToString:model.code]) {
                    cell.backgroundColor = UIColorFromHex(0xFFFFFF);
                    cell.selectAddressBtn.selected = YES;
                }
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.provinceTableView) {
        QDAreaModel *baseModel = self.provinceArray[indexPath.row];
        self.cityArray = [NSMutableArray arrayWithArray:baseModel.children];
        self.provinceBaseModel = baseModel;
        if (self.cityArray.count == 0) {
            [self addBaseModel:baseModel];
        }
        [self.provinceTableView reloadData];
        [self.cityTableView reloadData];
    }
    if (self.haveArea) {
        if (tableView == self.cityTableView) {
            QDAreaModel *baseModel = self.cityArray[indexPath.row];
            self.areaArray = [NSMutableArray arrayWithArray: baseModel.children];
            self.cityBaseModel = baseModel;
            [self.cityTableView reloadData];
            [self.areaTableView reloadData];
        } else if (tableView == self.areaTableView){
            QDAreaModel *baseModel = self.areaArray[indexPath.row];
            [self addBaseModel:baseModel];
            [self.areaTableView reloadData];
        }
    } else {
        if (tableView == self.cityTableView) {
            QDAreaModel *baseModel = self.cityArray[indexPath.row];
            [self addBaseModel:baseModel];
            [self.cityTableView reloadData];
        }
    }
}
//添加选择model
- (void)addBaseModel:(QDAreaModel *)baseModel {
    
    if (self.isMultiSelect) {
        BOOL contans = NO;
        for (QDAreaModel *addressModel in self.addressModelArray) {
            if ([addressModel.areaName isEqualToString:baseModel.areaName]) {
                contans = YES;
                [self.addressModelArray removeObject:addressModel];
                break;
            }
        }
        if (!contans) {
            if (self.addressModelArray.count >= 5) {
                [QDHUD showTips:@"最多选择5个地址" superView:nil];
                return;
            }
            [self.addressModelArray addObject:baseModel];
        }
        if (self.changeCityBlock) {
            self.changeCityBlock(self.addressModelArray);
        }
    } else {
        [self.addressModelArray removeAllObjects];
        baseModel.pname = judgeString(self.provinceBaseModel.areaName);
        [self.addressModelArray addObject:baseModel];
        if (self.changeCityBlock) {
            self.changeCityBlock(self.addressModelArray);
        }
    }
}

#pragma mark -- 点击事件
- (UITableView *)provinceTableView {
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _provinceTableView.rowHeight = 44;
        _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provinceTableView.backgroundColor = UIColorFromHex(0xF5F8FA);
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
    }
    return _provinceTableView;
}
- (UITableView *)cityTableView {
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cityTableView.rowHeight = 44;
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTableView.backgroundColor = UIColorFromHex(0xFBFBFB);
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
    }
    return _cityTableView;
}
- (UITableView *)areaTableView {
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _areaTableView.rowHeight = 44;
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaTableView.backgroundColor = UIColorFromHex(0xFFFFFF);
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
    }
    return _areaTableView;
}
- (NSMutableArray *)addressModelArray {
    if (!_addressModelArray) {
        _addressModelArray = [[NSMutableArray alloc]init];
    }
    return _addressModelArray;
}

- (void)setDefalutSelects:(NSArray<QDAreaModel *> *)defalutSelects {
    
    _defalutSelects = defalutSelects;
    
    for (QDAreaModel *model in defalutSelects) {
        
        model.isSelect = YES;
        [self addBaseModel:model];
    }
}

- (void)handleHotArea {
    if (!self.containsHotArea) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.provinceArray];
        for (QDAreaModel *model in self.provinceArray) {
            if ([model.areaName isEqualToString:@"热门"]) {
                [array removeObject:model];
            }
        }
        self.provinceArray = array;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.provinceTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)handleLeftProvince {
    /// 只留下某些省份数组有值, 则进行遍历 将省份数组替换
    if (self.leftProvinces.count) {
        NSMutableArray *leftProvinceArray = [NSMutableArray array];
        for (NSString *provinceId in self.leftProvinces) {
            if (![provinceId isKindOfClass:[NSString class]]) {
                continue;
            }
            if (provinceId.length < 2) {
                continue;
            }
            NSString *prefixStr = [provinceId substringToIndex:2];
            NSString *province = prefixStr.append(@"0000");
            for (QDAreaModel *model in self.provinceArray) {
                if ([model.code isEqualToString:province] && (![leftProvinceArray containsObject:model])) {
                    [leftProvinceArray addObject:model];
                }
            }
        }
        self.provinceArray = leftProvinceArray;
        if (leftProvinceArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:self.provinceTableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - ============== 默认选中 ================
- (void)selectDefaultCity {
    // 滚动指定的省位置
    NSArray *IDs = nil;
    if (self.addressModelArray.count > 0) {
        IDs = [self.addressModelArray valueForKeyPath:@"@distinctUnionOfObjects.code"];
        
        if(IDs.count == 0) return;
    }
    
    NSInteger proviceSel = 0;
    for (NSInteger i = 0; i < self.provinceArray.count; i++) {
        
        QDAreaModel *proviceModel = self.provinceArray[i];
        
        // 省份数据去掉后两位相似于ID 可以判断数据该省份下面是否有选中的
        if (IDs.count > 0 && judgeString(proviceModel.code).length == 6) {
            
            NSString *cityShort = [proviceModel.code substringWithRange:NSMakeRange(0, 2)];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"self BEGINSWITH %@ AND self != %@", cityShort, proviceModel.code];
            NSArray *res = [IDs filteredArrayUsingPredicate:pred];
            
            // 取第一个数据
            if (res.count > 0) {
                proviceSel = i;
                break;
            }
        }
    }
    
    if (proviceSel) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:proviceSel inSection:0];
        [self tableView:self.provinceTableView didSelectRowAtIndexPath:indexPath];
        [self.provinceTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
