//
//  QDAlertView.m
//  InsuranceAgentRelation
//
//  Created by AngleK on 2018/11/9.
//  Copyright © 2018 QiaoData. All rights reserved.
//

#import "QDAlertView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface QDAlertView () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) QDAlertViewType type;
@property (nonatomic, copy) NSString *tipTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *sureButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) SureActionBlcok sureAction;
@property (nonatomic, copy) CancelActionBlcok cancelAction;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *tipTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *noRemindButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *inputLine;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, assign) NSInteger maxInputCount;

+ (void)setIsForce:(BOOL)isForce;
+ (BOOL)isForce;

@end

@implementation QDAlertView

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString *)message maxInputCount:(NSInteger)maxInputCount sureAction:(SureActionBlcok)sureAction cancelAction:(CancelActionBlcok)cancelAction {
    [self showAlertWithType:QDAlertViewTypeInput tipTitle:@"" title:title message:message maxInputCount:maxInputCount sureButtonTitle:@"确认" cancelButtonTitle:@"取消" sureAction:sureAction cancelAction:cancelAction];
}

+ (void)showAlertWithType:(QDAlertViewType)type title:(NSString *)title message:(NSString *)message sureAction:(SureActionBlcok)sureAction cancelAction:(CancelActionBlcok)cancelAction {
    
    [self showAlertWithType:type tipTitle:@"" title:title message:message maxInputCount:1000 sureButtonTitle:@"确认" cancelButtonTitle:@"取消" sureAction:sureAction cancelAction:cancelAction];
    
}

+ (void)showAlertWithType:(QDAlertViewType)type title:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle sureAction:(SureActionBlcok)sureAction cancelAction:(CancelActionBlcok)cancelAction {
    
    [self showAlertWithType:type tipTitle:@"" title:title message:message maxInputCount:1000 sureButtonTitle:sureButtonTitle cancelButtonTitle:cancelButtonTitle sureAction:sureAction cancelAction:cancelAction];
}

+ (void)showAlertWithType:(QDAlertViewType)type title:(NSString *)title message:(NSString *)message maxInputCount:(NSInteger)maxInputCount sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle sureAction:(SureActionBlcok)sureAction cancelAction:(CancelActionBlcok)cancelAction {
    [self showAlertWithType:type tipTitle:@"" title:title message:message maxInputCount:maxInputCount sureButtonTitle:sureButtonTitle cancelButtonTitle:cancelButtonTitle sureAction:sureAction cancelAction:cancelAction];
}

+ (void)showUpdateAlertWithTitle:(NSString *)title message:(NSString *)message isForce:(BOOL)isForce sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle sureAction:(SureActionBlcok)sureAction {
    
    NSString *cancelTitle = isForce ? @"" : cancelButtonTitle;
    [self setIsForce:isForce];
    [self showAlertWithType:QDAlertViewTypeDefault title:title message:message maxInputCount:1000 sureButtonTitle:sureButtonTitle cancelButtonTitle:cancelTitle sureAction:sureAction cancelAction:nil];
}

+ (void)showAlertWithType:(QDAlertViewType)type tipTitle:(NSString *)tipTitle title:(NSString *)title message:(NSString *)message maxInputCount:(NSInteger)maxInputCount sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle sureAction:(SureActionBlcok)sureAction cancelAction:(CancelActionBlcok)cancelAction {
    if (type == QDAlertViewTypeNoRemind) {
        NSString *key = [title MD5String];
        BOOL hideAlert = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        if (hideAlert) {
            if (sureAction) {
                sureAction(nil);
            }
            return;
        }
    }
    
    QDAlertView *alertView = [[QDAlertView alloc] init];
    alertView.type = type;
    alertView.tipTitle = tipTitle;
    alertView.title = title;
    alertView.message = message;
    alertView.sureButtonTitle = sureButtonTitle;
    alertView.cancelButtonTitle = cancelButtonTitle;
    alertView.maxInputCount = maxInputCount;
    alertView.sureAction = sureAction;
    alertView.cancelAction = cancelAction;
    // 显示alertView
    [alertView constructView];
    [alertView show];
}

- (void)sureButtonClick {
    if (self.sureAction) {
        
        if (self.type == QDAlertViewTypeInput) {
            [self.textField resignFirstResponder];
            self.sureAction(self.textField.text);
        } else {
            self.sureAction(nil);
        }
    }
    
    if (self.type == QDAlertViewTypeNoRemind) {
        // 将当前存储到UserDefaults里
        NSString *key = [self.title MD5String];
        [[NSUserDefaults standardUserDefaults] setBool:self.noRemindButton.selected forKey:key];
    }
    if (![[self class] isForce]) {
        [self hide];
    }
}

- (void)cancelButtonClick {
    if (self.cancelAction) {
        self.cancelAction();
    }
    [self hide];
}

- (void)noRemindButtonAction {
    self.noRemindButton.selected = !self.noRemindButton.selected;
}

- (void)show {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
    [[self class] setIsForce:NO];
}

#pragma mark - ============== Deleagete & DataSource ================
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
/// textField输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    //防止输入拼音状态时查询
    NSString *str = [textField textInRange:textField.markedTextRange];
    if (![str isEqualToString:@""]){
        return;
    }
    if ([textField.text containsEmoji]) {
        [QDHUD showWarningWithTitle:@"不可输入表情"];
        textField.text = [textField.text removeEmoji];
        if (textField.text.length > self.maxInputCount) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, self.maxInputCount)];
        }
        return;
    }
    textField.text = [self subString:textField.text length:self.maxInputCount];
}

// 将多余的字段截取
- (NSString *)subString:(NSString *)string length:(NSInteger)length {
    if (string.length <= length) {
        return string;
    }
    int count = 0;
    NSMutableString *stringM = [NSMutableString string];
    for (NSInteger i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        count += [subString lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 1 ? 2 : 1;
        [stringM appendString:subString];
        if (count == length) {
            return [stringM copy];
        } else if (count > length) {
            return [stringM substringToIndex:stringM.length - 1];
        }
    }
    return string;
}
#pragma mark - ============== Construct View ================
- (void)constructView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = UIColorFromHexA(0x24242D, 0.4);
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = UIColorFromHex(0xFFFFFF);
    self.contentView.layer.cornerRadius = 10;
    
    self.tipTitleLabel = [QDFactory createLabelWithFrame:CGRectZero text:judgeString(self.tipTitle) textColor:UIColorFromHex(0x333333) font:[UIFont boldSystemFontOfSize:18] textAlignment:NSTextAlignmentCenter];
    self.tipTitleLabel.numberOfLines = 0;
    
    self.titleLabel = [QDFactory createLabelWithFrame:CGRectZero text:judgeString(self.title) textColor:UIColorFromHex(0x333333) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter];
    self.titleLabel.numberOfLines = 0;
    
    self.descLabel = [QDFactory createLabelWithFrame:CGRectZero text:judgeString(self.message) textColor:UIColorFromHex(0x9999A0) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter];
    self.descLabel.numberOfLines = 0;
    
    self.textField = [QDFactory createTextFieldWithFrame:CGRectZero placeholder:@"" font:[UIFont systemFontOfSize:18] textColor:UIColorFromHex(0x333333)];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.clipsToBounds = YES;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.inputLine = [[UIView alloc] init];
    self.inputLine.backgroundColor = UIColorFromHex(0xE2E1E1);
    
    self.noRemindButton = [QDFactory createButtonWithFrame:CGRectZero imageName:@"remindNormal" selectImageName:@"remindSelect" target:self action:@selector(noRemindButtonAction)];
    [self.noRemindButton setTitle:@"下次不再提示" forState:UIControlStateNormal];
    [self.noRemindButton setTitleColor:UIColorFromHex(0xBEBEC4) forState:UIControlStateNormal];
    self.noRemindButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.noRemindButton.adjustsImageWhenHighlighted = NO;
    [self.noRemindButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    
    self.horizontalLine = [[UIView alloc] init];
    self.horizontalLine.backgroundColor = UIColorFromHex(0xE2E1E1);
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = UIColorFromHex(0xE2E1E1);
    
    self.sureButton = [QDFactory createButtonWithFrame:CGRectZero text:judgeString(self.sureButtonTitle) textColor:UIColorFromHex(0xFF5966) font:[UIFont systemFontOfSize:18] target:self action:@selector(sureButtonClick)];
    
    self.cancelButton = [QDFactory createButtonWithFrame:CGRectZero text:judgeString(self.cancelButtonTitle) textColor:UIColorFromHex(0x9999A0) font:[UIFont systemFontOfSize:18] target:self action:@selector(cancelButtonClick)];
    
    [self addSubview:self.contentView];
    if (judgeString(self.tipTitle).length) {
        [self.contentView addSubview:self.tipTitleLabel];
    }
    if (judgeString(self.title).length) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (judgeString(self.message).length) {
        [self.contentView addSubview:self.descLabel];
    }
    [self.contentView addSubview:self.horizontalLine];
    if (judgeString(self.sureButtonTitle).length && judgeString(self.cancelButtonTitle).length) {
        [self.contentView addSubview:self.verticalLine];
    }
    if (judgeString(self.sureButtonTitle).length) {
        [self.contentView addSubview:self.sureButton];
    }
    if (judgeString(self.cancelButtonTitle).length) {
        [self.contentView addSubview:self.cancelButton];
    }
    
    if (self.type == QDAlertViewTypeInput) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.inputLine];
    }
    
    if (self.type == QDAlertViewTypeNoRemind) {
        [self.contentView addSubview:self.noRemindButton];
    }
    
   // 开始布局
    CGFloat contentSideMargin = 50 * kScreenWidth / 375.0;
    CGFloat viewWidth = kScreenWidth - contentSideMargin * 2;
    self.contentView.frame = CGRectMake(contentSideMargin, 0, viewWidth, 200);
    
    CGFloat maxY = 0.f;
    if (self.type == QDAlertViewTypeInput) {
        
        CGFloat titleMargin = 14;
        CGFloat titleMaxW = viewWidth - titleMargin * 2;
        CGSize titleLabelSize = [self boundingSizeWithString:judgeString(self.title) maxSize:CGSizeMake(titleMaxW, MAXFLOAT) fontSize:16];
        self.titleLabel.frame = CGRectMake(titleMargin, titleMargin, titleMaxW, ceil(titleLabelSize.height));
        
        CGFloat descLabelY = CGRectGetMaxY(self.titleLabel.frame);
        if (![judgeString(self.message) isEqualToString:@""]) {
            descLabelY += 9;
        }
        CGSize descLabelSize = [self boundingSizeWithString:judgeString(self.message) maxSize:CGSizeMake(titleMaxW, MAXFLOAT) fontSize:12];
        self.descLabel.frame = CGRectMake(titleMargin, descLabelY, descLabelSize.width, ceil(descLabelSize.height));
        
        CGFloat textFieldY = CGRectGetMaxY(self.descLabel.frame) + 28;
        CGFloat textFieldW = 100;
        CGFloat textFieldX = (viewWidth - textFieldW) / 2;
        CGFloat textFieldH = 30;
        
        self.textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
        self.inputLine.frame = CGRectMake(textFieldX, CGRectGetMaxY(self.textField.frame), textFieldW, 1);
        maxY = CGRectGetMaxY(self.inputLine.frame) + 37;
        
    } else {
        
        CGFloat titleMargin = 15;
        CGFloat titleMaxW = viewWidth - titleMargin * 2;
        maxY = 10;
        if (judgeString(self.tipTitle).length) {
            CGSize tipTitleSize = [self.tipTitle boundingRectWithSize:CGSizeMake(titleMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]} context:nil].size;
            self.tipTitleLabel.frame = CGRectMake(titleMargin, maxY, titleMaxW, ceil(tipTitleSize.height));
            maxY = self.tipTitleLabel.bottom + 20;
        } else {
            maxY = 35;
        }
        
        if (judgeString(self.title).length) {
            CGSize titleLabelSize = [self boundingSizeWithString:judgeString(self.title) maxSize:CGSizeMake(titleMaxW, MAXFLOAT) fontSize:16];
            self.titleLabel.frame = CGRectMake(titleMargin, maxY, titleMaxW, ceil(titleLabelSize.height));
            maxY = self.titleLabel.bottom;
        }
        
        if (![judgeString(self.message) isEqualToString:@""]) {
            maxY += 9;
            CGFloat descMargin = 10;
            CGFloat descMaxW = viewWidth - descMargin * 2;
            CGSize descLabelSize = [self boundingSizeWithString:judgeString(self.message) maxSize:CGSizeMake(descMaxW, MAXFLOAT) fontSize:12];
            self.descLabel.frame = CGRectMake(descMargin, maxY, descMaxW, ceil(descLabelSize.height));
            
            maxY = CGRectGetMaxY(self.descLabel.frame) + 16;
        } else {
            self.descLabel.frame = CGRectMake(0, maxY, 0, 0);
            maxY = CGRectGetMaxY(self.descLabel.frame) + 35;
        }
        
        if (self.type == QDAlertViewTypeNoRemind) {
            CGFloat noRemindY = maxY;
            CGFloat noRemindX = 20;
            CGFloat noRemindW = 92;
            CGFloat noRemindH = 17;
            self.noRemindButton.frame = CGRectMake(noRemindX, noRemindY, noRemindW, ceil(noRemindH));
            maxY = CGRectGetMaxY(self.noRemindButton.frame) + 12;
        }
    }
    
    
    CGFloat buttonW = (viewWidth - 1) / 2;
    CGFloat buttonH = 44;
    CGFloat buttonY = maxY;
    self.horizontalLine.frame = CGRectMake(0, maxY, viewWidth, 1);
    
    if (judgeString(self.sureButtonTitle).length && judgeString(self.cancelButtonTitle).length) {
        self.cancelButton.frame = CGRectMake(0, buttonY, buttonW, buttonH);
        self.verticalLine.frame = CGRectMake(buttonW, buttonY, 1, buttonH);
        self.sureButton.frame = CGRectMake(buttonW + 1, buttonY, buttonW, ceil(buttonH));
        maxY = CGRectGetMaxY(self.sureButton.frame);
    } else {
        if (![[self class] isForce]) {
            // 添加手势给self
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
        }
        if (judgeString(self.sureButtonTitle).length) {
            self.sureButton.frame = CGRectMake(0, buttonY, viewWidth, ceil(buttonH));
            maxY = CGRectGetMaxY(self.sureButton.frame);
        }
        if (judgeString(self.cancelButtonTitle).length) {
            self.cancelButton.frame = CGRectMake(0, buttonY, viewWidth, ceil(buttonH));
            maxY = CGRectGetMaxY(self.cancelButton.frame);
        }
    }
    self.contentView.height = maxY;
    self.contentView.centerY = self.centerY;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    } else {
        return YES;
    }
}

- (CGSize)boundingSizeWithString:(NSString *)string maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize {
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

#pragma mark - ============== Setter & Getter ================
static BOOL _isForce = NO;
+ (void)setIsForce:(BOOL)isForce {
    _isForce = isForce;
}

+ (BOOL)isForce {
    return _isForce;
}

@end
