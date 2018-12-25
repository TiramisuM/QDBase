//
//  QDSinglePickerView.h
//  QDCommentProject
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义单选picker

#import "QDBasePickerView.h"

@interface QDSinglePickerView : QDBasePickerView

/// 单选pickerView block回调
typedef void(^QDSinglePickerBlock)(PickerModel *model);

/**
 自定义单选pickerView
 
 @param value 默认选中项
 @param title 标题
 @param rowTitleArray 数据源
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showPickerView:(NSString *)value title:(NSString *)title rowTitleArray:(NSArray *)rowTitleArray  pickerBlock:(QDSinglePickerBlock)pickerBlock;

@end
