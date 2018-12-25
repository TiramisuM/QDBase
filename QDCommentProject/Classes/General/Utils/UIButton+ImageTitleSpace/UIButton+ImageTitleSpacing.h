//
//  UIButton+ImageTitleSpacing.h
//  
//
//  Created by 刘明明 on 2017/1/11.
//  Copyright © 2017年 contractage. All rights reserved.
/// 调整UIButton中按钮与图片的位置

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    /// image在上，label在下
    MKButtonEdgeInsetsStyleTop,
    /// image在左，label在右
    MKButtonEdgeInsetsStyleLeft,
    /// image在下，label在上
    MKButtonEdgeInsetsStyleBottom,
    /// image在右，label在左
    MKButtonEdgeInsetsStyleRight
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style;

- (UITableViewCell *)nextTableViewCell;

@end
