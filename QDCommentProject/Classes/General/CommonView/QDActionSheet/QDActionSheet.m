//
//  HSActionSheet.m
//  HSNews
//
//  Created by Joychen on 15/3/3.
//  Copyright (c) 2016年 Joychen. All rights reserved.
//

#import "QDActionSheet.h"

@interface QDActionSheet ()

@property (strong, nonatomic) UIView *sheetView;
@property (nonatomic, strong) UIScrollView *backScrollView;

@property (nonatomic, assign) NSInteger actionSheetHeight;
@property (nonatomic, assign) NSInteger buttonTagIndex;

@property (assign, nonatomic) BOOL isHadTitle;
@property (assign, nonatomic) BOOL isHadDestructionButton;
@property (assign, nonatomic) BOOL isHadOtherButton;
@property (assign, nonatomic) BOOL isHadCancelButton;

@end

@implementation QDActionSheet

/// QDActionSheetButton 样式
typedef NS_ENUM(NSInteger, DTActionSheetButtonType){
    /// 默认正常类型
    DTActionSheetButtonNormal  = 0,
    /// 具有破坏性的类型
    DTActionSheetButtonDestructive,
    /// 取消类型
    DTActionSheetButtonCancel,
};

// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// UIColor宏定义
#define UIColorFromHexA(hexValue, alphaValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]
// UIColor宏定义
#define UIColorFromHex(hexValue) UIColorFromHexA(hexValue, 1.0)

#define LABEL_HEIGHT        30
#define BUTTON_HEIGHT       56
#define CANCEL_HEIGHT       48
#define ANIMATE_DURATION    0.25f
// 取消按钮tag
#define CANCEL_BUTTON_TAG   10000

#pragma mark - ============== 初始化 ActionSheet ================

/// 不带图标的ActionSheet
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray {
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle
             destructionButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
    }
    return self;
}

/// 带图标的ActionSheet
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray otherButtonIconArray:(NSArray *)otherButtonIconArray {
    
    self = [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
    
    if (otherButtonIconArray) {
        [self setActionSheetImages:otherButtonIconArray];
    }
    return self;
}

/// 创建ActionSheet 按钮
- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructionButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray {
    
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;
    
    _actionSheetHeight = 0; // 初始化ActionSheet的高度为0
    _buttonTagIndex = 100;    // 初始化IndexNumber为100
    
    UIFont *font = [UIFont systemFontOfSize:15];
    //    UIColor *color = HSRGBColor(33, 33, 33, 1);
    
    self.sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
    self.sheetView.backgroundColor = UIColorFromHex(0xf5f5f5);
    self.sheetView.tag = 1000;
    [self addSubview:self.sheetView];
    
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.backScrollView.scrollEnabled = NO;
    self.backScrollView.bounces = NO;
    self.backScrollView.backgroundColor = UIColorFromHex(0xf5f5f5);
    self.backScrollView.tag = 2000;
    [self.sheetView addSubview:self.backScrollView];
    
    if (title) {
        UILabel *titleLabel = [self createLabelWithTitle:title];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.tag = 1002;
        _actionSheetHeight = titleLabel.bounds.size.height;
        [self.sheetView addSubview:titleLabel];
        self.isHadTitle = YES;
    }
    
    if (destructiveButtonTitle) {
        self.isHadDestructionButton = YES;
        
        UIButton *destructiveButton = [self createButtonWithTitle:destructiveButtonTitle type:DTActionSheetButtonDestructive];
        [destructiveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        destructiveButton.titleLabel.font = font;
        destructiveButton.tag = _buttonTagIndex;
        [self.backScrollView addSubview:destructiveButton];
        
        _buttonTagIndex ++;
        _actionSheetHeight += destructiveButton.bounds.size.height + 1.5;
    }
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            
            for (NSString *title in otherButtonTitlesArray) {
                UIButton *otherButton = [self createButtonWithTitle:title type:DTActionSheetButtonNormal];
                otherButton.tag = _buttonTagIndex;
                otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
                otherButton.backgroundColor = [UIColor whiteColor];
                [self.backScrollView addSubview:otherButton];
                _buttonTagIndex ++;
                _actionSheetHeight += otherButton.bounds.size.height + 1.5;
            }
        }
        self.backScrollView.height = _actionSheetHeight - self.backScrollView.top;
    }
    
    if (cancelButtonTitle) {
        _actionSheetHeight += 8.5;
        
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self createButtonWithTitle:cancelButtonTitle type:DTActionSheetButtonCancel];
        cancelButton.tag = _buttonTagIndex;
        cancelButton.titleLabel.font = font;
        cancelButton.backgroundColor = [UIColor whiteColor];
        cancelButton.tag = CANCEL_BUTTON_TAG;
        [cancelButton setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [self.sheetView addSubview:cancelButton];
        
        _actionSheetHeight += cancelButton.bounds.size.height;
    }
    
    if (_actionSheetHeight > kScreenHeight - 100) {
        self.backScrollView.scrollEnabled = YES;
        self.backScrollView.contentSize = CGSizeMake(0, self.backScrollView.height);
        _actionSheetHeight = kScreenHeight - 100;
        
        CGFloat scrolllViewHeight = _actionSheetHeight;
        
        if (self.isHadCancelButton) {
            UIButton *cancelButton = [self.sheetView viewWithTag:CANCEL_BUTTON_TAG];
            cancelButton.top = _actionSheetHeight - BUTTON_HEIGHT;
            scrolllViewHeight = scrolllViewHeight - BUTTON_HEIGHT - 10;
        }
        self.backScrollView.height = scrolllViewHeight;
    }
}

#pragma mark - ============== Action ================
/// 展示ActionSheet
- (void)showInView:(UIView *)view {
    
    if (view) {
        [view addSubview:self];
    }else{
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        [appWindow addSubview:self];
    }
    
    [self showActionSheet];
}

- (void)buttonAction:(UIButton *)button {
    
    if (self.isHadDestructionButton == YES) {
        if (self.delegate && button.tag == 100) {
            if ([self.delegate respondsToSelector:@selector(didClickOnDestructiveButton)]) {
                [self.delegate didClickOnDestructiveButton];
            }
        }
    }
    
    if (self.isHadCancelButton == YES) {
        if (self.delegate && button.tag == CANCEL_BUTTON_TAG) {
            if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)]) {
                [self.delegate didClickOnCancelButton];
                
            }
        }
    }
    
    if (button.tag == CANCEL_BUTTON_TAG) {
        if (self.cancelButtonClick) {
            self.cancelButtonClick();
        }
        [self hiddenActionSheet];
        return;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didClickOnButtonIndex:)]) {
            [self.delegate didClickOnButtonIndex:button.tag];
        }
    }
    if (self.actionSheetClick) {
        self.actionSheetClick(button.tag - 100);
    }
    [self hiddenActionSheet];
}

/// Show/Hidden ActionSheet
- (void)showActionSheet {
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        CGRect frame = self.sheetView.frame;
        frame.origin.y = kScreenHeight - self.actionSheetHeight;
        frame.size.height = self.actionSheetHeight;
        self.sheetView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)hiddenActionSheet {
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.sheetView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

/// UIControl touch event
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self hiddenActionSheet];
}

#pragma mark - ============== ActionSheet 赋值图标 ================

- (void)setActionSheetImages:(NSArray *)images {
    
    if (self.isHadTitle) {
        UILabel *titleLabel = [self.sheetView viewWithTag:1002];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = [NSString stringWithFormat:@"     %@",titleLabel.text];
    }
    
    if (self.isHadCancelButton) {
        UIButton *cancelBtn = [self.sheetView viewWithTag:CANCEL_BUTTON_TAG];
        cancelBtn.top = cancelBtn.top - 8.5;
        _actionSheetHeight = _actionSheetHeight - 8.5;
    }
    
    for (int i = 0; i<images.count; i++) {
        if ([self.backScrollView viewWithTag:100 + i]) {
            UIButton *btn = [self.backScrollView viewWithTag:100 + i];
            [btn setTitle:[NSString stringWithFormat:@"  %@",btn.titleLabel.text] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, -25);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
        }
    }
}

#pragma mark - ============== PrivateMethod ================

- (UILabel *)createLabelWithTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, LABEL_HEIGHT)];
    label.backgroundColor = UIColorFromHex(0xf5f5f5);
    label.text = title;
    label.numberOfLines = 2;
    label.textColor = UIColorFromHex(0x999999);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title type:(DTActionSheetButtonType)btnType {
    
    CGFloat bottomHeight = BUTTON_HEIGHT;
    CGFloat saftAreaBottom = 0;
    CGFloat btnTitleEdgeTop = 0;
    
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        saftAreaBottom = keyWindow.safeAreaInsets.bottom;
    }
    
    if (btnType == DTActionSheetButtonCancel) {
        bottomHeight += saftAreaBottom;
        btnTitleEdgeTop = saftAreaBottom * 0.5;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, _actionSheetHeight, kScreenWidth, bottomHeight)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-btnTitleEdgeTop, 0, 0, 0)];
    [button setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    if ([title containsString:@"+"]) {
        [button setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    }
    
    UIImage *image1 = [self imageWithColor:[UIColor whiteColor] size:button.bounds.size];
    UIImage *image2 = [self imageWithColor:UIColorFromHex(0x999999) size:button.bounds.size];
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    [button setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    return button;
}

/// 颜色转图片
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end
