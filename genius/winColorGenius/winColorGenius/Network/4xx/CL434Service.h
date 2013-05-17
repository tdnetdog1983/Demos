//
//  CL434Service.h
//  winColorGenius
//
//  Created by jiang on 13-5-9.
//  Copyright (c) 2013年 com.winchannel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLProductInfo;
@interface CL434Service : NSObject
@property (nonatomic, copy) NSString *serviceURLString;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *grp;
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *colorR;
@property (nonatomic, copy) NSString *colorG;
@property (nonatomic, copy) NSString *colorB;
@property (nonatomic, copy) NSString *moment;
@property (nonatomic, copy) NSString *mix;

+ (NSString *)serviceType;
- (void)startWithBlock:(void(^)(NSArray *resultArr, NSError *error))serviceBlock;
@end

@interface CLProductInfo : NSObject

@property (nonatomic, copy) NSString *isleaf;
@property (nonatomic, copy) NSString *treecode;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *resname;
@property (nonatomic, copy) NSString *resdesc;
@property (nonatomic, copy) NSString *resurl;
@property (nonatomic, copy) NSString *ressuburl;
@property (nonatomic, copy) NSString *showurl;
@property (nonatomic, copy) NSString *memo1;
@property (nonatomic, copy) NSString *memo2;
@property (nonatomic, copy) NSString *memo3;
@property (nonatomic, copy) NSString *memo4;
@property (nonatomic, copy) NSString *memo5;
@property (nonatomic, copy) NSString *memo7;
@property (nonatomic, copy) NSString *memo8;
@property (nonatomic, copy) NSString *memo9;
@property (nonatomic, copy) NSString *memo10;
@property (nonatomic, copy) NSString *memo11;
@property (nonatomic, copy) NSString *tmallurl;

@end

