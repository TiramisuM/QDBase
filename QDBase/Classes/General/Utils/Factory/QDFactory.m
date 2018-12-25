//
//  QDFactory.m
//  QDBase
//
//  Created by QiaoData on 2018/9/10.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 工厂类

#import "QDFactory.h"

@implementation QDFactory

@end

@implementation QDFactory (UILabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor whiteColor];
    label.numberOfLines = 1;
    return label;
}

@end

@implementation QDFactory (UIButton)

+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if (![judgeString(imageName) isEqualToString:@""]) {
        UIImage *newImage = [UIImage imageNamed:imageName];
        [button setImage:newImage forState:UIControlStateNormal];
    }
    if (![judgeString(highlightedImageName) isEqualToString:@""]) {
        UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
        
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if (![judgeString(imageName) isEqualToString:@""]) {
        UIImage *newImage = [UIImage imageNamed:imageName];
        [button setImage:newImage forState:UIControlStateNormal];
    }
    if (![judgeString(selectImageName) isEqualToString:@""]) {
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        [button setImage:selectImage forState:UIControlStateSelected];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

@implementation QDFactory (UITextField)

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.font = font;
    textField.textColor = textColor;
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleNone;
    return textField;
}

@end

@implementation QDFactory (UIAlertController)

+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title message:(NSString *)message sureAction:(AlertAction)sureAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sureAction]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

+ (UIAlertController *)createAlertActionControllerWithTitle:(NSString *)title message:(NSString *)message sureAction:(AlertAction)sureAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sureAction]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
