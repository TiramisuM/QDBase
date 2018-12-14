//
//  QDNavigationViewController.m
//  QDBase
//
//  Created by QiaoData on 2018/9/13.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 基类导航栏

#import "QDNavigationViewController.h"

@interface QDNavigationViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation QDNavigationViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    //设置字体与颜色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromHex(0x333333),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil]];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}

#pragma mark - ============== Action ================
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // push的时候会隐藏底部的tabBar。
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self creatBackBtn];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backPrePage {
    [self popViewControllerAnimated:YES];
}

#pragma mark - ============== PrivateMethod ================

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

#pragma mark - ============== 创建返回按钮 ================

- (UIBarButtonItem *)creatBackBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backPrePage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return barBtn;
}

#pragma mark - ============== Setter & Getter ================

#pragma mark - UIGestureRecognizerDelegate
/// 防止viewcontroller在根视图的时候左滑出现无法点击push的问题
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

@end
