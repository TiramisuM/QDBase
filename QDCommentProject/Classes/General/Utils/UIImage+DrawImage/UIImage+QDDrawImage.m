//
//  UIImage+QDDrawImage.m
//  InsuranceAgentRelation
//
//  Created by Marvin Liu on 2018/12/5.
//  Copyright © 2018 QiaoData. All rights reserved.
//

#import "UIImage+QDDrawImage.h"

@implementation UIImage (QDDrawImage)

///  绘制图片
+ (UIImage *)imageWithBackgroundImageName:(NSString *)imageName text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular {
    return [self imageWithBackgroundImage:[UIImage imageNamed:imageName] text:text textAttributes:textAttributes circular:isCircular];
}

///  绘制图片
+ (UIImage *)imageWithBackgroundImage:(UIImage *)backgroundImage text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular {
    
    UIImage *nonHeaderImage = backgroundImage;
    CGSize size = nonHeaderImage.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [nonHeaderImage drawAtPoint:CGPointZero];
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 绘制带边框与纯底色的图片 并将文字绘制在图片中心
 */
+ (UIImage *)imageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor text:(NSString *)text textAttributes:(NSDictionary *)textAttributes circular:(BOOL)isCircular {
    
    CGSize size = CGSizeMake(50, 50);
    CGRect rect = CGRectMake(0, 0, size.width + 2, size.height + 2);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 填充
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    // 圆角
    if (isCircular) {
        // 画笔线的颜色
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        // 描边宽度
        CGContextSetLineWidth(context, 1.0);
        // 添加一个圆圈
        CGContextAddArc(context, size.width/2.0 + 1, size.width/2.0 + 1, size.width/2.0, 0, 2 * M_PI, 0);
        // kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
        CGContextDrawPath(context, kCGPathFillStroke);
    } else {
        
        CGContextFillRect(context, rect);
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextStrokeRect(context, rect);
    }
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2.0 + 1, (size.height - textSize.height) / 2.0 + 1, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 根据图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end
