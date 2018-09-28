//
//  UIView+FitTextFont.m
//  InsuranceAgentRelation
//
//  Created by qiaodata100 on 2018/8/23.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "UIView+FitTextFont.h"
#import <objc/runtime.h>

@implementation UIView (FitTextFont)

- (UIFont *)fitSizeWithFont:(UIFont *)font {
    if ([font.fontName containsString:@"-Bold"]) {
        font = [UIFont boldSystemFontOfSize:font.pointSize];
    } else if ([font.fontName containsString:@"-Italic"]) {
        font = [UIFont italicSystemFontOfSize:font.pointSize];
    } else {
        font = [UIFont systemFontOfSize:font.pointSize];
    }
    return font;
}

@end

@implementation UILabel (FitTextFont)

+ (void)load {
    Method initWithCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method adjusttInitWithCoder = class_getInstanceMethod([self class], @selector(adjustInitWithCoder:));
    method_exchangeImplementations(initWithCoder, adjusttInitWithCoder);
}

- (instancetype)adjustInitWithCoder:(NSCoder *)aCoder {
    [self adjustInitWithCoder:aCoder];
    if (self) {
        self.font = [self fitSizeWithFont:self.font];
    }
    return self;
}

@end

@implementation UIButton (FitTextFont)

+ (void)load {
    Method initWithCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method adjusttInitWithCoder = class_getInstanceMethod([self class], @selector(adjustInitWithCoder:));
    method_exchangeImplementations(initWithCoder, adjusttInitWithCoder);
}

- (instancetype)adjustInitWithCoder:(NSCoder *)aCoder {
    [self adjustInitWithCoder:aCoder];
    if (self) {
        self.titleLabel.font = [self fitSizeWithFont:self.titleLabel.font];
    }
    return self;
}

@end

@implementation UITextView (FitTextFont)

+ (void)load {
    Method initWithCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method adjusttInitWithCoder = class_getInstanceMethod([self class], @selector(adjustInitWithCoder:));
    method_exchangeImplementations(initWithCoder, adjusttInitWithCoder);
}

- (instancetype)adjustInitWithCoder:(NSCoder *)aCoder {
    [self adjustInitWithCoder:aCoder];
    if (self) {
        self.font = [self fitSizeWithFont:self.font];
    }
    return self;
}

@end

@implementation UITextField (FitTextFont)

+ (void)load {
    Method initWithCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method adjusttInitWithCoder = class_getInstanceMethod([self class], @selector(adjustInitWithCoder:));
    method_exchangeImplementations(initWithCoder, adjusttInitWithCoder);
}

- (instancetype)adjustInitWithCoder:(NSCoder *)aCoder {
    [self adjustInitWithCoder:aCoder];
    if (self) {
        self.font = [self fitSizeWithFont:self.font];
    }
    return self;
}

@end
