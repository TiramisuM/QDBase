//
//  QDBaseViewController.m
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 基类Controller

#import "QDBaseViewController.h"
#import "QDNavigationBarView.h"

@interface QDBaseViewController ()

/// 网络请求数组
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *URLSessionDataTaskArray;
/// 自定义导航样式
@property (nonatomic, strong) QDNavigationBarView *navigationBarView;
/// 电池条状态
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// 电池条状态
@property (nonatomic, assign) BOOL statusBarHidden;

@end

@implementation QDBaseViewController

#pragma mark - ============== LifeCircle ================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self removeAllURLSessionDataTask];
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

#pragma mark - ============== PrivateMethod ================
#pragma mark 使用自定义导航条
-(void)useCustomNavigation {
    [self.view addSubview:self.navigationBarView];
    self.navigationBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

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
        _navigationBarView = [QDNavigationBarView navigationBarViewWithViewController:self];
        _navigationBarView.hidden = YES;
    }
    return _navigationBarView;
}

@end

#pragma mark - ============== 请求页面返回分类 ================
@implementation QDBaseViewController (QDBaseViewControllerRequestResult)

#pragma mark - ============== 请求页面返回样式 ================
- (QDRequestResultView *)showErrorView {
    QDRequestResultView *errorView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateError tap:nil info:nil];
    return errorView;
}

- (QDRequestResultView *)showEmptyView {
    QDRequestResultView *emptyView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateEmpty tap:nil info:nil];
    return emptyView;
}

- (QDRequestResultView *)showLoadingView {
    QDRequestResultView *loadingView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateLoading tap:nil info:nil];
    return loadingView;
}

- (QDRequestResultView *)showNoNetView {
    QDRequestResultView *noNetView = [self showCustomResultViewWithResultState:QDNetworkRequstResultStateNoNet tap:nil info:nil];
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

- (QDRequestResultView *)showCustomResultViewWithResultState:(QDNetworkRequstResultState)resultState tap:(TapBlock)tapBlock info:(InfoBlock)infoBlock {
    // 如果没传tapBlock则使用tapResultView的回调方法
    if ((!tapBlock) && resultState != QDNetworkRequstResultStateLoading) {
        tapBlock = ^{
            [self tapResultView];
        };
    }
    if (resultState == QDNetworkRequstResultStateEmpty) {
        infoBlock = ^{
            [self tapInfoBtnInResultView];
        };
    }
    QDRequestResultView *view = [QDRequestResultView resultViewWithResultState:resultState tap:tapBlock];
    view.infoBlock = infoBlock;
    [self configResultView:view];
    [self addResultView:view];
    return view;
    
}

- (void)addResultView:(QDRequestResultView *)resultView {
    [self.view addSubview:resultView];
    [self.view bringSubviewToFront:resultView];
    CGRect frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT, kScreenWidth, kScreenHeight - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_BOTTOM_SAFE_HEIGHT);
    frame.size.width = kScreenWidth;
    resultView.frame = frame;
}

- (void)tapResultView {}
- (void)tapInfoBtnInResultView {}

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
