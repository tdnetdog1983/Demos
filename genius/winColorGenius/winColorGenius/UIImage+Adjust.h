//
//  UIImage+Adjust.h
//  CLDemos
//
//  Created by Cai Lei on 5/3/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CColorARGB.h"
extern const uint kAlphaThreshold;

@interface UIImage (Adjust)

+ (UIImage *)   adjustImage         :(UIImage *)aImage
                withColorARGB       :(const CColorARGB&)aColor
                withAlphaThreshold  :(NSUInteger)aThreshold
                forPoint            :(CGPoint)aPoint;

+ (UIImage *) adjustImage:(UIImage *)aImage changeFromColor:(const CColorARGB&)aSrcColor ToColor:(const CColorARGB&)aDesColor withThreshold:(uint)aThreshold;

+ (NSMutableArray *) genRegionArrayForImage:(UIImage *)aImage
                                 withSample:(const CColorARGB *)pSample
                             andSampleCount:(NSUInteger)countOfSample
                           similarThreshold:(uint)aThreshold
                                    stepLen:(uint)aStep;

+ (NSMutableArray *) genRegionArrayForImage:(UIImage *)aImage
                                 withSample:(const CColorARGB *)pSample
                             andSampleCount:(NSUInteger)countOfSample
                           similarThreshold:(uint)aThreshold
                                    stepLen:(uint)aStep
                                  borderGap:(uint)aGap;

@end
