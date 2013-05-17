//
//  CL434Service.m
//  winColorGenius
//
//  Created by jiang on 13-5-9.
//  Copyright (c) 2013年 com.winchannel. All rights reserved.
//

#import "CL434Service.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+Hash.h"
#import "ASIFormDataRequest.h"
#import "WCErrorCodeHelper.h"
#import "UIDevice-Hardware.h"

@implementation CL434Service{
    UInt16 _serviceType;
}

+ (NSString *)serviceType {
    return @"434";
}

-(id)init
{
    if(self = [super init])
    {
        _serviceType = 434;
        _token = [[WCGlobalSingleton sharedInstance] gToken];
        _imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        _platform = [[WCGlobalSingleton sharedInstance] gPlatform];
        _grp = [[WCGlobalSingleton sharedInstance] gGrp];
        _lang = [[WCGlobalSingleton sharedInstance] gLang];
        _ver = [[WCGlobalSingleton sharedInstance] gVer];
        _src = [[WCGlobalSingleton sharedInstance] gSrc];
        _colorR = @"184";
        _colorG = @"204";
        _colorB = @"228";
        _moment = @"Day";
        _mix = @"Matches";
    }
    return  self;
}


- (void)startWithBlock:(void(^)(NSArray *resultArr, NSError *error))serviceBlock {
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    NSURL *url = [NSURL URLWithString:self.serviceURLString];
    ASIFormDataRequest *requestStrong = [[ASIFormDataRequest alloc] initWithURL:url];
    __block ASIFormDataRequest *request = requestStrong;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setRequestMethod:@"POST"];
    [request setFile:[self genPostBody]
        withFileName:@"file"
      andContentType:@"application/octet-stream"
              forKey:@"upload"];
    
    [request setCompletionBlock:^{
        UInt16 type = 0;
        UInt32 errorCode = 0;
        UInt32 contentLength = 0;
        NSData *contentData = nil;
        
        [packer getResponseInfo:[request.responseData bytes] type:&type errorCode:&errorCode contentLength:&contentLength content:&contentData];

        if (errorCode != 43401) {
            NSData *responseData = [packer unpackForPostBody:contentData];
            NSArray *arr = [self parseResponseData:responseData];
            serviceBlock(arr,nil);
        }
        else{
            serviceBlock(nil,[WCErrorCodeHelper errorForType:_serviceType withErrorCode:errorCode]);
        }
    }];
    
    [request setFailedBlock:^{
        serviceBlock(nil,request.error);
    }];
    
    [request startAsynchronous];
}

- (NSData *)genPostBody {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.token) {
        [dict setObject:self.token forKey:@"token"];
    }
    if (self.imei) {
        [dict setObject:self.imei forKey:@"imei"];
    }
    if (self.platform) {
        [dict setObject:self.platform forKey:@"platform"];
    }
    if (self.grp) {
        [dict setObject:self.grp forKey:@"grp"];
    }
    if (self.lang) {
        [dict setObject:self.lang forKey:@"lang"];
    }
    if (self.ver) {
        [dict setObject:self.ver forKey:@"ver"];
    }
    if (self.src) {
        [dict setObject:self.src forKey:@"src"];
    }
    if (self.colorR) {
        [dict setObject:self.colorR forKey:@"colorR"];
    }
    if (self.colorG) {
        [dict setObject:self.colorG forKey:@"colorG"];
    }
    if (self.colorB) {
        [dict setObject:self.colorB forKey:@"colorB"];
    }
    if (self.moment) {
        [dict setObject:self.moment forKey:@"moment"];
    }
    if (self.mix) {
        [dict setObject:self.mix forKey:@"mix"];
    }
    
    NSLog(@"%@", [dict JSONString]);
    
    WCDataPacker *packer = [WCDataPacker sharedInstance];
    return [packer generatePost:[packer packForPostBody:[dict JSONData]] forType:_serviceType];
}

- (NSArray *)parseResponseData:(NSData *)responseData {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"434 get product code: %@", responseString);
    NSDictionary *jsonDict = [responseString objectFromJSONString];
    NSArray *items = [jsonDict objectForKey:@"items"];
    
    NSMutableArray *productArray = [NSMutableArray arrayWithCapacity:[items count]];
    for (NSDictionary *itemDict in items) {
        NSLog(@"resurl:%@",[itemDict objectForKey:@"resurl"]);
        CLProductInfo *retProduct = [[CLProductInfo alloc] init];
        retProduct.isleaf = [itemDict objectForKey:@"isleaf"];
        retProduct.treecode = [itemDict objectForKey:@"treecode"];
        retProduct.color = [itemDict objectForKey:@"color"];
        retProduct.resname = [itemDict objectForKey:@"resname"];
        retProduct.resdesc = [itemDict objectForKey:@"resdesc"];
        retProduct.resurl = [itemDict objectForKey:@"resurl"];
        retProduct.ressuburl = [itemDict objectForKey:@"ressuburl"];
        retProduct.showurl = [itemDict objectForKey:@"showurl"];
        retProduct.memo1 = [itemDict objectForKey:@"memo1"];
        retProduct.memo2 = [itemDict objectForKey:@"memo2"];
        retProduct.memo3 = [itemDict objectForKey:@"memo3"];
        retProduct.memo4 = [itemDict objectForKey:@"memo4"];
        retProduct.memo5 = [itemDict objectForKey:@"memo5"];
        retProduct.memo7 = [itemDict objectForKey:@"memo7"];
        retProduct.memo8 = [itemDict objectForKey:@"memo8"];
        retProduct.memo9 = [itemDict objectForKey:@"memo9"];
        retProduct.memo10 = [itemDict objectForKey:@"memo10"];
        retProduct.memo11 = [itemDict objectForKey:@"memo11"];
        retProduct.tmallurl = [itemDict objectForKey:@"tmallurl"];
        [productArray addObject:retProduct];
    }
    return productArray;
}
@end

@implementation CLProductInfo
@end
