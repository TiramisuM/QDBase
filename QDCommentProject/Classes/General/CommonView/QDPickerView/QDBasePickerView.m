//
//  QDBasePickerView.m
//  QDCommentProject
//
//  Created by qiaodaImac on 2018/9/30.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// PickerView基类

#import "QDBasePickerView.h"

@interface QDBasePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *spanView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation QDBasePickerView

// UIColor宏定义
#define UIColorFromHexA(hexValue, alphaValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]
// UIColor宏定义
#define UIColorFromHex(hexValue) UIColorFromHexA(hexValue, 1.0)

// 字符串判空
#define IS_NOT_EMPTY(string) (string != nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@"<null>"] && ![string isEqualToString:@"(null)"])
// 字符串消除异常
#define judgeString(key)  (IS_NOT_EMPTY(key) || [key isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",key] : @"")

#define PickerViewHeight 145
#define ToolBarHieght 40

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - ============== Construct View ================
- (void)constructView {
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.spanView];
    [self.spanView addSubview:self.toolBar];
    [self.toolBar addSubview:self.cancelBtn];
    [self.toolBar addSubview:self.sureBtn];
    [self.toolBar addSubview:self.titleLabel];
    [self.spanView addSubview:self.pickerView];
    
    __weak typeof(self) weakSelf = self;
    
    self.backgroundView.frame = self.bounds;
    self.spanView.frame = CGRectMake(0, self.height, self.width, PickerViewHeight + ToolBarHieght);
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakSelf.spanView);
        make.height.equalTo(@(ToolBarHieght));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.toolBar.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.toolBar.mas_centerY);
        //        make.width.height.equalTo(@40);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.toolBar.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.toolBar.mas_centerY);
        //        make.width.height.equalTo(@40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.toolBar);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.spanView);
        make.top.equalTo(weakSelf.spanView).offset(ToolBarHieght);
    }];
    
    [UIView transitionWithView:_backgroundView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.backgroundView.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.spanView.y = self.height - PickerViewHeight - ToolBarHieght;
    }];
}

#pragma mark - ============== DataSource & Delegate ================

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = UIColorFromHex(0x585857);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}

#pragma mark - ============== Action ================

- (void)sureBtnAction:(UIButton *)btn {
    
    if (self.sureBtnActionBlock) {
        self.sureBtnActionBlock();
    }
    [self hidden];
}

- (void)cancelBtnAction:(UIButton *)btn {
    if (self.cancelBtnActionBlock) {
        self.cancelBtnActionBlock();
    }
    [self hidden];
}

- (void)backgroundViewClick {
    if (self.tapBlankViewActionBlock) {
        self.tapBlankViewActionBlock();
    }
    [self hidden];
}

- (void)changePickerViewTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)updateSureButtonTitle:(NSString *)sureTitle {
    [_sureBtn setTitle:sureTitle forState:UIControlStateNormal];
}

- (void)updateCancelButtonTitle:(NSString *)cancelTitle {
    [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
}

#pragma mark - ============== PrivateMethod ================
- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        self.spanView.y = self.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - ============== Setter & Getter ================

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewClick)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UIView *)spanView {
    
    if (!_spanView) {
        _spanView = [[UIView alloc] init];
        _spanView.backgroundColor = UIColorFromHex(0xf5f5f5);
    }
    return _spanView;
}

- (UIView *)toolBar {
    
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorFromHex(0xFD4C5A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHex(0x585857);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@implementation PickerModel

@end
