//
//  AppDelegate+QDAppStatus.h
//  QDCommentProject
//
//  Created by QiaoData on 2018/3/27.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// AppDelegate Notification相关

#import "AppDelegate.h"

@interface AppDelegate (QDAppStatus)
/// 被挂起（暂时的）
- (void)QDApplicationWillResignActive:(UIApplication *)application;
/// 即将进入前台
- (void)QDApplicationWillEnterForeground:(UIApplication *)application;
/// 进入后台
- (void)QDApplicationDidEnterBackground:(UIApplication *)application;
/// 重新激活
- (void)QDApplicationDidBecomeActive:(UIApplication *)application;
/// 终止
- (void)QDApplicationWillTerminate:(UIApplication *)application;
@end
