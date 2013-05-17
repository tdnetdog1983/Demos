//
//  UIImage+Adjust.m
//  CLDemos
//
//  Created by Cai Lei on 5/3/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "UIImage+Adjust.h"
#import "UIImage+RawData.h"
#import <UIColor+Expanded.h>
#import <UIColor+HSV.h>
#import "CColorARGB.h"
const uint kAlphaThreshold = 60;

@implementation UIImage (Adjust)

+ (UIImage *)   adjustImage         :(UIImage *)aImage
                withColorARGB       :(const CColorARGB&)aColor
                withAlphaThreshold  :(NSUInteger)aThreshold
                forPoint            :(CGPoint)aPoint
{
    uint    width = aImage.size.width;
    uint    height = aImage.size.height;
    uint    x = (uint)aPoint.x;
    uint    y = (uint)aPoint.y;
    
    if (x >= width) {
        x = width * 0.5;
    }
    
    if (y >= height) {
        y = height * 0.5;
    }
    
    NSData      *data = [aImage rawImageData];
    CColorARGB  *pHead = (CColorARGB *)[data bytes];
    CColorARGB  pointColor = *(pHead + y * width + x);
    
    // calculate the delta bright between the color to adjust to and the color of given point
    float hue, saturation, bright;
    [UIColor    red     :pointColor._r / 255.f green:pointColor._g / 255.f blue:pointColor._b / 255.f
                toHue   :&hue saturation:&saturation brightness:&bright];
    float pointBright = bright;
    [UIColor    red     :aColor._r / 255.f green:aColor._g / 255.f blue:aColor._b / 255.f
                toHue   :&hue saturation:&saturation brightness:&bright];
    float deltaBright = bright - pointBright;
    
    if ((aPoint.x == CGFLOAT_MAX) || (aPoint.y == CGFLOAT_MAX)) {
        deltaBright = 0;
    }
    
    
    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            CColorARGB *pPixelHead = pHead + row * width + col;
            
            // filter alpha by threshold
            if (pPixelHead->_a < aThreshold) {
                pPixelHead->_a = 0;
                continue;
            }
            
            [UIColor    red     :pPixelHead->_r / 255.f green:pPixelHead->_g / 255.f blue:pPixelHead->_b / 255.f
                        toHue   :&hue saturation:&saturation brightness:&bright];
            [UIColor    red     :aColor._r / 255.f green:aColor._g / 255.f blue:aColor._b / 255.f
                        toHue   :&hue saturation:&saturation brightness:NULL];
            bright = bright + deltaBright;
            bright = MIN(MAX(bright, 0), 1);
            
            float r, g, b;
            [UIColor    hue     :hue saturation:saturation brightness:bright
                        toRed   :&r green:&g blue:&b];
            pPixelHead->_r = r*255;
            pPixelHead->_g = g*255;
            pPixelHead->_b = b*255;
        }
    }
    
    UIImage *retImage = [UIImage imageWithRawImageData:data width:width height:height];
    return retImage;
}

+ (NSMutableArray *) genRegionArrayForImage:(UIImage *)aImage
                                 withSample:(const CColorARGB *)pSample
                             andSampleCount:(NSUInteger)countOfSample
                           similarThreshold:(uint)aThreshold
                                    stepLen:(uint)aStep
{
    return [self genRegionArrayForImage:aImage withSample:pSample andSampleCount:countOfSample similarThreshold:aThreshold stepLen:aStep borderGap:0];
}

+ (NSMutableArray *) genRegionArrayForImage:(UIImage *)aImage
                                 withSample:(const CColorARGB *)pSample
                             andSampleCount:(NSUInteger)countOfSample
                           similarThreshold:(uint)aThreshold
                                    stepLen:(uint)aStep
                                  borderGap:(uint)aGap
{
    uint width = (uint)aImage.size.width;
    uint height = (uint)aImage.size.height;
    
    if ((aGap * 2 > width) || (aGap * 2 > height)) {
        aGap = 0;
    }
    
    NSMutableArray *sampleArray = [NSMutableArray arrayWithCapacity:countOfSample];
    // the first member is the sample color
    for (int i = 0; i < countOfSample; i++) {
        CColorPoint *colorPoint = [[CColorPoint alloc] init];
        colorPoint.colorARGB = pSample[i];
        NSMutableArray *singleArray = [NSMutableArray arrayWithObject:colorPoint];
        [sampleArray addObject:singleArray];
    }
    
    CColorARGB  *pHead = (CColorARGB *)[[aImage rawImageData] bytes];
    // group similar colors into regions
    for (int row = aGap; row < height-aGap; row+=aStep) {
        for (int col = aGap; col < width-aGap; col+=aStep) {
            CColorARGB currentColor = *(pHead + row * width + col);
            for (int j = 0; j < countOfSample; j++) {
                if (areTwoColorsSimilar(pSample[j], currentColor, aThreshold)) {
                    CColorPoint *colorPoint = [[CColorPoint alloc] init];
                    colorPoint.x = col;
                    colorPoint.y = row;
                    colorPoint.colorARGB = currentColor;
                    NSMutableArray *arr = [sampleArray objectAtIndex:j];
                    [arr addObject:colorPoint];
                    //break;
                }
            }
        }
    }
    
    // sort regions
    [sampleArray sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        int c1 = [(NSArray *)obj1 count];
        int c2 = [(NSArray *)obj2 count];
        if (c1 < c2) return NSOrderedAscending;
        if (c1 > c2) return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    return  sampleArray;
}

+ (UIImage *) adjustImage:(UIImage *)aImage changeFromColor:(const CColorARGB&)aSrcColor ToColor:(const CColorARGB&)aDesColor withThreshold:(uint)aThreshold
{
    uint    width = aImage.size.width;
    uint    height = aImage.size.height;

    NSData      *data = [aImage rawImageData];
    CColorARGB  *pHead = (CColorARGB *)[data bytes];
    uint deltaR = aDesColor._r - aSrcColor._r;
    uint deltaG = aDesColor._g - aSrcColor._g;
    uint deltaB = aDesColor._b - aSrcColor._b;
    
    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            CColorARGB *pPixelHead = pHead + row * width + col;
            if (areTwoColorsSimilar(aSrcColor, *pPixelHead, aThreshold)) {
                pPixelHead->_r = MIN(255, MAX(0, pPixelHead->_r + deltaR));
                pPixelHead->_g = MIN(255, MAX(0, pPixelHead->_g + deltaG));
                pPixelHead->_b = MIN(255, MAX(0, pPixelHead->_b + deltaB));
                
                pPixelHead->_a = aDesColor._a;
            }
        }
    }
    
    UIImage *retImage = [UIImage imageWithRawImageData:data width:width height:height];
    return retImage;
}

@end
