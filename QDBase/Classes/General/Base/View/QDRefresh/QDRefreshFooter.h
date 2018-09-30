//
//  QDRefreshFooter.h
//  QDBase
//
//  Created by QiaoData on 2018/8/9.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 自定义上拉加载控件

#import "MJRefreshAutoNormalFooter.h"

@interface QDRefreshFooter : MJRefreshAutoNormalFooter
/// 是否自动加载下一页  默认yes
@property (nonatomic, assign) BOOL isAutomationLoad;

@end
