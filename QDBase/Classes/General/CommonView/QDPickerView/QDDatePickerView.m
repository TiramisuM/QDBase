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

@property (nonatomic, assign) DatePickerViewType type;
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
 @param mouth 月份默认值
 @param title 标题
 @param type 弹窗滑轮类型 DatePickerViewType
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showDatePickerViewWithYear:(NSString *)year mouth:(NSString *)mouth title:(NSString *)title type:(DatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock {
    
    QDDatePickerView *pickerView = [[QDDatePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.pickerBlock = pickerBlock;
    pickerView.type = type;
    [pickerView changePickerViewTitle:title];
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    [pickerView prefillDateWithYear:year mouth:mouth];
}

/**
 弹出系统原生datePickerView
 
 @param title 标题
 @param pickerBlock 确认按钮点击回调 返回NSDate
 */
+ (void)showSystemDatePickerViewWithTitle:(NSString *)title pickerBlock:(void(^)(NSDate *date))pickerBlock {
    
    QDDatePickerView *pickerView = [[QDDatePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.datePickerBlock = pickerBlock;
    [pickerView changePickerViewTitle:title];
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    __block UIView *spanView = pickerView.pickerView.superview;
    CGFloat top = ToolBarHieght;
    [pickerView.pickerView removeFromSuperview];
    [spanView addSubview:pickerView.datePickerView];
    
    [pickerView.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(spanView);
        make.top.equalTo(spanView).offset(top);
    }];
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

/// 更新SubDataList数据
- (void)updateSubDataList:(PickerModel *)model {
    
    [self.subDataListArray removeAllObjects];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *nowDate = [NSDate date];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:nowDate];
    
    if ([self.selectModel.name isEqualToString:@"至今"] || [self.selectModel.name isEqualToString:@"不限"]) {
                
    } else if ([self.selectModel.name isEqualToString:[NSString stringWithFormat:@"%ld",(long)comp.year]] &&
             self.type != DatePickerViewTypeEduExperEndDate){

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
- (void)prefillDateWithYear:(NSString *)year mouth:(NSString *)mouth {
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *dt = [NSDate date];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dt];
    
    if (self.type != DatePickerViewTypeBirthDate) {
        if (judgeString(year).length == 0 || year.length < 4 || year.integerValue < (comp.year - 50) || year.integerValue > (comp.year + 50)) {
            year = [NSString stringWithFormat:@"%ld",(long)comp.year];
        }
        if (judgeString(mouth).length == 0 || mouth.integerValue <= 0 || mouth.integerValue > 12) {
            mouth = [NSString stringWithFormat:@"%ld",(long)comp.month];
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
    
    if (mouth.length > 0 && mouth.integerValue < 13 && mouth.integerValue > 0) {
        
        for (int i = 0; i < self.subDataListArray.count; i++) {
            
            PickerModel *model = self.subDataListArray[i];
            
            if ([model.id isEqualToString:mouth] || [model.name isEqualToString:mouth]) {
                
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
        if (self.type == DatePickerViewTypeBirthDate) {
            startYear = startYear - 16;
        }
        // 如果是教育经历结束时间 当前年份加上5年
        if (self.type == DatePickerViewTypeEduExperEndDate) {
            startYear += 5;
        }
        
        // 结束时间加上至今
        if (self.type == DatePickerViewTypeWorkExperEndDate ||
            self.type == DatePickerViewTypeEduExperEndDate ||
            self.type == DatePickerViewTypeProjectExperEndDate ||
            self.type == DatePickerViewTypeTrainExperEndDate) {
            PickerModel *model = [[PickerModel alloc] init];
            model.name = @"至今";
            model.id = @"0";
            [_dataListArray addObject:model];
        }
        
        if (self.type == DatePickerViewTypeNoLimitDate) {
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
    }
    return _datePickerView;
}

@end
