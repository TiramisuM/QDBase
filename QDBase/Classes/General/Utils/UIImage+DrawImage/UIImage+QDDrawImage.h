//
//  UIImage+QDDrawImage.h
//  InsuranceAgentRelation
//
//  Created by Marvin Liu on 2018/12/5.
//  Copyright © 2018 QiaoData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QDDrawImage)

/**
 将文字绘制在图片中心
 
 @param imageName 绘制的背景图片名称
 @param text 文字
 @param textAttributes 字体设置 NSForegroundColorAttributeName, NSFontAttributeName
 @param isCircular 是否圆形
 @return 图片
 */
+ (UIImage *)imageWithBackgroundImageName:(NSString *)imageName text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular;
/**
 将文字绘制在图片中心
 
 @param backgroundImage 绘制的背景图片
 @param text 文字
 @param textAttributes 字体设置 NSForegroundColorAttributeName, NSFontAttributeName
 @param isCircular 是否圆形
 @return 图片
 */
+ (UIImage *)imageWithBackgroundImage:(UIImage *)backgroundImage text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular;

/**
 绘制带边框与纯底色的图片 并将文字绘制在图片中心

 @param fillColor 填充色
 @param strokeColor 边框色
 @param text 文字
 @param textAttributes 字体设置 NSForegroundColorAttributeName, NSFontAttributeName
 @param isCircular 是否圆形
 @return 图片
 */
+ (UIImage *)imageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular;

/**
 根据颜色绘制图片

 @param color 颜色
 @return 返回的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
