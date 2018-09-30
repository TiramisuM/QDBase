//
//  QDRefreshFooter.m
//  QDBase
//
//  Created by QiaoData on 2018/8/9.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 自定义上拉加载控件

#import "QDRefreshFooter.h"

@implementation QDRefreshFooter

- (void)prepare{
    
    [super prepare];
    self.mj_h = 40;
    self.isAutomationLoad = YES;
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = UIColorFromHex(0x8C90B7);
    [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (self.isAutomationLoad) {
        
        CGFloat distance = self.scrollView.contentSize.height -  kScreenHeight * 2;
        
        if (self.scrollView.contentOffset.y > distance && distance > 0 && self.state != MJRefreshStateNoMoreData  && self.state != MJRefreshStateRefreshing) {
            [self beginRefreshing];
            
        }
    }
}

@end
