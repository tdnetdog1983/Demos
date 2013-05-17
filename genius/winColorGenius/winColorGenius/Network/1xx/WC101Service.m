//
//  WC101Service.m
//  winCRM
//
//  Created by Niu Zhaowang on 4/27/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WC101Service.h"

@interface WC101Service()

@property (nonatomic,strong)ASIHTTPRequest *request;

@end

@implementation WC101Service

-(void)startWithBlock:(void(^)(NSString *token, NSError *err))serviceBlock
{
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@?type=101&info=%@", [WCGlobalSingleton sharedInstance].gNaviFileItem.login, [packer packForURLParam:[self infoString]]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.request clearDelegatesAndCancel];
    self.request = [ASIHTTPRequest requestWithURL:url];
    self.request.timeOutSeconds = 60;
    self.request.requestMethod = @"GET";
    [self.request setCompletionBlock:^{
        
        UInt16 type = 0;
        UInt32 errorCode = 0;
        UInt32 contentLength = 0;
        NSData *contentData = nil;
        
        [packer getResponseInfo:[_request.responseData bytes] type:&type errorCode:&errorCode contentLength:&contentLength content:&contentData];
        if(type == 101 && (errorCode == 0 || errorCode == 101000) && contentData)
        {
            NSData *responseData = [packer unpackForPostBody:contentData];
            
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"101 response: %@", responseString);
            NSDictionary *jsonDict = [responseString objectFromJSONString];
            NSString *tokenString = [jsonDict objectForKey:@"token"];
       
            serviceBlock(tokenString, nil);
        } else {
            serviceBlock(nil, _request.error);
        }
    }];
    
    [self.request setFailedBlock:^{
        serviceBlock(nil,_request.error);
    }];
    
    [self.request startAsynchronous];
}
- (NSString *)infoString {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"anonymous" forKey:@"user"];
    [dict setValue:@"anonymous_123" forKey:@"pwd"];
    [dict setValue:[WCGlobalSingleton sharedInstance].gGrp forKey:@"grp"];
    [dict setValue:[WCGlobalSingleton sharedInstance].gIMEI forKey:@"imei"];
    [dict setValue:[WCGlobalSingleton sharedInstance].gVer forKey:@"ver"];
    [dict setValue:[WCGlobalSingleton sharedInstance].gSw forKey:@"sw"];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [dict setValue:[formater stringFromDate:[NSDate date]] forKey:@"time"];
    [dict setValue:[WCGlobalSingleton sharedInstance].gLang forKey:@"lang"];
    
    return [dict JSONString];
}

@end
