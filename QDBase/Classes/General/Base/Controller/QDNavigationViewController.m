//
//  QDNavigationViewController.m
//  QDBase
//
//  Created by qiaodata100 on 2018/9/13.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 基类导航栏

#import "QDNavigationViewController.h"

@interface QDNavigationViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation QDNavigationViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}

#pragma mark - ============== Action ================
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // push的时候会隐藏底部的tabBar。
    if (self.viewControllers.count > 0) {
        
        viewController.navigationItem.leftBarButtonItems = [self createBackButton];
        viewController.hidesBottomBarWhenPushed = YES;
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

#pragma mark - ============== Setter & Getter ================
- (NSArray<UIBarButtonItem *> *)createBackButton {
    
    CGRect backButtonFrame = CGRectMake(0, 0, 40, 40);
    UIButton *backButton = [QDFactory createButtonWithFrame:backButtonFrame imageName:@"left" highlightedImageName:@"" target:self action:@selector(backPrePage)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;//这个值可以根据自己需要自己调整
    // iOS 11 系统，将Button的内容 和 图片根具体需求进行便处理
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    return @[spaceItem, backItem];
}

@end
