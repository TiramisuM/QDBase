//
//  QDDatePicker.h
//  QDBase
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 自定义时间pickerView

#import "QDBasePickerView.h"

/// DatePickerView类型
typedef NS_ENUM(NSInteger, QDDatePickerViewType) {
    /// 默认时间
    QDDatePickerViewTypeNormalDate = 0,
    /// 默认时间,顶部带有不限选项
    
    QDDatePickerViewTypeNoLimitDate = 1,
    /// 出生日期
    QDDatePickerViewTypeBirthDate = 2,
    
    /// 工作经历开始时间
    QDDatePickerViewTypeWorkExpStartDate = 3,
    /// 工作经历结束时间
    QDDatePickerViewTypeWorkExpEndDate = 4,
    
    /// 教育经历开始时间
    QDDatePickerViewTypeEduExpStartDate = 5,
    /// 教育经历结束时间
    QDDatePickerViewTypeEduExpEndDate = 6,
    
    /// 项目经验开始时间
    QDDatePickerViewTypeProjectExpStartDate = 7,
    /// 项目经验结束时间
    QDDatePickerViewTypeProjectExpEndDate = 8,
    
    /// 培训经历开始时间
    QDDatePickerViewTypeTrainExpStartDate = 9,
    /// 培训经历结束时间
    QDDatePickerViewTypeTrainExpEndDate = 10,
    
    /// 教育经历开始时间-仅年份
    QDDatePickerViewTypeEduExpStartYear = 11,
    /// 教育经历结束时间-仅年份
    QDDatePickerViewTypeEduExpEndYear = 12,
};

@interface QDDatePickerView : QDBasePickerView

/// 默认的时间戳字符串
@property (nonatomic, strong) NSString *timeIntervalString;
/// DatePickerView block回调
typedef void(^QDDatePickerBlcok)(PickerModel *model, PickerModel *subPickerModel);
/// 取消按钮的点击回调
typedef void(^QDDatePickerCancelBlock)(void);
/**
 自定义DatePickerView
 
 @param year 年份默认值
 @param month 月份默认值
 @param title 标题
 @param type 弹窗滑轮类型 QDDatePickerViewType
 @param pickerBlock 确认按钮点击回调
 */
+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock;
/**
 自定义DatePickerView
 
 @param year 年份默认值
 @param month 月份默认值
 @param title 标题
 @param type 弹窗滑轮类型 QDDatePickerViewType
 @param pickerBlock 确认按钮点击回调
 @param cancelBlock 取消按钮的点击回调
 */
+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock;
/**
 自定义DatePickerView
 
 @param year 年份默认值
 @param month 月份默认值
 @param title 标题
 @param sureTitle 确认按钮的标题
 @param cancelTitle 取消按钮的标题
 @param type 弹窗滑轮类型 QDDatePickerViewType
 @param pickerBlock 确认按钮点击回调
 @param cancelBlock 取消按钮的点击回调
 */
+ (void)showDatePickerViewWithYear:(NSString *)year month:(NSString *)month title:(NSString *)title sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle type:(QDDatePickerViewType)type pickerBlock:(QDDatePickerBlcok)pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock;

/**
 弹出系统原生datePickerView
 
 @param title 标题
 @param pickerBlock 确认按钮点击回调 返回NSDate
 @return 系统原生datePickerView
 */
+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title pickerBlock:(void(^)(NSDate *date))pickerBlock;
/**
 弹出系统原生datePickerView
 
 @param title 标题
 @param pickerBlock 确认按钮点击回调 返回NSDate
 @param cancelBlock 取消按钮的点击回调
 @return 系统原生datePickerView
 */
+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title pickerBlock:(void(^)(NSDate *date))pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock;
/**
 弹出系统原生datePickerView
 
 @param title 标题
 @param sureTitle 确认按钮的标题
 @param cancelTitle 取消按钮的标题
 @param timeString 初始值时间戳字符串，以秒为单位
 @param pickerBlock 确认按钮点击回调 返回NSDate
 @param cancelBlock 取消按钮的点击回调
 @return 系统原生datePickerView
 */
+ (QDDatePickerView *)showSystemDatePickerViewWithTitle:(NSString *)title sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle timeIntervalString:(NSString *)timeString pickerBlock:(void(^)(NSDate *date))pickerBlock cancelBlock:(QDDatePickerCancelBlock)cancelBlock;

@end
