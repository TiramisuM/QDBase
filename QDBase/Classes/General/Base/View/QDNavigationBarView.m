//
//  QDNavigationBarView.m
//  QDBase
//
//  Created by QiaoData on 2018/9/13.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 自定义导航条

#define SideMargin 15

#import "QDNavigationBarView.h"

typedef NS_ENUM(NSInteger, EnterMethod) {
    /// push方式
    EnterMethodPush,
    /// present方式
    EnterMethodPresent,
    /// 主页面 不是enter进来的
    EnterMethodNoEnter
};

@interface QDNavigationBarView ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) EnterMethod enterMethod;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *leftCloseButton;
@property (nonatomic, strong) UIButton *rightCloseButton;

// 导航条左侧按钮
@property (nonatomic, strong) NSMutableArray *leftNavigationButtons;
// 导航条右侧按钮
@property (nonatomic, strong) NSMutableArray *rightNavigationButtons;

@end

@implementation QDNavigationBarView

+ (instancetype)navigationBarViewWithViewController:(UIViewController *)viewController {
    QDNavigationBarView *navigationBarView = [[QDNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT)];
    navigationBarView.viewController = viewController;
    return navigationBarView;
    
}

- (void)setViewController:(UIViewController *)viewController {
    _viewController = viewController;
    // 判断当前控制器是否在navigation中
    if ([viewController.navigationController.viewControllers containsObject:viewController]) {
        // 判断当前是否为rootViewController
        if (viewController.navigationController.viewControllers.count == 1) {
            self.enterMethod = EnterMethodNoEnter;
        } else {
            // push进来的
            self.enterMethod = EnterMethodPush;
        }
    } else {
        // present进来的
        self.enterMethod = EnterMethodPresent;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.backgroundColor = [UIColor whiteColor];
    
    // titleLabel
    CGRect titleLabelFrame = CGRectMake(30, UI_STATUS_BAR_HEIGHT, kScreenWidth - 30 * 2, UI_NAVIGATION_BAR_HEIGHT);
    self.titleLabel.frame = titleLabelFrame;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    // lineView
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 1, kScreenWidth, 1)];
    self.lineView.backgroundColor = UIColorFromHex(0xF5F5F5);
    [self addSubview:self.lineView];
    
    // leftButton
    CGRect leftButtonFrame = CGRectMake(0, UI_STATUS_BAR_HEIGHT - 5, 35, 55);
    self.leftButton.frame = leftButtonFrame;
    self.leftButton.centerY = UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT;
    [self addSubview:self.leftButton];
    [self.leftNavigationButtons addObject:self.leftButton];
    
    // leftCloseButton
    CGRect leftCloseButtonFrame = CGRectMake(0, UI_STATUS_BAR_HEIGHT, 50, UI_NAVIGATION_BAR_HEIGHT);
    self.leftCloseButton.frame = leftCloseButtonFrame;
    self.leftCloseButton.centerY = UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT;
    [self addSubview:self.leftCloseButton];
    [self.leftNavigationButtons addObject:self.leftCloseButton];
    
    // rightCloseButton
    CGRect rightButtonFrame = CGRectMake(kScreenWidth - 50 , UI_STATUS_BAR_HEIGHT - 5, 50, 55);
    self.rightCloseButton.frame = rightButtonFrame;
    self.rightCloseButton.centerY = UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT;
    [self addSubview:self.rightCloseButton];
    [self.rightNavigationButtons addObject:self.rightCloseButton];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 根据当前页面的进入方式选择按钮的显示和隐藏
    if (self.enterMethod == EnterMethodPresent) {
        self.leftButton.hidden = YES;
        self.leftCloseButton.hidden = YES;
        self.rightCloseButton.hidden = NO;
    } else if (self.enterMethod == EnterMethodPush) {
        self.leftButton.hidden = NO;
        self.leftCloseButton.hidden = YES;
        self.rightCloseButton.hidden = YES;
    } else {
        self.leftButton.hidden = YES;
        self.leftCloseButton.hidden = YES;
        self.rightCloseButton.hidden = YES;
    }
    
    self.titleLabel.center = CGPointMake(self.center.x, UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT);
    // 先计算titleLabel的最小X
    CGFloat titleMinX = SideMargin;
    for (UIButton *leftButton in self.leftNavigationButtons) {
        if (!leftButton.hidden) {
            titleMinX = leftButton.right + 5;
        }
    }
    
    // 再计算titleLabel的最大的X
    CGFloat titleMaxX = kScreenWidth - SideMargin;
    for (UIButton *rightButton in self.rightNavigationButtons) {
        if (!rightButton.hidden) {
            titleMaxX = rightButton.x - 5;
        }
    }
    
    if (self.titleLabel.x < titleMinX) {
        // 先优先向右偏移
        self.titleLabel.x = titleMinX;
        // 现有titleLabel的最大X如果大于限定宽度，则将其设置为限定宽度
        if (self.titleLabel.right >= titleMaxX) {
            self.titleLabel.width = titleMaxX - titleMinX;
        }
    } else {
        // 判断当前titleLabel是否需要向左偏移
        if (self.titleLabel.right > titleMaxX) {
            // 需要向左偏移
            // 判断当前的限定宽度是否大于目前titleLabel的限定宽度
            if (titleMaxX - titleMinX > self.titleLabel.width) {
                // 当前的限定宽度大于目前titleLabel的限定宽度 直接向左偏移
                self.titleLabel.right = titleMaxX;
            }  else {
                // 当前的限定宽度大于目前titleLabel的限定宽度 先固定左边，然后将宽度设置为限定宽度
                self.titleLabel.x = titleMinX;
                self.titleLabel.width = titleMaxX - titleMinX;
                
            }
        } else {
            // 不需要向左偏移 当前titleLabel不用动
        }
    }
}

- (void)backPrePage {
    if (self.enterMethod == EnterMethodPresent) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    } else if (self.enterMethod == EnterMethodPush) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self setNeedsDisplay];
}

#pragma mark - 生成导航按钮
- (void)addLeftButton:(UIButton *)leftButton {
    [self addLeftButtons:@[leftButton]];
}

- (void)addLeftButtons:(NSArray<UIButton *> *)leftNavigationButtons {
    // 移除现有数组
    [self removeNavigationButtons:self.leftNavigationButtons];
    
    CGFloat buttonX = SideMargin;
    for (UIButton *leftButton in leftNavigationButtons) {
        
        CGFloat leftButtonW = leftButton.width;
        if (leftButtonW == 0) {
            [leftButton sizeToFit];
            leftButtonW = leftButton.width;
        }
        leftButton.x = buttonX;
        leftButton.centerY = UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT;
        buttonX += leftButtonW + 5;
        
        [self addSubview:leftButton];
        [self.leftNavigationButtons addObject:leftButton];
    }
    // 重绘
    [self setNeedsDisplay];
}

- (void)addRightButton:(UIButton *)rightButton {
    [self addRightButtons:@[rightButton]];
}

- (void)addRightButtons:(NSArray<UIButton *> *)rightNavigationButtons {
    // 移除现有数组
    [self removeNavigationButtons:self.rightNavigationButtons];
    
    CGFloat buttonRight = kScreenWidth - SideMargin;
    
    for (UIButton *rightButton in rightNavigationButtons) {
        
        CGFloat rightButtonW = rightButton.width;
        if (rightButtonW == 0) {
            [rightButton sizeToFit];
            rightButtonW = rightButton.width;
        }
        
        rightButton.right = buttonRight;
        rightButton.centerY = UI_NAVIGATION_BAR_HEIGHT / 2 + UI_STATUS_BAR_HEIGHT;
        buttonRight -= rightButtonW + 5;
        
        [self addSubview:rightButton];
        [self.rightNavigationButtons addObject:rightButton];
    }
    
    [self setNeedsDisplay];
}

- (void)removeNavigationButtons:(NSMutableArray *)navigationButtons {
    // 清空现有数组
    for (UIButton *button in navigationButtons) {
        [button removeFromSuperview];
    }
    [navigationButtons removeAllObjects];
}

#pragma mark - Lazy Load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [QDFactory createLabelWithFrame:CGRectZero
                                                 text:@"测试"
                                            textColor:[UIColor blackColor]
                                                 font:[UIFont boldSystemFontOfSize:17]
                                        textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [QDFactory createButtonWithFrame:CGRectZero
                                             imageName:@"left"
                                  highlightedImageName:@""
                                                target:self
                                                action:@selector(backPrePage)];
    }
    return _leftButton;
}

- (UIButton *)leftCloseButton {
    if (!_leftCloseButton) {
        _leftCloseButton = [QDFactory createButtonWithFrame:CGRectZero
                                                  imageName:@"小关闭"
                                       highlightedImageName:@""
                                                     target:self
                                                     action:@selector(backPrePage)];
    }
    return _leftCloseButton;
}

- (UIButton *)rightCloseButton {
    if (!_rightCloseButton) {
        _rightCloseButton = [QDFactory createButtonWithFrame:CGRectZero
                                                   imageName:@"close_02"
                                        highlightedImageName:@""
                                                      target:self
                                                      action:@selector(backPrePage)];
    }
    return _rightCloseButton;
}

- (NSMutableArray *)leftNavigationButtons {
    if (!_leftNavigationButtons) {
        _leftNavigationButtons = [NSMutableArray arrayWithCapacity:2];
    }
    return _leftNavigationButtons;
}

- (NSMutableArray *)rightNavigationButtons {
    if (!_rightNavigationButtons) {
       _rightNavigationButtons = [NSMutableArray arrayWithCapacity:2];
    }
    return _rightNavigationButtons;
}

@end
