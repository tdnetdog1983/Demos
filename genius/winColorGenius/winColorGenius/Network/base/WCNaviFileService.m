//
//  WCNaviFileService.m
//  winCRM
//
//  Created by Cai Lei on 1/4/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WCNaviFileService.h"
static NSString * const kDefaultNaviURL = @"http://118.144.79.231:8087/mdma_cccil.jpg";

@implementation WCNaviFileService

-(void)startFetchNaviFile
{
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    packer.salt = nil;
    NSURL *url = [NSURL URLWithString:self.naviURLString?self.naviURLString:kDefaultNaviURL];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    [request setCompletionBlock:^{
        NSData *responseData = [packer unpackForPostBody:[request responseData]];
        WCNaviFileItem *item = [self parseResponseData:responseData];
        packer.salt = item.salt;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fetchNaviFileCompleteWithFileItem:error:)])
        {
            [self.delegate performSelector:@selector(fetchNaviFileCompleteWithFileItem:error:) withObject:item withObject:nil];
        }
    }];
    
    [request setFailedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(fetchNaviFileCompleteWithFileItem:error:)])
        {
            [self.delegate performSelector:@selector(fetchNaviFileCompleteWithFileItem:error:) withObject:nil withObject:request.error];
        }
    }];
    
    [request startAsynchronous];
}
- (void)startWithBlock:(void(^)(WCNaviFileItem *retItem, NSError *error))serviceBlock {
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    packer.salt = nil;
    NSURL *url = [NSURL URLWithString:self.naviURLString?self.naviURLString:kDefaultNaviURL];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 60;
    request.requestMethod = @"GET";
    [request setCompletionBlock:^{
            NSData *responseData = [packer unpackForPostBody:[request responseData]];
            WCNaviFileItem *item = [self parseResponseData:responseData];

            packer.salt = item.salt;
        NSLog(@"packer.salt:%@", packer.salt);
            serviceBlock(item, nil);
    }];
    
    [request setFailedBlock:^{
        serviceBlock(nil, request.error);
    }];
    
    [request startAsynchronous];
}

- (WCNaviFileItem *)parseResponseData:(NSData *)responseData {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    DDLogVerbose(@"Navi Service : %@", responseString);
    
    NSDictionary *jsonDict = [responseString objectFromJSONString];
    
    WCNaviFileItem *item = [[WCNaviFileItem alloc] init];
    item.encode = [jsonDict objectForKey:@"encode"];
    item.ver = [jsonDict objectForKey:@"ver"];
    item.isAnonymous = [jsonDict objectForKey:@"isAnonymous"];
    item.salt = [jsonDict objectForKey:@"salt"];
    
    item.query = [jsonDict objectForKey:@"query"];
    item.upload = [jsonDict objectForKey:@"upload"];
    item.message = [jsonDict objectForKey:@"message"];
    item.login = [jsonDict objectForKey:@"login"];
    
    item.sync = [jsonDict objectForKey:@"sync"];
    
    return item;
}

@end



@implementation WCNaviFileItem

@end