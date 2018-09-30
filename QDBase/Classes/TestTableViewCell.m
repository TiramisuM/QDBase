//
//  TestTableViewCell.m
//  QDBase
//
//  Created by QiaoData on 2018/9/13.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "TestTableViewCell.h"
@interface TestTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TestTableViewCell

- (void)setModel:(NSObject *)model {
    [super setModel:model];
    NSDictionary *dict = (NSDictionary *)model;
    self.titleLabel.text = dict[@"name"];
}

@end
