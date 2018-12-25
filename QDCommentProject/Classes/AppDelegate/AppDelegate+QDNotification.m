//
//  AppDelegate+QDNotification.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/3/27.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// AppDelegate Notification相关

#import "AppDelegate+QDNotification.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate (QDNotification)

#pragma mark - ============== 注册极光推送 ================

- (void)registJPush:(NSDictionary *)launchOptions{
    
}


/// 远程通知注册成功
- (void)QDApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {}

/// 远程通知注册失败
- (void)QDApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {}

/// 通知被点击
- (void)QDApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    completionHandler(UIBackgroundFetchResultNewData);
    
    [self pushViewController:userInfo];
}

#pragma mark - ============== JPush Delegate ================

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// iOS10前台推送消息点击之后的处理
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    UNNotificationRequest *request = notification.request;
    [self pushDidReceiveNotificationWithNotificationRequest:request active:YES];
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// iOS10后台推送消息点击之后的处理

- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center
      didReceiveNotificationResponse:(UNNotificationResponse *)response
               withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    UNNotificationRequest *request = response.notification.request;
    
    [self pushDidReceiveNotificationWithNotificationRequest:request active:NO];
    completionHandler();
}

/**
 收到推送处理
 */
- (void)pushDidReceiveNotificationWithNotificationRequest:(UNNotificationRequest *)request active:(BOOL)active  API_AVAILABLE(ios(10.0)){
    
    // 收到推送的消息内容
    UNNotificationContent *content = request.content;
    // 推送收到的详细信息
    NSDictionary *userInfo = content.userInfo;
    // 推送消息的角标
    NSNumber *badge = content.badge;
    // 推送消息体
    NSString *body = content.body;
    // 推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        
        NSLog(@"iOS10 收到远程通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
        if (!active) {
            [self pushViewController:userInfo];
        }
    } else {
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
}

#endif

#pragma mark - ============== 推送消息跳转处理 ================

- (void)pushViewController:(NSDictionary *)userInfo {
}

@end
