//
//  WC301Service.m
//  winCRM
//
//  Created by Cai Lei on 4/7/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WC301Service.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+Hash.h"
#import "WCErrorCodeHelper.h"

@implementation WC301Service {
    UInt16 _serviceType;
}

+ (NSString *)serviceType {
    return @"301";
}

- (id)init {
    self = [super init];
    if (self) {
        _serviceType = 301;
        _grp = [[WCGlobalSingleton sharedInstance] gGrp];
        _imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        _sw = @"crmi_loreal";
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *version = [prefs objectForKey:gSWVersion];
        if (version) {
            _ver = version;
        }
    }
    return self;
}

- (void)startWithBlock:(void(^)(NSString *ver, NSString *urlStr, NSError *error))serviceBlock {
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    if (!self.serviceURLString) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=%d&info=%@", self.serviceURLString, _serviceType, [packer packForURLParam:[self infoString]]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 120;
    request.requestMethod = @"GET";
    [request setCompletionBlock:^{
        UInt16 type = 0;
        UInt32 errorCode = 0;
        UInt32 contentLength = 0;
        NSData *contentData = nil;
        
        [packer getResponseInfo:[request.responseData bytes] type:&type errorCode:&errorCode contentLength:&contentLength content:&contentData];
        if(type == _serviceType && (errorCode == 0 || errorCode == 301000) && contentData)
        {
            NSData *responseData = [packer unpackForPostBody:contentData];
            
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"301 response: %@", responseString);
            NSDictionary *jsonDict = [responseString objectFromJSONString];
            
            NSArray *infoArray = [jsonDict objectForKey:@"info"];
            NSDictionary *infoDict = [infoArray lastObject];
            NSString *version = [infoDict objectForKey:@"ver"];
            NSString *urlString = [infoDict objectForKey:@"url"];
            
            serviceBlock(version, urlString, nil);
        } else {
            serviceBlock(nil, nil, [WCErrorCodeHelper errorForType:_serviceType withErrorCode:errorCode]);
        }
    }];
    
    [request setFailedBlock:^{
        serviceBlock(nil, nil, request.error);
    }];
    
    [request startAsynchronous];
}

- (NSString *)infoString {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.grp) {
        [dict setObject:self.grp forKey:@"grp"];
    }
    if (self.imei) {
        [dict setObject:self.imei forKey:@"imei"];
    }
    if (self.sw) {
        [dict setObject:self.sw forKey:@"sw"];
    }
    if (self.ver) {
        [dict setObject:self.ver forKey:@"ver"];
    }

    return [dict JSONString];
}

@end
