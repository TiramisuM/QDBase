//
//  UIView+QDGetViewController.m
//  QDBase
//
//  Created by Marvin Liu on 2018/10/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 通过UIResponder获取view的viewController

#import "UIView+QDGetViewController.h"

@implementation UIView (QDGetViewController)

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

@end
