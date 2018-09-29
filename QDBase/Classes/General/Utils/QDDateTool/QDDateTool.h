//
//  QDDateTool.h
//  QDBase
//
//  Created by qiaodata100 on 2018/9/26.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 时间管理

#import <Foundation/Foundation.h>

@interface QDDateTool : NSObject

/**
 @brief 根据秒数计算时间，返回固定格式的字符串
 @discussion 根据传入的时间戳计算, 返回固定格式的字符串 格式 (一天之内: 今天HH:MM, 昨天的时间: 昨天HH:MM, 一年之内: MM月dd日 HH:mm, 其他: yyyy年MM月dd日 HH:mm)

 @param timeInterval 时间戳
 @return 返回固定格式的字符串
 */
+ (NSString *)getDateString:(NSTimeInterval)timeInterval;

/**
 计算传入时间与当前时间的时间差， 返回字符串(一周内 一个月内 一个月前 三个月前 六个月前)
 
 @param timeInterval 时间戳
 @return 返回 一周内 | 一个月内 | 一个月前 | 三个月前 | 六个月前
 */
+ (NSString *)getTimeDifferenceWithCurrentTime:(NSTimeInterval)timeInterval;

@end
