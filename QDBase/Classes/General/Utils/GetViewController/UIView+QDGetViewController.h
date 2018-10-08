//
//  UIView+QDGetViewController.h
//  QDBase
//
//  Created by Marvin Liu on 2018/10/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 通过UIResponder获取view的viewController

#import <UIKit/UIKit.h>

@interface UIView (QDGetViewController)

/**
 通过UIResponder获取view的viewController

 @return UIViewController
 */
- (UIViewController *)viewController;

@end
