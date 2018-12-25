//
//  QDSinglePickerView.m
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义单选picker

#import "QDSinglePickerView.h"

@interface QDSinglePickerView ()

@property (nonatomic, copy) QDSinglePickerBlock pickerBlock;

@property (nonatomic, strong) PickerModel *selectModel;

@property (nonatomic, strong) NSArray *dataListArray;

@end

@implementation QDSinglePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        self.sureBtnActionBlock = ^(){
            
            if (weakSelf.pickerBlock) {
                weakSelf.pickerBlock(weakSelf.selectModel);
            }
        };
    }
    return self;
}
/**
 自定义单选picker
 
 @param value 默认选中项
 @param title 标题
 @param rowTitleArray 数据源
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showPickerView:(NSString *)value title:(NSString *)title rowTitleArray:(NSArray *)rowTitleArray pickerBlock:(QDSinglePickerBlock)pickerBlock {
    
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (int i = 0; i < rowTitleArray.count; i++)
    {
        PickerModel *model = [[PickerModel alloc] init];
        model.id = [NSString stringWithFormat:@"%d",i];
        model.name = rowTitleArray[i];
        [dataList addObject:model];
    }
    
    QDSinglePickerView *pickerView = [[QDSinglePickerView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    pickerView.pickerBlock = pickerBlock;
    pickerView.dataListArray = dataList;
    [pickerView changePickerViewTitle:title];
    [UIApplication.sharedApplication.keyWindow addSubview:pickerView];
    
    [pickerView.pickerView reloadAllComponents];
    
    if (value.length != 0) {
        
        BOOL haveValue = NO;
        for (int i = 0; i < pickerView.dataListArray.count; i++) {
            
            PickerModel *model = pickerView.dataListArray[i];
            
            if ([model.name isEqualToString:value] || [model.id isEqualToString:value]) {
                
                haveValue = YES;
                pickerView.selectModel.name = model.name;
                pickerView.selectModel.id = model.id;
                [pickerView.pickerView selectRow:i inComponent:0 animated:YES];
                [pickerView pickerView:pickerView.pickerView didSelectRow:i inComponent:0];
                break;
            }
        }
        if (!haveValue) {
            pickerView.selectModel = pickerView.dataListArray.firstObject;
        }
        
    } else {
        pickerView.selectModel = pickerView.dataListArray.firstObject;
    }
}

#pragma mark - ============== DataSource & Delegate ================

/// 指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataListArray.count;
}

/// 指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PickerModel *model = self.dataListArray[row];
    return model.name;
}

/// 选中某行后回调的方法，获得选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectModel = self.dataListArray[row];
}

#pragma mark - ============== Setter & Getter ================

- (NSArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = [[NSArray alloc] init];
    }
    return _dataListArray;
}

- (PickerModel *)selectModel {
    if (!_selectModel) {
        _selectModel = [[PickerModel alloc]init];
    }
    return _selectModel;
}
@end
