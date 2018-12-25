//
//  QDDatePicker.m
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义时间pickerView

#import "QDDatePickerView.h"

@interface QDDatePickerView ()

@property (nonatomic, copy) QDDatePickerBlcok pickerBlock;

@property (nonatomic, strong) PickerModel *selectModel;

@property (nonatomic, strong) PickerModel *subSelectModel;

@property (nonatomic, strong) NSMutableArray *dataListArray;

@property (nonatomic, strong) NSMutableArray *subDataListArray;

@property (nonatomic, assign) QDDatePickerViewType type;
/// 系统时间选择pickerView
@property (nonatomic, strong) UIDatePicker *datePickerView;

@property (nonatomic, copy) void(^datePickerBlock)(NSDate *date);

@end

@implementation QDDatePickerView

#define ToolBarHieght 43

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.sureBtnActionBlock = ^{
            if (weakSelf.pickerBlock) {
                weakSelf.pickerBlock(weakSelf.selectModel, weakSelf.subSelectModel);
            }
            
            if (weakSelf.datePickerBlock) {
                weakSelf.datePickerBlock(weakSelf.datePickerView.date);
            }
        };
    }
    return self;
}

/**
 自定义DatePickerView
 
 @param year 年份默认值
 @param month 月份默认值
 @param title 标题
 @param type 弹窗滑轮类型 QDDatePickerViewType
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock {
    [self showDatePickerViewWithYear:year month:month title:title sureTitle:@"确认" cancelTitle:@"取消" type:type pickerBlock:pickerBlock cancelBlock:nil];
    
}

+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock {
    [self showDatePickerViewWithYear:year month:month title:title sureTitle:@"确认" cancelTitle:@"取消" type:type pickerBlock:pickerBlock cancelBlock:cancelBlock];
}

+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock {
    QDDatePickerView *pickerView = [[QDDatePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.pickerBlock = pickerBlock;
    pickerView.cancelBtnActionBlock = cancelBlock;
    pickerView.type = type;
    [pickerView changePickerViewTitle:title];
    [pickerView updateSureButtonTitle:judgeString(sureTitle)];
    [pickerView updateCancelButtonTitle:judgeString(cancelTitle)];
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    [pickerView prefillDateWithYear:year month:month];
}

/**
 弹出系统原生datePickerView
 
 @param title 标题
 @param pickerBlock 确认按钮点击回调 返回NSDate
 @return 系统原生datePickerView
 */
+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title pickerBlock:(void(^)(NSDate *date))pickerBlock {
    return [self showSystemDatePickerViewWithTitle:title sureTitle:@"确认" cancelTitle:@"取消" timeIntervalString:@"" pickerBlock:pickerBlock cancelBlock:nil];
}

+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title pickerBlock:(void (^)(NSDate *))pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock {
    return [self showSystemDatePickerViewWithTitle:title sureTitle:@"确认" cancelTitle:@"取消" timeIntervalString:@"" pickerBlock:pickerBlock cancelBlock:cancelBlock];
}

+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle timeIntervalString:(NSString *)timeString pickerBlock:(void (^)(NSDate *))pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock {
    
    QDDatePickerView *pickerView = [[QDDatePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.datePickerBlock = pickerBlock;
    [pickerView changePickerViewTitle:title];
    [pickerView updateSureButtonTitle:sureTitle];
    [pickerView updateCancelButtonTitle:cancelTitle];
    pickerView.cancelBtnActionBlock = cancelBlock;
    pickerView.timeIntervalString = timeString;
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    __block UIView *spanView = pickerView.pickerView.superview;
    CGFloat top = ToolBarHieght;
    [pickerView.pickerView removeFromSuperview];
    [spanView addSubview:pickerView.datePickerView];
    
    [pickerView.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(spanView);
        make.top.equalTo(spanView).offset(top);
    }];
    return pickerView;
}

#pragma mark - ============== DataSource & Delegate ================

/// 指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // 3.0中教育经历开始时间只有年份，Components = 1
    if (self.type == QDDatePickerViewTypeEduExpStartYear || self.type == QDDatePickerViewTypeEduExpEndYear) {
        return 1;
    } else {
        return 2;
    }
}

/// 指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataListArray.count;
    }
    return self.subDataListArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PickerModel *model = nil;
    if (component == 0) {
        model = self.dataListArray[row];
    } else {
        model = self.subDataListArray[row];
    }
    return model.name;
}

/// 选中某行后回调的方法，获得选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectModel = self.dataListArray[row];
        self.subSelectModel = nil;
        [self updateSubDataList:self.selectModel];
        
        // 3.0中的教育经历开始和结束时间没有月份，所有 Component 只有一个，[pickerView reloadComponent:1] 会崩溃
        if (self.type != QDDatePickerViewTypeEduExpStartYear && self.type != QDDatePickerViewTypeEduExpEndYear) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        
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

/// 更新SubDataList数据
- (void)updateSubDataList:(PickerModel *)model {
    
    [self.subDataListArray removeAllObjects];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *nowDate = [NSDate date];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:nowDate];
    
    if ([self.selectModel.name isEqualToString:@"至今"] || [self.selectModel.name isEqualToString:@"不限"]) {
        
    } else if ([self.selectModel.name isEqualToString:[NSString stringWithFormat:@"%ld",(long)comp.year]] &&
               self.type != QDDatePickerViewTypeEduExpEndDate){
        
        for (int i = 0; i < comp.month; i++) {
            PickerModel *model = [[PickerModel alloc]init];
            model.name = [NSString stringWithFormat:@"%d",i+1];
            model.id = [NSString stringWithFormat:@"%d",i+1];
            [self.subDataListArray addObject:model];
        }
        
    } else {
        
        for (int i = 0; i < 12; i++) {
            PickerModel *model = [[PickerModel alloc] init];
            model.id = [NSString stringWithFormat:@"%d",i+1];
            model.name = [NSString stringWithFormat:@"%d",i+1];
            [self.subDataListArray addObject:model];
        }
    }
}

/// 时间预填
- (void)prefillDateWithYear:(NSString *)year month:(NSString *)month {
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *dt = [NSDate date];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dt];
    
    // 3.0新增 self.type != QDDatePickerViewTypeEduExpStartYear && self.type != QDDatePickerViewTypeEduExpEndYear
    if (self.type != QDDatePickerViewTypeBirthDate && self.type != QDDatePickerViewTypeEduExpStartYear && self.type != QDDatePickerViewTypeEduExpEndYear) {
        if (judgeString(year).length == 0 || year.length < 4 || year.integerValue < (comp.year - 50) || year.integerValue > (comp.year + 50)) {
            year = [NSString stringWithFormat:@"%ld",(long)comp.year];
        }
        if (judgeString(month).length == 0 || month.integerValue <= 0 || month.integerValue > 12) {
            month = [NSString stringWithFormat:@"%ld",(long)comp.month];
        }
        
        if ([year isEqualToString:@"至今"]) {
            self.subSelectModel = self.selectModel;
            return;
        }
    }
    
    if (year.length > 0) {
        
        for (int i = 0; i < self.dataListArray.count; i++) {
            
            PickerModel *model = self.dataListArray[i];
            
            if ([model.id isEqualToString:year] || [model.name isEqualToString:year]) {
                
                self.selectModel.id =  model.id;
                self.selectModel.name = model.name;
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                break;
            }
        }
    } else {
        self.selectModel = self.dataListArray.firstObject;
    }
    
    if (month.length > 0 && month.integerValue < 13 && month.integerValue > 0) {
        
        for (int i = 0; i < self.subDataListArray.count; i++) {
            
            PickerModel *model = self.subDataListArray[i];
            
            if ([model.id isEqualToString:month] || [model.name isEqualToString:month]) {
                
                self.subSelectModel.id = model.id;
                self.subSelectModel.name = model.name;
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                break;
            }
        }
        
    } else {
        self.subSelectModel = self.subDataListArray.firstObject;
    }
}

#pragma mark - ============== Setter & Getter ================

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray new];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate *dt = [NSDate date];
        NSDateComponents *comp = [gregorian components:NSCalendarUnitYear fromDate:dt];
        NSInteger startYear = comp.year;
        
        // 如果是出生日期 当前年份减去16年
        if (self.type == QDDatePickerViewTypeBirthDate) {
            startYear = startYear - 16;
        }
        // 如果是教育经历结束时间 当前年份加上5年
        // 3.0新增 self.type == QDDatePickerViewTypeEduExpEndYear
        if (self.type == QDDatePickerViewTypeEduExpEndDate || self.type == QDDatePickerViewTypeEduExpEndYear) {
            startYear += 5;
        }
        
        // 结束时间加上至今
        // 3.0新增 self.type == QDDatePickerViewTypeEduExpEndYear
        if (self.type == QDDatePickerViewTypeWorkExpEndDate ||
            self.type == QDDatePickerViewTypeEduExpEndDate ||
            self.type == QDDatePickerViewTypeProjectExpEndDate ||
            self.type == QDDatePickerViewTypeTrainExpEndDate ||
            self.type == QDDatePickerViewTypeEduExpEndYear) {
            PickerModel *model = [[PickerModel alloc] init];
            model.name = @"至今";
            model.id = @"0";
            [_dataListArray addObject:model];
        }
        
        if (self.type == QDDatePickerViewTypeNoLimitDate) {
            PickerModel *model = [[PickerModel alloc] init];
            model.name = @"不限";
            model.id = @"0";
            [_dataListArray addObject:model];
        }
        
        for (int i = 0; i <= 40; i++) {
            PickerModel *model = [[PickerModel alloc] init];
            model.id = [NSString stringWithFormat:@"%ld",(long)(startYear - i)];
            model.name = [NSString stringWithFormat:@"%ld",(long)(startYear - i)];
            [_dataListArray addObject:model];
        }
    }
    return _dataListArray;
}

- (NSMutableArray *)subDataListArray {
    if (!_subDataListArray) {
        _subDataListArray = [NSMutableArray new];
        for (int i = 0; i < 12; i++) {
            PickerModel *model = [[PickerModel alloc] init];
            model.id = [NSString stringWithFormat:@"%d",i+1];
            model.name = [NSString stringWithFormat:@"%d",i+1];
            [_subDataListArray addObject:model];
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

- (UIDatePicker *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] init];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //显示方式是只显示年月日
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        _datePickerView.maximumDate = [NSDate date];
        NSDate *date = [NSDate date];
        //上次设置的日期
        if (self.timeIntervalString.length) {
            date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalString.integerValue];
        }
        // 2.3 将转换后的日期设置给日期选择控件
        [_datePickerView setDate:date animated:YES];
    }
    return _datePickerView;
}

@end
