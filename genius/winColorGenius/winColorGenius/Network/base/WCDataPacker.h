//
//  WCDataPacker.h
//  winCRM
//
//  Created by Cai Lei on 12/10/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString *InitStreetCode;
extern const NSString *InitHttpCode;

#define reverses(A) ((((uint16)(A) & 0xff00) >> 8) | \
(((uint16)(A) & 0x00ff) << 8))
#define reversel(A) ((((uint32)(A) & 0xff000000) >> 24) | \
(((uint32)(A) & 0x00ff0000) >> 8) | \
(((uint32)(A) & 0x0000ff00) << 8) | \
(((uint32)(A) & 0x000000ff) << 24))

@interface WCDataPacker : NSObject
@property (copy) NSString *salt;

+ (WCDataPacker *)sharedInstance;

- (NSData *)packForPostBody:(NSData *)aData;
- (NSData *)unpackForPostBody:(NSData *)aData;

- (NSString *)packForURLParam:(NSString *)aURLParam;
- (NSString *)unpackForURLParam:(NSString *)aURLParam;

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType;
- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType withFile:(NSData *)aFile;

- (UInt16)getResponseTypeTwoBytes:(const char *)aResponse
                           offset:(NSInteger)aOffset;
- (UInt16)getResponseErrorCodeTwoBytes:(const char *)aResponse
                                offset:(NSInteger)aOffset;
- (UInt32)getResponseContentLengthCodeFourBytes:(const char *)aResponse
                                         offset:(NSInteger)aOffset;
- (NSData *)getResponseContent:(const char *)aResponse
                        offset:(NSInteger)aOffset
                        length:(UInt32)aLength;
- (void)getResponseInfo:(const char *)aResponse
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
          contentLength:(UInt32 *)aContentLength
                content:(NSData **)aContent;
- (int)checkCPULittleEndian;
@end
