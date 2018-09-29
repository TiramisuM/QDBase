//
//  NSObject+Encrypt.h
//  QDBase
//
//  Created by qiaodata100 on 2018/9/29.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 加密解密

#import <Foundation/Foundation.h>

@interface NSObject (Encrypt)

@end

/// 字符串加密解密
@interface NSString (Encrypt)
/**
 MD5加密
 
 @return NSString
 */
- (NSString *)MD5String;
/**
 AES加密

 @return AES加密后的字符串
 */
- (NSString *)encryptAESString;
/**
 AES解密

 @return 将加密后的AES字符串解密
 */
- (NSString *)decryptAESString;

@end
