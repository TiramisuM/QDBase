//
//  QDDoublePickerView.h
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义双选pickerView

#import "QDBasePickerView.h"

@interface QDDoublePickerView : QDBasePickerView

/// 双选pickerView block回调
typedef void(^QDDoublePickerBlcok)(PickerModel *model, PickerModel *subPickModel);

/// 双选pickerView类型
typedef NS_ENUM(NSInteger, DoublePickerViewType) {
    /// 工作经验
    DoublePickerViewTypeExpre = 0,
    /// 薪资
    DoublePickerViewTypeSalary = 1,
    /// 年龄，顶部带有不限选项
    DoublePickerViewTypeAge = 2
};


/**
 自定义双选pickerView

 @param from 第一组选项默认值
 @param to 第二组选项默认值
 @param title 标题
 @param type 弹窗滑轮类型 DoublePickerViewType
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showPickerViewWithFrom:(NSString *)from to:(NSString *)to title:(NSString *)title type:(DoublePickerViewType)type pickerBlock:(QDDoublePickerBlcok)pickerBlock;

@end
