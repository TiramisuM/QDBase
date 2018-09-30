//
//  QDRequestResultView.m
//  QDBase
//
//  Created by QiaoData on 2018/8/10.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 请求结果后展示的页面

#import "QDRequestResultView.h"

#define kTipLabFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]
#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
#define kAdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define kAdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define kTextColor UIColorFromHex(0x9A9A9A)
#define kThemeColor UIColorFromHex(0xFF6600)


@interface QDRequestResultView ()

@property (nonatomic ,strong) UIImageView *imgView;

@end

@implementation QDRequestResultView

#pragma mark - ============== instance ================

+ (instancetype)resultViewWithResultState:(QDNetworkRequstResultState)resultState tap:(TapBlock)tapBlock {
    QDRequestResultView *resultView = [[self alloc] init];
    resultView.resultState = resultState;
    resultView.tapBlock = tapBlock;
    return resultView;
}

- (void)setResultState:(QDNetworkRequstResultState)resultState {

    _resultState = resultState;
    
    switch (resultState) {
        case QDNetworkRequstResultStateEmpty:{
            self.imageName = @"blank_message";
            self.tipMsg = @"没有消息";
            self.subTipMsg = @"";
        }
            break;
        case QDNetworkRequstResultStateLoading:{
            self.imageName = @"blank_message";
            self.tipMsg = @"正在加载";
            self.subTipMsg = @"";
        }
            break;
        case QDNetworkRequstResultStateError:{
            self.imageName = @"blank_net";
            self.tipMsg = @"找不到网络";
            self.subTipMsg = @"点击屏幕重新加载";
        }
            break;
        case QDNetworkRequstResultStateNoNet:{
            self.imageName = @"blank_net";
            self.tipMsg = @"找不到网络";
            self.subTipMsg = @"点击屏幕重新加载";
        }
            break;
        default:
            break;
    }
}

- (void)hide {
    self.tapBlock = nil;
    self.infoBlock = nil;
    [self removeFromSuperview];
}

- (void)setImageName:(NSString *)imageName{
    
    if (judgeString(imageName).length == 0) {
        return;
    }
    _imageName = imageName;
    self.imgView.image = [UIImage imageNamed:imageName];
}

- (void)setTipMsg:(NSString *)tipMsg{
    
    if (judgeString(tipMsg).length == 0) {
        return;
    }
    _tipMsg = tipMsg;
    self.tipLabel.text = tipMsg;
}

- (void)setSubTipMsg:(NSString *)subTipMsg{
    if (judgeString(subTipMsg).length == 0) {
        return;
    }
    _subTipMsg = subTipMsg;
    self.subTipLabel.text = subTipMsg;
}


-(void)setSubClickTipMsg:(NSString *)subClickTipMsg{
    if (judgeString(subClickTipMsg).length == 0) {
        return;
    }
    _subClickTipMsg = subClickTipMsg;
    self.subClickTipLabel.text = subClickTipMsg;
    self.subClickTipLabel.hidden = NO;
}



#pragma mark - ============== other ================

-  (void)layoutSubviews{
    [super layoutSubviews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = UIColorFromHex(0xF5F5F5);
    CGFloat imgMargin = 170;
    CGRect imgViewRect = CGRectZero;
    CGFloat imgViewWidth = kAdaptedWidth(160);
    imgViewRect.size = CGSizeMake(imgViewWidth, imgViewWidth);
    imgViewRect.origin = CGPointMake((self.frame.size.width - imgViewWidth) * 0.5, (self.frame.size.height - imgViewWidth) * 0.5 - imgMargin);
    
    if (_imageY != 0) {
        imgViewRect.origin = CGPointMake((self.frame.size.width - imgViewWidth) * 0.5, _imageY);
    }
    
    self.imgView.frame = imgViewRect;
    
    CGRect tiplabRect = CGRectZero;
    CGFloat tipLabWidth = self.frame.size.width * 0.6;
    tiplabRect.size = CGSizeMake(tipLabWidth, [self tipSizeWithWidth:tipLabWidth]);
    tiplabRect.origin = CGPointMake(self.frame.size.width * 0.2, CGRectGetMaxY(self.imgView.frame) + kAdaptedHeight(8));
    self.tipLabel.frame = tiplabRect;
    self.subTipLabel.frame =  CGRectMake(0, self.frame.size.height - imgMargin, kScreenWidth, 20);
    self.subClickTipLabel.frame =  CGRectMake(0, CGRectGetMaxY(self.subTipLabel.frame), kScreenWidth, 20);
}

- (CGFloat)tipSizeWithWidth:(CGFloat)width{
    
    return  [self.tipMsg boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:kTipLabFont}
                                      context:nil].size.height;
}

#pragma mark - ============== touch ================

- (void)clickView:(UITapGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock();
        [self hide];
    }
}

- (void)subClick:(UITapGestureRecognizer *)tap {
    if (self.infoBlock) {
        self.infoBlock();
        [self hide];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{};
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{};
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{};

#pragma mark - ============== InitView ================

- (instancetype)init{
    if (self = [super init]) {
        _imageY = 0.f;
    }
    return self;
}
#pragma mark - ============== View ================

- (UIImageView *)imgView{
    
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)tipLabel{
    
    if (_tipLabel == nil) {
        _tipLabel = [UILabel new];
        _tipLabel.font = kTipLabFont;
        _tipLabel.textColor = kTextColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)subTipLabel{
    
    if (_subTipLabel == nil) {
        _subTipLabel = [UILabel new];
        _subTipLabel.font = kTipLabFont;
        _subTipLabel.textColor = kTextColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subClick:)];
        [_subTipLabel addGestureRecognizer:tap];
        _subTipLabel.userInteractionEnabled = YES;
        _subTipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTipLabel];
    }
    return _subTipLabel;
}

- (UILabel *)subClickTipLabel{
    
    if (_subClickTipLabel == nil) {
        _subClickTipLabel = [UILabel new];
        _subClickTipLabel.font = kTipLabFont;
        _subClickTipLabel.textColor = kThemeColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subClick:)];
        [_subClickTipLabel addGestureRecognizer:tap];
        _subClickTipLabel.userInteractionEnabled = YES;
        _subClickTipLabel.textAlignment = NSTextAlignmentCenter;
        _subClickTipLabel.hidden = YES;
        [self addSubview:_subClickTipLabel];
    }
    return _subClickTipLabel;
}
@end
