//
//  UIDevice+Addition.h
//  MDMAgent
//
//  Created by liubin on 13-3-25.
//  Copyright (c) 2013年 winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AFIOSDEVICE = 0,
    AFIPHONE1G,
    AFIPHONE3G,
    AFIPHONE3GS,
    AFIPHONE4_GSM,
    AFIPHONE4_CDMA,
    AFIPHONE4S,
    AFIPHONE5_GSM,
    AFIPHONE5_CDMA,
    AFIPOD1,
    AFIPOD2,
    AFIPOD3,
    AFIPOD4,
    AFIPOD5,
    AFIPAD1,
    AFIPAD2_WIFI,
    AFIPAD2_GSM,
    AFIPAD2_CDMAV,
    AFIPAD2_CDMAS,
    AFNEWPAD_WIFI, // NewPad only WiFi
    AFNEWPAD_CDMA_CONFIGURED, // NewPad CDMA
    AFNEWPAD_GLOBAL, // NewPad GSM/CDMA
    AFIPADMINI_WIFI, // iPad mini only WiFi
    AFIPAD4_WIFI,
    AFSIMULATOR
} AFMachinePlatform;

@interface UIDevice (Addition)

/**
 * Get MAC address
 */
+ (NSString *)macAddress;

/**
 * Get device version
 */
+ (AFMachinePlatform)machinePlatform;

/**
 * Get device free space
 * freespace/1024/1024/1024 = B/KB/MB/14.02GB
 */
+ (NSNumber *)freeSpace;

/**
 * Get device total Space
 */
+ (NSNumber *)totalSpace;

/**
 * Get carrier name
 */
+ (NSString *)carrierName;

/**
 * Get carrier code
 */
+ (NSString *)carrierCode;

/**
 * Get battery value
 */
+ (CGFloat)getBatteryValue;

/**
 * Get battery state
 */
+ (NSInteger)getBatteryState;

// Get memory info
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;

@end
