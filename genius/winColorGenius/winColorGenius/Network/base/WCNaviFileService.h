//
//  WCNaviFileService.h
//  winCRM
//
//  Created by Cai Lei on 1/4/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDataPacker.h"

@class WCNaviFileItem;

@protocol NaviFileDelegate <NSObject>

-(void)fetchNaviFileCompleteWithFileItem:(WCNaviFileItem *)aItem error:(NSError *)aError;

@end

@interface WCNaviFileService : NSObject
@property (nonatomic, copy) NSString *naviURLString;
@property (nonatomic, weak)id<NaviFileDelegate> delegate;

- (void)startWithBlock:(void(^)(WCNaviFileItem *retItem, NSError *error))serviceBlock;
-(void)startFetchNaviFile;
@end



@interface WCNaviFileItem : NSObject
@property (nonatomic, copy) NSString *encode;
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *isAnonymous;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, assign) BOOL loadFinished;

@property (nonatomic, copy) NSString *query;
@property (nonatomic, copy) NSString *upload;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *login;

@property (nonatomic, copy) NSString *sync;
@end