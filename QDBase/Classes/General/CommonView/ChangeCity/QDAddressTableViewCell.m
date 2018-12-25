//
//  QDAddressTableViewCell.m
//  DigitalTalent
//
//  Created by qiaodaImac on 2018/1/2.
//  Copyright © 2018年 数字英才. All rights reserved.
//  地址选择器cell

#import "QDAddressTableViewCell.h"

@interface QDAddressTableViewCell ()

@end

@implementation QDAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
- (void)initView {
    [self.contentView addSubview:self.addressNameLabel];
    [self.contentView addSubview:self.selectAddressBtn];
    
    [self.selectAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.equalTo(@44);
    }];
    
    [self.addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.selectAddressBtn.mas_left).offset(0);
    }];
}
- (UILabel *)addressNameLabel{
    if (!_addressNameLabel) {
        _addressNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressNameLabel.font = [UIFont systemFontOfSize:12];
        _addressNameLabel.textColor = UIColorFromHex(0x000000);
        _addressNameLabel.text = @"海淀区";
    }
    return _addressNameLabel;
}
- (UIButton *)selectAddressBtn {
    if (!_selectAddressBtn) {
        _selectAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAddressBtn setImage:[UIImage imageNamed:@"wxWorkNonSelected"] forState:UIControlStateNormal];
        [_selectAddressBtn setImage:[UIImage imageNamed:@"wxWordSelected"] forState:UIControlStateSelected];
        _selectAddressBtn.userInteractionEnabled = NO;
    }
    return _selectAddressBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
