//
//  WC101Service.h
//  winCRM
//
//  Created by Niu Zhaowang on 4/27/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WC101Service : NSObject

-(void)startWithBlock:(void(^)(NSString *token, NSError *err))serviceBlock;

@end
