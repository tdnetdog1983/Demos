//
//  WCErrorCodeHelper.m
//  winCRM
//
//  Created by Cai Lei on 1/4/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WCErrorCodeHelper.h"
#import "WCPlistHelper.h"

@implementation WCErrorCodeHelper

+ (NSError *)errorForType:(UInt16)serviceType withErrorCode:(UInt32)errorCode {
    NSString *plistFilename = nil;
    if (errorCode < 128) {
        plistFilename = @"CommonError";
    } else {
        plistFilename = [NSString stringWithFormat:@"%dError", serviceType];
    }
    
    WCPlistHelper *plistHelper = [[WCPlistHelper alloc] initWithPlistNamed:plistFilename];
    NSDictionary *dict = [plistHelper allProperties];
    NSString *errorDescription = [dict objectForKey:[NSString stringWithFormat:@"%ld", errorCode]];
    if (!errorDescription) {
        errorDescription = NSLocalizedString(@"unknown error", nil);
    }
    
    NSError *error = [NSError errorWithDomain:@"WCService"
                                         code:errorCode
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                               errorDescription, NSLocalizedDescriptionKey,
                                               nil]
                      ];
    return error;
}

@end
