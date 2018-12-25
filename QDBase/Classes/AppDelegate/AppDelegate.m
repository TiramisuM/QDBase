//
//  AppDelegate.m
//  QDBase
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+QDAppStatus.h"
#import "AppDelegate+QDLaunching.h"
#import "AppDelegate+QDNotification.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - ============== Launching ================

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [self QDApplication:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - ============== Notification ================
/// 远程通知注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self QDApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
/// 远程通知注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self QDApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}
/// 通知被点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self QDApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - ============== AppStatus ================
/// 被挂起（暂时的）
- (void)applicationWillResignActive:(UIApplication *)application {
    [self QDApplicationWillResignActive:application];
}
/// 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self QDApplicationDidEnterBackground:application];
}
/// 即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self QDApplicationWillEnterForeground:application];
}
/// 重新激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self QDApplicationDidBecomeActive:application];
}
/// 终止
- (void)applicationWillTerminate:(UIApplication *)application {
    [self QDApplicationWillTerminate:application];
}

#pragma mark - ============== 第三方回调 ================

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return YES;
}

#else

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return YES;
}

#endif

@end
