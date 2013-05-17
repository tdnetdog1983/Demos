//
//  WCStategyService.h
//  winCRM
//
//  Created by Cai Lei on 1/5/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDataPacker.h"

@interface WCStrategyService : NSObject
@property (nonatomic, copy) NSString *strategyURLString;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *grp;
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *lang;

@property (nonatomic, copy) NSString *deviceToken;

- (void)startWithBlock:(void(^)(NSArray *retGetArray, NSArray *retActionArray, NSArray *retPostArray, NSError *error))serviceBlock;
@end



@interface WCStrategyItem : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *actionid;
@property (nonatomic, copy) NSString *delay;
@property (nonatomic, copy) NSDictionary *extras;

@end