//
//  QDBaseViewController.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 基类Controller

#import "QDBaseViewController.h"

@interface QDBaseViewController ()<UINavigationControllerDelegate>

/// 网络请求数组
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *URLSessionDataTaskArray;
/// 电池条状态
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// 电池条状态
@property (nonatomic, assign) BOOL statusBarHidden;
/// 当前控制器导航是否隐藏，push新的控制器的时候会给其重新赋值，默认为NO
@property (nonatomic, assign) BOOL navBarHidden;

@end

@implementation QDBaseViewController

#pragma mark - ============== LifeCircle ================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(0xF9F8F8);
    
    // navigationController.delegate是一对一的, push进来需要接管代理
    self.navigationController.delegate = self;
    // 默认刚进入的页面是有navigationBar的
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // navigationController.delegate是一对一的, pop回来需要接管代理
    self.navigationController.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllURLSessionDataTask];
    NSLog(@"\n\n%@ dealloc\n\n", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ============== Data ================
#pragma mark 网络请求方法，需子类实现
- (void)loadData {}
- (void)addMoreData {}
- (void)baseRequestData {}

#pragma mark - ============== Delegate ================
/// navigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果即将显示的控制器不是当前控制器的话，拿到即将显示的控制器的navBarHidden属性，判断显示还是隐藏
    // 如果即将跳转的控制器不是继承基类的话 不做任何处理
    if (viewController != self && [viewController isKindOfClass:[QDBaseViewController class]]) {
        BOOL navBarHidden = [[viewController valueForKey:@"_navBarHidden"] boolValue];
        [viewController.navigationController setNavigationBarHidden:navBarHidden animated:YES];
    }
}

#pragma mark - ============== Action ================
- (void)backPrePage {
    // 判断当前控制器是否在navigation中
    if ([self.navigationController.viewControllers containsObject:self]) {
        // 判断当前是否为rootViewController
        if (self.navigationController.viewControllers.count != 1) {
            // 不是主页面 pop出去
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        // present进来的
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ============== PublicMethod ================
#pragma mark 使用自定义导航条
-(void)useCustomNavigationBarView {
    [self.view addSubview:self.navigationBarView];
    self.navBarHidden = YES;
    self.navigationBarView.viewController = self;
    self.navigationBarView.hidden = NO;
    [self hideNavigationBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark 隐藏导航条
- (void)hideNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    self.navBarHidden = YES;
}

#pragma mark - ============== PrivateMethod ================
#pragma mark 网络请求数组处理
- (void)addURLSessionDataTask:(NSURLSessionDataTask *)URLSessionDataTask {
    if ([URLSessionDataTask isKindOfClass:[NSURLSessionDataTask class]]) {
        [self.URLSessionDataTaskArray addObject:URLSessionDataTask];
    }
}

- (void)removeAllURLSessionDataTask {
    
    for (NSURLSessionDataTask *dataTask in self.URLSessionDataTaskArray) {
        [dataTask cancel];
    }
    [self.URLSessionDataTaskArray removeAllObjects];
}

#pragma mark 状态栏处理
/// 设置状态栏文字颜色为白色
- (void)setStatusBarLight {
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}
/// 设置状态栏文字颜色为黑色
- (void)setStatusBarDefault {
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

#pragma mark - ============== Setter & Getter ================
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self.navigationBarView setTitle:title];
}

- (void)setResponseDataState:(QDNetworkRequstResultState)responseDataState {
    _responseDataState = responseDataState;
    
    // 将当前视图展示的resultView移除
    [self removeResultView];
    
    switch (responseDataState) {
        case QDNetworkRequstResultStateEmpty: {
            [self showEmptyView];
        }
            break;
        case QDNetworkRequstResultStateLoading: {
            [self showLoadingView];
        }
            break;
        case QDNetworkRequstResultStateError: {
            [self showErrorView];
        }
            break;
        case QDNetworkRequstResultStateNoNet: {
            [self showNoNetView];
        }
            break;
        case QDNetworkRequstResultStateSuccess:
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ============== Lazy ================
- (NSMutableArray *)URLSessionDataTaskArray {
    if (!_URLSessionDataTaskArray) {
        _URLSessionDataTaskArray = [NSMutableArray array];
    }
    return _URLSessionDataTaskArray;
}

- (QDNavigationBarView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [QDNavigationBarView navigationBarView];
        _navigationBarView.hidden = YES;
    }
    return _navigationBarView;
}

@end

#pragma mark - ============== 请求页面返回分类 ================
@implementation QDBaseViewController (QDBaseViewControllerRequestResult)

#pragma mark - ============== 请求页面返回样式 ================
- (QDRequestResultView *)showErrorView {
    QDRequestResultView *errorView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateError tap:nil];
    return errorView;
}

- (QDRequestResultView *)showEmptyView {
    QDRequestResultView *emptyView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateEmpty tap:nil];
    return emptyView;
}

- (QDRequestResultView *)showLoadingView {
    QDRequestResultView *loadingView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateLoading tap:nil];
    return loadingView;
}

- (QDRequestResultView *)showNoNetView {
    QDRequestResultView *noNetView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateNoNet tap:nil];
    return noNetView;
}

- (void)configResultView:(QDRequestResultView *)resultView{}

- (void)removeResultView {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[QDRequestResultView class]]) {
            [(QDRequestResultView *)subView hide];
        }
    }
}

- (QDRequestResultView *)showCustomResultViewWithResultState:(QDNetworkRequstResultState)resultState tap:(TapBlock)tapBlock {
    // 如果没传tapBlock则使用tapResultView的回调方法
    if ((!tapBlock) && resultState != QDNetworkRequstResultStateLoading) {
        WS(weakSelf);
        tapBlock = ^{
            [weakSelf tapResultView];
        };
    }
    
    QDRequestResultView *view = [QDRequestResultView resultViewWithResultState:resultState tap:tapBlock];
    [self addResultView:view];
    [self configResultView:view];
    return view;
    
}

- (void)addResultView:(QDRequestResultView *)resultView {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[QDRequestResultView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.view addSubview:resultView];
    [self.view bringSubviewToFront:resultView];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - UI_BOTTOM_SAFE_HEIGHT);
    frame.size.width = kScreenWidth;
    resultView.frame = frame;
}

- (void)tapResultView {
}
- (void)tapInfoBtnInResultView {
}

@end

#pragma mark - ============== 增加导航栏按钮 ================
@implementation QDBaseViewController (QDNavigationBarButtonItem)

- (void)addLeftNavigationButton:(UIButton *)leftNavigationButton {
    [self addLeftNavigationButtons:@[leftNavigationButton]];
}

- (void)addLeftNavigationButtons:(NSArray<UIButton *> *)leftNavigationButtons {
    // 判断当前使用的是自定义导航栏还是默认的导航栏
    if (self.navigationBarView.hidden) {
        // 系统原生导航栏
        NSMutableArray<UIBarButtonItem *> *leftBarButtonItems = [NSMutableArray arrayWithCapacity:leftNavigationButtons.count];
        for (UIButton *button in leftNavigationButtons) {
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [leftBarButtonItems addObject:leftBarButtonItem];
        }
        self.navigationItem.leftBarButtonItems = leftBarButtonItems;
        
    } else {
        [self.navigationBarView addLeftButtons:leftNavigationButtons];
    }
}

- (void)addRightNavigationButton:(UIButton *)rightNavigationButton {
    [self addRightNavigationButtons:@[rightNavigationButton]];
}

- (void)addRightNavigationButtons:(NSArray<UIButton *> *)rightNavigationButtons {
    // 判断当前使用的是自定义导航栏还是默认的导航栏
    if (self.navigationBarView.hidden) {
        // 系统原生导航栏
        NSMutableArray<UIBarButtonItem *> *rightBarButtonItems = [NSMutableArray arrayWithCapacity:rightNavigationButtons.count];
        for (UIButton *button in rightNavigationButtons) {
            UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [rightBarButtonItems addObject:rightBarButtonItem];
        }
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
        
    } else {
        [self.navigationBarView addRightButtons:rightNavigationButtons];
    }
}

@end
