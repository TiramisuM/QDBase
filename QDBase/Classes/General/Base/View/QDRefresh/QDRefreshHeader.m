//
//  QDRefreshHeader.m
//  QDBase
//
//  Created by QiaoData on 2018/8/9.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 自定义下拉刷新控件

#import "QDRefreshHeader.h"

@implementation QDRefreshHeader

- (void)prepare
{
    [super prepare];
    self.mj_h = 60;
    self.stateLabel.textColor = UIColorFromHex(0x8C90B7);
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
}

@end
