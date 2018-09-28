//
//  TestTableViewCell.m
//  QDBase
//
//  Created by qiaodata100 on 2018/9/13.
//  Copyright © 2018年 qiaodata100. All rights reserved.
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
