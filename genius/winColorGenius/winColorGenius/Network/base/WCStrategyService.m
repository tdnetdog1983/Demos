//
//  WCStategyService.m
//  winCRM
//
//  Created by Cai Lei on 1/5/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WCStrategyService.h"
#import "WCErrorCodeHelper.h"


@implementation WCStrategyService {
    UInt16 _serviceType;
    
    NSMutableArray *_getArray;
    NSMutableArray *_actionArray;
    NSMutableArray *_postArray;
}

- (id)init {
    self = [super init];
    if (self) {
        _platform = @"crmi_loreal";
        _serviceType = 302;
        _src = [WCGlobalSingleton sharedInstance].gSrc;
        _imei = [WCGlobalSingleton sharedInstance].gIMEI;
        _lang = [WCGlobalSingleton sharedInstance].gLang;
    }
    return self;
}

- (void)startWithBlock:(void(^)(NSArray *retGetArray, NSArray *retActionArray, NSArray *retPostArray, NSError *error))serviceBlock {
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@?type=%d&info=%@", self.strategyURLString?self.strategyURLString:kDefaultStrategyURL, _serviceType, [packer packForURLParam:[self infoString]]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    [request setCompletionBlock:^{
        UInt16 type = 0;
        UInt32 errorCode = 0;
        UInt32 contentLength = 0;
        NSData *contentData = nil;
        
        [packer getResponseInfo:[request.responseData bytes] type:&type errorCode:&errorCode contentLength:&contentLength content:&contentData];
        if(type == _serviceType && errorCode == 0 && contentData)
        {
            if (![contentData length]) {
                //DDLogError(@"%d request error", _serviceType);
            }

            NSData *responseData = [packer unpackForPostBody:contentData];
            if (!responseData) {
                //DDLogError(@"%d request error", _serviceType);
            }
            
            [self parseResponseData:responseData];
            serviceBlock(_getArray, _actionArray, _postArray, nil);
        } else {
            serviceBlock(nil, nil, nil, [WCErrorCodeHelper errorForType:_serviceType withErrorCode:errorCode]);
        }
    }];
    
    [request setFailedBlock:^{
        serviceBlock(nil, nil, nil, request.error);
    }];
    
    [request startAsynchronous];
}

- (NSString *)infoString {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.token) {
        [dict setObject:self.token forKey:@"token"];
    }
    
    if (self.grp) {
        [dict setObject:self.grp forKey:@"grp"];
    }
    
    if (self.ver) {
        [dict setObject:self.ver forKey:@"ver"];
    }
    
    if (self.platform) {
        [dict setObject:self.platform forKey:@"platform"];
    }
    
    if (self.deviceToken) {
        [dict setObject:self.deviceToken forKey:@"deviceToken"];
    }
    if (self.src) {
        [dict setObject:self.src forKey:@"src"];
    }
    
    if (self.imei) {
        [dict setObject:self.imei forKey:@"imei"];
    }
    if (self.lang) {
        [dict setObject:self.lang forKey:@"lang"];
    }
    
    return [dict JSONString];
}

- (void)parseResponseData:(NSData *)responseData {
    _getArray = [[NSMutableArray alloc] init];
    _actionArray = [[NSMutableArray alloc] init];
    _postArray = [[NSMutableArray alloc] init];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"302 strategy: %@", responseString);
    NSDictionary *jsonDict = [responseString objectFromJSONString];
    
    NSArray *gets = [jsonDict objectForKey:@"get"];
    NSArray *actions = [jsonDict objectForKey:@"action"];
    NSArray *posts = [jsonDict objectForKey:@"post"];
    
    [self generateStrategyItemArray:_getArray withJsonArray:gets];
    [self generateStrategyItemArray:_actionArray withJsonArray:actions];
    [self generateStrategyItemArray:_postArray withJsonArray:posts];
}

- (void)generateStrategyItemArray:(NSMutableArray *)outArray withJsonArray:(NSArray *)inArray {
    for (NSDictionary *dict in inArray) {
        WCStrategyItem *item = [[WCStrategyItem alloc] init];
        item.type = [dict objectForKey:@"type"];
        item.actionid = [dict objectForKey:@"actionid"];
        item.delay = [dict objectForKey:@"delay"];
        item.extras = [dict objectForKey:@"extras"];
        
        [outArray addObject:item];
    }
}

@end



@implementation WCStrategyItem

@end
