//
//  QDRequestResultView.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/8/10.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 请求结果后展示的页面

#import "QDRequestResultView.h"

#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
#define kAdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define kAdaptedHeight(x) ceilf((x) * kScreenHeightRatio)

@interface QDRequestResultView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *reloadBtn;
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
            self.imageName = @"noResult";
            self.tipMsg = @"暂无数据";
        }
            break;
        case QDNetworkRequstResultStateLoading:{
            self.imageName = @"noResult";
            self.tipMsg = @"正在加载";
        }
            break;
        case QDNetworkRequstResultStateError:{
            self.imageName = @"noNet";
            self.tipMsg = @"服务器好像睡着了";
        }
            break;
        case QDNetworkRequstResultStateNoNet:{
            self.imageName = @"noNet";
            self.tipMsg = @"找不到网络";
        }
            break;
        default:
            break;
    }
}

- (void)hide {
    self.tapBlock = nil;
    [self removeFromSuperview];
}

- (void)setImageName:(NSString *)imageName{
    
    if (judgeString(imageName).length == 0) {
        return;
    }
    _imageName = imageName;
    if (imageName.length > 0) {
        self.imgView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setTipMsg:(NSString *)tipMsg{
    
    if (judgeString(tipMsg).length == 0) {
        return;
    }
    
    _tipMsg = tipMsg;
    
    self.tipLabel.text = tipMsg;
}

#pragma mark - ============== other ================

-  (void)layoutSubviews {
    [super layoutSubviews];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    //    self.userInteractionEnabled = YES;
    //    [self addGestureRecognizer:tap];
    
    self.backgroundColor = UIColorFromHex(0xF9F8F8);
    CGFloat imgMargin = kAdaptedHeight(59);
    CGRect imgViewRect = CGRectZero;
    
    CGFloat imgViewWidth = kAdaptedWidth(151);
    CGFloat imgViewHeight = kAdaptedWidth(165);
    
    if (self.resultState != QDNetworkRequstResultStateEmpty) {
        imgViewWidth = kAdaptedWidth(114);
        imgViewHeight = kAdaptedWidth(100);
    }
    
    imgViewRect.size = CGSizeMake(imgViewWidth, imgViewHeight);
    imgViewRect.origin = CGPointMake((self.frame.size.width - imgViewWidth) * 0.5, (self.frame.size.height - imgViewHeight) * 0.5 - imgMargin);
    
    if (_imageY != 0) {
        imgViewRect.origin = CGPointMake((self.frame.size.width - imgViewWidth) * 0.5, _imageY);
    } else {
        imgViewRect.origin = CGPointMake((self.frame.size.width - imgViewWidth) * 0.5, imgMargin);
    }
    
    self.imgView.frame = imgViewRect;
    
    CGRect tiplabRect = CGRectZero;
    
    tiplabRect.size = CGSizeMake(self.width - 100, 20);
    tiplabRect.origin = CGPointMake(50, CGRectGetMaxY(self.imgView.frame) + kAdaptedHeight(22));
    self.tipLabel.frame = tiplabRect;
    self.tipLabel.centerX = self.centerX;
    
    if (self.resultState != QDNetworkRequstResultStateEmpty) {
        self.reloadBtn.hidden = NO;
        self.reloadBtn.top = CGRectGetMaxY(tiplabRect) + kAdaptedHeight(20);
        self.reloadBtn.centerX = self.centerX;
    }
}

#pragma mark - ============== touch ================

- (void)reloadBtnAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - ============== InitView ================

- (instancetype)init{
    if (self = [super init]) {
        _imageY = UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT;
        
    }
    return self;
}
#pragma mark - ============== View ================

- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)tipLabel {
    
    if (_tipLabel == nil) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.layer.cornerRadius = 3;
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.textColor = UIColorFromHex(0x333333);
        _tipLabel.backgroundColor = UIColorFromHex(0xF9F8F8);
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIButton *)reloadBtn {
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadBtn.frame = CGRectMake(0, 0, 160, 44);
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadBtn.backgroundColor = UIColorFromHex(0xFC4654);
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _reloadBtn.layer.cornerRadius = 3;
        _reloadBtn.hidden = YES;
        [_reloadBtn addTarget:self action:@selector(reloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reloadBtn];
    }
    return _reloadBtn;
}
@end
