//
//  NSObject+Encrypt.m
//  QDBase
//
//  Created by QiaoData on 2018/9/29.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 加密解密

#import "NSObject+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "AESCrypt.h"

static  NSString *const AESKEY = @"^s upper-_-fro g9527$";

@implementation NSObject (Encrypt)

@end

@implementation NSString (Encrypt)

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cstr, (uint32_t)strlen(cstr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSString *)encryptAESString {
    return [AESCrypt encrypt:self password:AESKEY];
}

- (NSString *)decryptAESString {
    return [AESCrypt decrypt:self password:AESKEY];
}

@end

