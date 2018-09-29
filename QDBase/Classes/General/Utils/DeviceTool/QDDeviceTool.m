//
//  QDDeviceTool.m
//  QDBase
//
//  Created by qiaodata100 on 2018/9/29.
//  Copyright © 2018年 qiaodata100. All rights reserved.
/// 设备信息工具类

#import "QDDeviceTool.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation QDDeviceTool

+ (NSString *)getIDFA
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
+ (NSString *)getIDFV
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+ (NSString *)getMAC
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString *)getLogId {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    NSString *logid = [NSString stringWithFormat:@"uid_%@",[uuid lowercaseString]];
    
    return [logid MD5String];
}

+ (NSString *)getSystemVersion {
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return systemVersion;
}

+ (NSString *)getAppVersion {
    NSString *curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return curVersion;
}

@end
