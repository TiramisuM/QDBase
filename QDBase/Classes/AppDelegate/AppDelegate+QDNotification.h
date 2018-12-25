//
//  AppDelegate+QDNotification.h
//  QDCommentProject
//
//  Created by QiaoData on 2018/3/27.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// AppDelegate Notification相关

#import "AppDelegate.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (QDNotification)<UNUserNotificationCenterDelegate>
/// 注册极光推送
- (void)registJPush:(NSDictionary *)launchOptions;
/// 远程通知注册成功
- (void)QDApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
/// 远程通知注册失败
- (void)QDApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
/// 通知被点击
- (void)QDApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
