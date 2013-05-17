//
//  UIDevice+Addition.m
//  MDMAgent
//
//  Created by liubin on 13-3-25.
//  Copyright (c) 2013年 winchannel. All rights reserved.
//

#import "UIDevice+Addition.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/mount.h>
#import <mach/mach.h>

@implementation UIDevice (Addition)

+ (NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        return nil;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        return nil;
    }
    if ((buf = malloc(len)) == NULL)
    {
        return nil;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        free(buf);
        return nil;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *address = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return address;
}

+ (AFMachinePlatform)machinePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineModel = [NSString stringWithUTF8String:machine];
    free(machine);
    
    // iPhone
    if ([machineModel isEqualToString:@"iPhone1, 1"]) return AFIPHONE1G;
    if ([machineModel isEqualToString:@"iPhone1, 2"]) return AFIPHONE3G;
    if ([machineModel isEqualToString:@"iPhone2, 1"]) return AFIPHONE3GS;
    if ([machineModel isEqualToString:@"iPhone3, 1"]) return AFIPHONE4_GSM;
    if ([machineModel isEqualToString:@"iPhone3, 3"]) return AFIPHONE4_CDMA;
    if ([machineModel isEqualToString:@"iPhone4, 1"]) return AFIPHONE4S;
    if ([machineModel isEqualToString:@"iPhone5, 1"]) return AFIPHONE5_GSM;
    if ([machineModel isEqualToString:@"iPhone5, 2"]) return AFIPHONE5_CDMA;
    
    // iPod
    if ([machineModel isEqualToString:@"iPod1, 1"]) return AFIPOD1;
    if ([machineModel isEqualToString:@"iPod2, 1"]) return AFIPOD2;
    if ([machineModel isEqualToString:@"iPod3, 1"]) return AFIPOD3;
    if ([machineModel isEqualToString:@"iPod4, 1"]) return AFIPOD4;
    if ([machineModel isEqualToString:@"iPod5, 1"]) return AFIPOD5;
    
    // iPad
    if ([machineModel isEqualToString:@"iPad1, 1"]) return AFIPAD1;
    if ([machineModel isEqualToString:@"iPad2, 1"]) return AFIPAD2_WIFI;
    if ([machineModel isEqualToString:@"iPad2, 2"]) return AFIPAD2_GSM;
    if ([machineModel isEqualToString:@"iPad2, 3"]) return AFIPAD2_CDMAV;
    if ([machineModel isEqualToString:@"iPad2, 4"]) return AFIPAD2_CDMAS;
    if ([machineModel isEqualToString:@"iPad2, 5"]) return AFIPADMINI_WIFI;
    if ([machineModel isEqualToString:@"iPad3, 1"]) return AFNEWPAD_WIFI;
    if ([machineModel isEqualToString:@"iPad3, 2"]) return AFNEWPAD_CDMA_CONFIGURED;
    if ([machineModel isEqualToString:@"iPad3, 3"]) return AFNEWPAD_GLOBAL;
    if ([machineModel isEqualToString:@"iPad4, 1"]) return AFIPAD4_WIFI;
    
    // Simulator
    if ([machineModel isEqualToString:@"i386"]) return AFSIMULATOR;
    if ([machineModel isEqualToString:@"x86_64"]) return AFSIMULATOR;
    
    return AFIOSDEVICE;
}

+ (NSNumber *)freeSpace
{
    struct statfs buf;
    long long freespace = -1;
    if (statfs("/private/var", &buf) >= 0)
    {
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    
    return [NSNumber numberWithLongLong:freespace];
}

+ (NSNumber *)totalSpace
{
	struct statfs buf;
	long long totalspace = -1;
	if (statfs("/private/var", &buf) >= 0)
    {
		totalspace = (long long)buf.f_bsize * buf.f_blocks;
	}
    
	return [NSNumber numberWithLongLong:totalspace];
}

+ (NSString *)carrierName
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    [netInfo release];
    
    if (carrier == nil) return @"";
    
    return [carrier carrierName];
}

+ (NSString *)carrierCode
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    [netInfo release];
    
    if (carrier == nil) return @"";
    
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    return [NSString stringWithFormat:@"%@%@", mcc, mnc];
}

+ (CGFloat)getBatteryValue
{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryLevel;
}

+ (NSInteger)getBatteryState
{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryState;
}

+ (unsigned int)freeMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+ (unsigned int)usedMemory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0;
}

@end
