//
//  WC301Service.h
//  winCRM
//
//  Created by Cai Lei on 4/7/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WC301Service : NSObject
@property (nonatomic, copy) NSString *serviceURLString;

@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *sw;
@property (nonatomic, copy) NSString *grp;

+ (NSString *)serviceType;
- (void)startWithBlock:(void(^)(NSString *ver, NSString *urlStr, NSError *error))serviceBlock;
- (void)cancel;

@end
