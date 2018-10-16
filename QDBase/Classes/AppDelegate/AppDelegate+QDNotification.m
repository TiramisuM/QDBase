//
//  AppDelegate+QDNotification.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/3/27.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// AppDelegate Notification相关

#import "AppDelegate+QDNotification.h"

@implementation AppDelegate (QDNotification)

/// 远程通知注册成功
- (void)QDApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenString = %@", deviceTokenString);
}

/// 远程通知注册失败
- (void)QDApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

/// 通知被点击
- (void)QDApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

@end
