//
//  QDDeviceTool.h
//  QDCommentProject
//
//  Created by QiaoData on 2018/9/29.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 设备信息工具类

#import <Foundation/Foundation.h>

@interface QDDeviceTool : NSObject
/**
 获取设备的广告标识 Identifier For Advertising

 @return IDFA String
 */
+ (NSString *)getIDFA;
/**
 Vindor标示符，适用于对内：例如分析用户在应用内的行为等

 @return IDFV String
 */
+ (NSString *)getIDFV;
/**
 获取 MAC 地址

 @return MAC 地址
 */
+ (NSString *)getMAC;
/**
 生成发送网络请求需要的logId

 @return 发送网络请求的logId
 */
+ (NSString *)getLogId;
/**
 拿到手机操作系统的版本号 eg 11.0.1

 @return 系统版本号
 */
+ (NSString *)getSystemVersion;
/**
 当前App的版本号

 @return appVersion
 */

+ (NSString *)getAppVersion;

/**
 获取屏幕安全区域

 @return 安全区域 UIEdgeInsets
 */
+ (UIEdgeInsets)getSafeAreaInset;
@end
