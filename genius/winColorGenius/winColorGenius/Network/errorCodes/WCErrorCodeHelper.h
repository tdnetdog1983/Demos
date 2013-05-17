//
//  WCErrorCodeHelper.h
//  winCRM
//
//  Created by Cai Lei on 1/4/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCErrorCodeHelper : NSObject

+ (NSError *)errorForType:(UInt16)serviceType withErrorCode:(UInt32)errorCode;

@end
