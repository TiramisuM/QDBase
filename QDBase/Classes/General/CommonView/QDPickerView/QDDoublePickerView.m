//
//  QDDoublePickerView.m
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义双选pickerView

#import "QDDoublePickerView.h"

@interface QDDoublePickerView ()

@property (nonatomic, copy) QDDoublePickerBlcok pickerBlock;

@property (nonatomic, strong) PickerModel *selectModel;

@property (nonatomic, strong) PickerModel *subSelectModel;

@property (nonatomic, strong) NSMutableArray *dataListArray;

@property (nonatomic, strong) NSMutableArray *subDataListArray;

@property (nonatomic, assign) QDDoublePickerViewType type;

@end

@implementation QDDoublePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.sureBtnActionBlock = ^{
            if (weakSelf.pickerBlock) {
                weakSelf.pickerBlock(weakSelf.selectModel, weakSelf.subSelectModel);
            }
        };
    }
    return self;
}

/**
 自定义双选pickerView
 
 @param from 第一组选项默认值
 @param to 第二组选项默认值
 @param title 标题
 @param type 弹窗滑轮类型 QDDoublePickerViewType
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showPickerViewWithFrom:(NSString *)from to:(NSString *)to title:(NSString *)title type:(QDDoublePickerViewType)type pickerBlock:(QDDoublePickerBlcok)pickerBlock {
    
    QDDoublePickerView *pickerView = [[QDDoublePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.pickerBlock = pickerBlock;
    pickerView.type = type;
    [pickerView changePickerViewTitle:title];
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    [pickerView.pickerView reloadAllComponents];
    
    // 预填
    switch (type) {
        case QDDoublePickerViewTypeWorkExp:
            [pickerView prefillExpreWithFrom:from to:to];
            break;
        case QDDoublePickerViewTypeSalary:
            [pickerView prefillSalaryWithFrom:from to:to];
            break;
        case QDDoublePickerViewTypeAge:
            [pickerView prefillAgeWithFrom:from to:to];
            break;
        default:
            break;
    }
}

#pragma mark - ============== DataSource & Delegate ================

/// 指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

/// 指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataListArray.count;
    }
    return self.subDataListArray.count;
}
/// 指定每行如何展示数据（此处和tableview类似）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        PickerModel *model = self.dataListArray[row];
        return model.name;
    }
    PickerModel *model = self.subDataListArray[row];
    return model.name;
}

/// 选中某行后回调的方法，获得选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectModel = self.dataListArray[row];
        self.subSelectModel = nil;
        [self updateSubDataList:self.selectModel];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        if (self.subDataListArray.count) {
            PickerModel *subModel = self.subDataListArray.firstObject;
            self.subSelectModel.id = subModel.id;
            self.subSelectModel.name = subModel.name;
        } else {
            self.subSelectModel.id = self.selectModel.id;
            self.subSelectModel.name = self.selectModel.name;
        }
        
    } else {
        
        if (self.subDataListArray.count) {
            self.subSelectModel = self.subDataListArray[row];
        } else {
            self.subSelectModel.id = self.selectModel.id;
            self.subSelectModel.name = self.selectModel.name;
        }
    }
}

#pragma mark - ============== PrivateMethod ================

/// 工作经验预填
- (void)prefillExpreWithFrom:(NSString *)from to:(NSString *)to{
    
    if (from.integerValue > 0 && from.integerValue <= 30) {
        
        self.selectModel.id =  from;
        self.selectModel.name = from;
        
        for (int i = 0; i < self.subDataListArray.count; i++) {
            
            PickerModel *model = self.subDataListArray[i];
            
            if ([model.id isEqualToString:from]) {
                
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                break;
            }
        }
        
    } else {
        self.selectModel = self.subDataListArray.firstObject;
    }
    
    if (to.integerValue > 0 && to.integerValue <= 30) {
        
        self.subSelectModel.id = to;
        self.subSelectModel.name = to;
        
        for (int i = 0; i < self.subDataListArray.count; i++) {
            
            PickerModel *model = self.subDataListArray[i];
            
            if ([model.id isEqualToString:to]) {
                
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                break;
            }
        }
    } else {
        self.subSelectModel = self.subDataListArray.firstObject;
    }
}

/// 薪水预填
- (void)prefillSalaryWithFrom:(NSString *)from to:(NSString *)to{
    
    // 修改薪资最大值为100
    if (from.integerValue > 0 && from.integerValue <= 100) {
        
        self.selectModel.id =  from;
        self.selectModel.name = from;
        
        for (int i = 0; i < self.dataListArray.count; i++) {
            
            PickerModel *model = self.dataListArray[i];
            
            if ([model.id isEqualToString:from]) {
                
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                break;
            }
        }
        
    } else {
        self.selectModel = self.dataListArray.firstObject;
    }
    
    [self updateSubDataList:self.selectModel];
    
    if (to.integerValue >= 2 && to.integerValue <= 100) {
        
        self.subSelectModel.id = to;
        self.subSelectModel.name = to;
        for (int i = 0; i < self.subDataListArray.count; i++) {
            PickerModel *model = self.subDataListArray[i];
            if ([model.id isEqualToString:to]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                break;
            }
        }
    } else {
        self.subSelectModel = self.subDataListArray.firstObject;
    }
    
    // 1K以下和100K以上的判断
    if (from.integerValue == 0 && to.integerValue == 1) {
        
        [self.pickerView selectRow:1 inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:1 inComponent:0];
        
    } else if (from.integerValue == 100 && to.integerValue == 0) {
        
        [self.pickerView selectRow:(self.subDataListArray.count - 1) inComponent:1 animated:YES];
        [self pickerView:self.pickerView didSelectRow:(self.subDataListArray.count - 1) inComponent:1];
    }
}

/// 年龄预填
- (void)prefillAgeWithFrom:(NSString *)from to:(NSString *)to {
    
    if (from.integerValue > 20 && from.integerValue <= 60) {
        
        self.selectModel.id =  from;
        self.selectModel.name = from;
        
        for (int i = 0; i < self.dataListArray.count; i++) {
            
            PickerModel *model = self.dataListArray[i];
            
            if ([model.id isEqualToString:from]) {
                
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                break;
            }
        }
    } else {
        self.selectModel = self.dataListArray.firstObject;
    }
    
    [self updateSubDataList:self.selectModel];
    
    if (to.integerValue > 20 && to.integerValue <= 60) {
        
        self.subSelectModel.id = to;
        self.subSelectModel.name = to;
        
        for (int i = 0; i < self.subDataListArray.count; i++) {
            
            PickerModel *model = self.subDataListArray[i];
            
            if ([model.id isEqualToString:to]) {
                
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                break;
            }
        }
    } else {
        self.subSelectModel = self.subDataListArray.firstObject;
    }
}
/// 更新SubDataList数据
- (void)updateSubDataList:(PickerModel *)model {
    
    [self.subDataListArray removeAllObjects];
    
    for (PickerModel *tempModel in self.dataListArray) {
        
        switch (self.type) {
            case QDDoublePickerViewTypeWorkExp: {
                
                if (tempModel.id.integerValue >= model.id.integerValue) {
                    [self.subDataListArray addObject:tempModel];
                }
            }
                break;
                
            case QDDoublePickerViewTypeSalary: {
                
                if ([self.selectModel.name isEqualToString:@"不限"]) {
                    [self.pickerView reloadComponent:1];
                    return;
                }
                
                // 当为1K以下的时候不显示右边筛选
                if ([self.selectModel.name isEqualToString:@"1K以下"]) {
                    [self.pickerView reloadComponent:1];
                    return;
                }
                
                if (tempModel.id.integerValue > model.id.integerValue) {
                    [self.subDataListArray addObject:tempModel];
                }
                // 如果当前的model为100K则增加100K以上的筛选条件
                if (model.id.integerValue == 100 && tempModel.id.integerValue == 100) {
                    PickerModel *modelMax = [[PickerModel alloc] init];
                    modelMax.id = @"0";
                    modelMax.name = @"100K以上";
                    [_subDataListArray addObject:modelMax];
                }
            }
                break;
                
            case QDDoublePickerViewTypeAge: {
                
                if ([self.selectModel.name isEqualToString:@"不限"]) {
                    [self.pickerView reloadComponent:1];
                    return;
                }
                if (tempModel.id.integerValue >= model.id.integerValue) {
                    [self.subDataListArray addObject:tempModel];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - ============== Setter & Getter ================

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray new];
        
        switch (self.type) {
            case QDDoublePickerViewTypeWorkExp: {
                
                for (int i = 0; i <= 30; i++) {
                    
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    
                    if (i == 0) {
                        model.name = @"不限";
                    } else {
                        model.name = [NSString stringWithFormat:@"%d年",i];
                    }
                    [_dataListArray addObject:model];
                }
            }
                break;
            case QDDoublePickerViewTypeSalary: {
                
                PickerModel *model = [[PickerModel alloc] init];
                model.name = @"不限";
                model.id = @"0";
                [_dataListArray addObject:model];
                
                // 新增1K以下数据
                PickerModel *model1 = [[PickerModel alloc] init];
                model1.name = @"1K以下";
                model1.id = @"0.5";
                [_dataListArray addObject:model1];
                
                for (int i = 1; i <= 50; i++) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    model.name = [NSString stringWithFormat:@"%dk",i];
                    [_dataListArray addObject:model];
                }
                for (int i = 60; i <= 100; i += 10) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    model.name = [NSString stringWithFormat:@"%dk",i];
                    [_dataListArray addObject:model];
                }
            }
                break;
                
            case QDDoublePickerViewTypeAge: {
                
                PickerModel *model = [[PickerModel alloc] init];
                model.name = @"不限";
                model.id = @"0";
                [_dataListArray addObject:model];
                
                for (int i = 20; i <= 60; i++) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d", i];
                    model.name = [NSString stringWithFormat:@"%d", i];
                    [_dataListArray addObject:model];
                }
            }
                break;
                
            default:
                break;
        }
    }
    return _dataListArray;
}

- (NSMutableArray *)subDataListArray {
    
    if (!_subDataListArray) {
        _subDataListArray = [NSMutableArray new];
        
        switch (self.type) {
            case QDDoublePickerViewTypeWorkExp:
            {
                for (int i = 0; i <= 30; i++) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    if (i == 0) {
                        model.name = @"不限";
                    }else
                    {
                        model.name = [NSString stringWithFormat:@"%d年",i];
                    }
                    
                    [_subDataListArray addObject:model];
                }
            }
                break;
            case QDDoublePickerViewTypeSalary:
            {
                for (int i = 1; i <= 50; i++) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    model.name = [NSString stringWithFormat:@"%dk",i];
                    [_subDataListArray addObject:model];
                }
                for (int i = 60; i <= 100; i += 10) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d",i];
                    model.name = [NSString stringWithFormat:@"%dk",i];
                    [_subDataListArray addObject:model];
                }
            }
                break;
                
            case QDDoublePickerViewTypeAge:
            {
                for (int i = 20; i <= 60; i++) {
                    PickerModel *model = [[PickerModel alloc] init];
                    model.id = [NSString stringWithFormat:@"%d", i];
                    model.name = [NSString stringWithFormat:@"%d", i];
                    [_subDataListArray addObject:model];
                }
            }
                break;
                
            default:
                break;
        }
    }
    return _subDataListArray;
}

- (PickerModel *)selectModel {
    if (!_selectModel) {
        _selectModel = [PickerModel new];
    }
    return _selectModel;
}

- (PickerModel *)subSelectModel {
    if (!_subSelectModel) {
        _subSelectModel = [PickerModel new];
    }
    return _subSelectModel;
}

@end
