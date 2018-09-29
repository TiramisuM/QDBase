//
//  QDDateTool.m
//  QDBase
//
//  Created by qiaodata100 on 2018/9/26.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 时间管理

#import "QDDateTool.h"

@implementation QDDateTool

// 计算时间
+ (NSString *)getDateString:(NSTimeInterval)timeInterval {
    // 单位
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 当前时间
    NSDate *nowDate = [NSDate date];
    NSCalendar *nowGregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowComps = [nowGregorian components:unitFlags fromDate:nowDate];
    // 传入时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    
    if (nowComps.year == comps.year) { // 同一年
        if (nowComps.month == comps.month && nowComps.day == comps.day) { // 今天
            [dateFormatter setDateFormat:@"HH:mm"];
            return [NSString stringWithFormat:@"今天%@",[dateFormatter stringFromDate:date]];
        }
        if (nowComps.month == comps.month && (nowComps.day - 1 == comps.day)) { // 昨天
            [dateFormatter setDateFormat:@"HH:mm"];
            return [NSString stringWithFormat:@"昨天%@",[dateFormatter stringFromDate:date]];
        }
        // 不是今天和昨天，今年的其他时候
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        return [dateFormatter stringFromDate:date];
    } else { // 不同年
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}

+ (NSString *)getTimeDifferenceWithCurrentTime:(NSTimeInterval)timeInterval {
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    double differenceSecond = nowTimeInterval - timeInterval;
    NSInteger dayStamp = 24 * 60 * 60;
    NSInteger dayCount = ((NSInteger)differenceSecond) / dayStamp;
    
    if (dayCount < 7) {
        return @"1周内";
    } else if (dayCount < 30) {
        return @"1个月内";
    } else if (dayCount < 90) {
        return @"1个月前";
    } else if (dayCount < 120) {
        return @"3个月前";
    } else {
        return @"6个月前";
    }
    
}

@end
