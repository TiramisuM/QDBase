//
//  UUChangeCityViewController.m
//  RecruitmentFrog
//
//  Created by qiaodaImac on 2017/12/6.
//  Copyright © 2017年 rencaiwa. All rights reserved.
//  更换城市

#import "QDChangeCityViewController.h"

@interface QDChangeCityViewController ()
@property (nonatomic, strong) QDAddressView *addressView;;
@property (nonatomic, strong) NSMutableArray *addressModelArray;
@end

@implementation QDChangeCityViewController


#pragma mark - ============== LifeCircle ================
// 非storyBoard(xib或非xib)都走这个方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"切换地区";
        self.containsHotArea = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self useCustomNavigationBarView];
    [self constructView];
}

#pragma mark - ============== Construct View ================
- (void)constructView {
    [self.view addSubview:self.addressView];
    if (self.isMultiSelect) {
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [saveBtn setTitleColor:UIColorFromHex(0x8C90B7) forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(continueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBarView addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationBarView.mas_right).offset(-5);
            make.width.height.equalTo(@44);
            make.bottom.equalTo(self.navigationBarView.mas_bottom).offset(0);
        }];
    }
    
    if (self.defalutSelects.count > 0) {
        
        self.addressModelArray = [self.defalutSelects mutableCopy];
    }
}

#pragma mark - ============== Data ================

#pragma mark - ============== DataSource & Delegate ================

#pragma mark - ============== Action ================
- (void)continueBtnAction:(UIButton *)btn {
    if (self.addressModelArray.count == 0) {
        [QDHUD showTips:@"您还没有选择地址" superView:nil];
        return;
    }
    if (self.changeCityBlock) {
        self.changeCityBlock(self.addressModelArray);
    }
    [self backPrePage];
}
#pragma mark - ============== PrivateMethod ================

#pragma mark - ============== Setter & Getter ================
- (QDAddressView *)addressView {
    
    if (!_addressView) {
        
        CGFloat addressViewY = UI_STATUS_BAR_HEIGHT + UI_NAVIGATION_BAR_HEIGHT;
        _addressView = [[QDAddressView alloc] initWithFrame:CGRectMake(0, addressViewY, kScreenWidth, kScreenHeight - addressViewY)];
        _addressView.isMultiSelect = self.isMultiSelect;
        _addressView.defalutSelects = self.defalutSelects;
        _addressView.haveNoNimit = self.haveNoNimit;
        _addressView.leftProvinces = self.leftProvinces;
        _addressView.containsHotArea = self.containsHotArea;
        WS(weakSelf)
        _addressView.changeCityBlock = ^(NSMutableArray<QDAreaModel *> *addressModelArray) {
            if (weakSelf.isMultiSelect) {
                weakSelf.addressModelArray = addressModelArray;
            } else {
                if (weakSelf.changeCityBlock) {
                    weakSelf.changeCityBlock(addressModelArray);
                }
                [weakSelf backPrePage];
            }
        };
    }
    return _addressView;
}

@end
