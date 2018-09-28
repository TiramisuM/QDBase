//
//  NSString+MD5.m
//  QDBase
//
//  Created by qiaodata100 on 2018/8/6.
//  Copyright © 2018年 qiaodata100. All rights reserved.
///  字符串MD5加密

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cstr, (uint32_t)strlen(cstr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
