//
//  UIView+QDFastFrame.h
//  QDBase
//
//  Created by QiaoData on 2018/9/27.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 快速设置frame

#import <UIKit/UIKit.h>

@interface UIView (QDFastFrame)

///快速设置 frame.origin.x.
@property (nonatomic, assign) CGFloat left;
///快速设置 frame.origin.x.
@property (nonatomic, assign) CGFloat x;
///快速设置 frame.origin.y
@property (nonatomic, assign) CGFloat top;
///快速设置 frame.origin.y
@property (nonatomic, assign) CGFloat y;
///快速设置 frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat right;
///快速设置 frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat bottom;
///快速设置 frame.size.width.
@property (nonatomic, assign) CGFloat width;
///快速设置 frame.size.height.
@property (nonatomic, assign) CGFloat height;
///快速设置 center.x
@property (nonatomic, assign) CGFloat centerX;
///快速设置 center.y
@property (nonatomic, assign) CGFloat centerY;
///快速设置 frame.origin.
@property (nonatomic, assign) CGPoint origin;
///快速设置 frame.size.
@property (nonatomic, assign) CGSize  size;


@end
