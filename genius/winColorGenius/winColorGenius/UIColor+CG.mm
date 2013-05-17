//
//  UIColor+CG.m
//  winColorGenius
//
//  Created by Cai Lei on 5/13/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "UIColor+CG.h"
#import "CColorARGB.h"
#define HEXCOLOR(c) [UIColor colorWithRGBHex:c]

@implementation UIColor (CG)

static const uint kTolerance = 3;

- (UIColor *)textColorSuitable {
    UIColor *retTextColor = [UIColor whiteColor];
    
    //    CColorARGB pSample[] = {
    //        CColorARGB(0xff, 184, 204, 228),
    //        CColorARGB(0xff, 230, 184, 183),
    //        CColorARGB(0xff, 255, 255, 153),
    //        CColorARGB(0xff, 204, 255, 153),
    //        CColorARGB(0xff, 51, 51, 204),
    //
    //        CColorARGB(0xff, 102, 153, 0),
    //        CColorARGB(0xff, 204, 0, 0),
    //        CColorARGB(0xff, 255, 255, 0),
    //        CColorARGB(0xff, 204, 0, 102),
    //        CColorARGB(0xff, 226, 107, 10),
    //
    //        CColorARGB(0xff, 153, 51, 255),
    //        CColorARGB(0xff, 102, 153, 255),
    //        CColorARGB(0xff, 238, 236, 225),
    //        CColorARGB(0xff, 255, 255, 255),
    //        CColorARGB(0xff, 207, 207, 207),
    //
    //        CColorARGB(0xff, 89, 89, 89),
    //        CColorARGB(0xff, 0, 0, 0),
    //        CColorARGB(0xff, 122, 122, 122),
    //        CColorARGB(0xff, 0, 32, 96),
    //        CColorARGB(0xff, 0, 102, 0),
    //
    //        CColorARGB(0xff, 204, 102, 0),
    //        CColorARGB(0xff, 204, 0, 255),
    //        CColorARGB(0xff, 153, 0, 0),
    //    };
    
    NSArray *textColors = @[
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            [UIColor whiteColor],
                            ];
    
    uint r = self.red * 255;
    uint g = self.green * 255;
    uint b = self.blue * 255;
    
    for (uint i = 0; i < sizeof(pSample)/sizeof(CColorARGB); i++) {
        CColorARGB sColor = pSample[i];
        if  ((abs(r - sColor._r) < kTolerance) &&
             (abs(g - sColor._g) < kTolerance) &&
             (abs(b - sColor._b) < kTolerance))
        {
            retTextColor = [textColors objectAtIndex:i];
            break;
        }
    }
    
    return retTextColor;
}

- (NSArray *)fetchThreeColors {
    NSArray *threeColorsArray = @[
                                  @[HEXCOLOR(0xe16992),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xb864f5),HEXCOLOR(0x021e8d),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xb864f5)],
                                  @[HEXCOLOR(0xe16992),HEXCOLOR(0xf0b1b2),HEXCOLOR(0x021e8d),HEXCOLOR(0xf435fe),HEXCOLOR(0x88636c),HEXCOLOR(0x021e8d)],
                                  @[HEXCOLOR(0xef6002),HEXCOLOR(0xec6167),HEXCOLOR(0xc50228),HEXCOLOR(0xef6002),HEXCOLOR(0xec6167),HEXCOLOR(0x461161)],
                                  @[HEXCOLOR(0xaeeb34),HEXCOLOR(0x88636c),HEXCOLOR(0xef6002),HEXCOLOR(0x188a04),HEXCOLOR(0x021e8d),HEXCOLOR(0xef6002)],
                                  @[HEXCOLOR(0x007fe8),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xb864f5),HEXCOLOR(0x021e8d),HEXCOLOR(0x81eaf3),HEXCOLOR(0xb864f5)],
                                  @[HEXCOLOR(0x188a04),HEXCOLOR(0xb864f5),HEXCOLOR(0xef6002),HEXCOLOR(0x1f7b5c),HEXCOLOR(0x007fe8),HEXCOLOR(0xef6002)],
                                  @[HEXCOLOR(0xc50228),HEXCOLOR(0x6a0214),HEXCOLOR(0x81eaf3),HEXCOLOR(0xc50228),HEXCOLOR(0x6a0214),HEXCOLOR(0x007fe8)],
                                  @[HEXCOLOR(0xef6002),HEXCOLOR(0xec6167),HEXCOLOR(0xb864f5),HEXCOLOR(0xef6002),HEXCOLOR(0xec6167),HEXCOLOR(0xc50228)],
                                  @[HEXCOLOR(0xf4239f),HEXCOLOR(0x88636c),HEXCOLOR(0x021e8d),HEXCOLOR(0x6a0214),HEXCOLOR(0x88636c),HEXCOLOR(0x021e8d)],
                                  @[HEXCOLOR(0xfe1114),HEXCOLOR(0xec6167),HEXCOLOR(0xaeeb34),HEXCOLOR(0xfe1114),HEXCOLOR(0xb864f5),HEXCOLOR(0x188a04)],
                                  @[HEXCOLOR(0xb864f5),HEXCOLOR(0xfe7fef),HEXCOLOR(0xffe93a),HEXCOLOR(0xb864f5),HEXCOLOR(0xf4239f),HEXCOLOR(0xffe93a)],
                                  @[HEXCOLOR(0x81eaf3),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xef6002),HEXCOLOR(0x007fe8),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xaeeb34)],
                                  @[HEXCOLOR(0xf0b1b2),HEXCOLOR(0xd1a4b8),HEXCOLOR(0xb864f5),HEXCOLOR(0xf0b1b2),HEXCOLOR(0x88636c),HEXCOLOR(0xb864f5)],
                                  @[HEXCOLOR(0xedcdd2),HEXCOLOR(0xd1a4b8),HEXCOLOR(0xb864f5),HEXCOLOR(0xf0b1b2),HEXCOLOR(0xe16992),HEXCOLOR(0x461161)],
                                  @[HEXCOLOR(0xedcdd2),HEXCOLOR(0x88636c),HEXCOLOR(0x6a0214),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xedcdd2),HEXCOLOR(0x1f7b5c)],
                                  @[HEXCOLOR(0x88636c),HEXCOLOR(0xf0b1b2),HEXCOLOR(0xf4239f),HEXCOLOR(0xd1a4b8),HEXCOLOR(0x88636c),HEXCOLOR(0xedcdd2)],
                                  @[HEXCOLOR(0xe16992),HEXCOLOR(0x88636c),HEXCOLOR(0xfe1114),HEXCOLOR(0x021e8d),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xf21172)],
                                  @[HEXCOLOR(0x6f6e8e),HEXCOLOR(0xedcdd2),HEXCOLOR(0x1f7b5c),HEXCOLOR(0x6f6e8e),HEXCOLOR(0x88636c),HEXCOLOR(0x007fe8)],
                                  @[HEXCOLOR(0x007fe8),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xef6002),HEXCOLOR(0x021e8d),HEXCOLOR(0x6f6e8e),HEXCOLOR(0xef6002)],
                                  @[HEXCOLOR(0x1f7b5c),HEXCOLOR(0x007fe8),HEXCOLOR(0xef6002),HEXCOLOR(0x1f7b5c),HEXCOLOR(0x021e8d),HEXCOLOR(0xef6002)],
                                  @[HEXCOLOR(0xf0b1b2),HEXCOLOR(0xf0b1b2),HEXCOLOR(0xb864f5),HEXCOLOR(0xec6167),HEXCOLOR(0x88636c),HEXCOLOR(0xb864f5)],
                                  @[HEXCOLOR(0xb864f5),HEXCOLOR(0xf435fe),HEXCOLOR(0xffe93a),HEXCOLOR(0xb864f5),HEXCOLOR(0xf4239f),HEXCOLOR(0xef6002)],
                                  @[HEXCOLOR(0xc50228),HEXCOLOR(0x461161),HEXCOLOR(0x1f7b5c),HEXCOLOR(0x6a0214),HEXCOLOR(0x6a0214),HEXCOLOR(0x6f6e8e)],
                                  
                                  @[HEXCOLOR(0xfe1114), HEXCOLOR(0xfe1114), HEXCOLOR(0xfe1114)],  @[HEXCOLOR(0xfe1114), HEXCOLOR(0xfbfbfb), HEXCOLOR(0xedcdd2)],// 默认color
                                  ];
    
    uint r = self.red * 255;
    uint g = self.green * 255;
    uint b = self.blue * 255;
    
    uint i = 0;
    for (; i < sizeof(pSample)/sizeof(CColorARGB); i++) {
        CColorARGB sColor = pSample[i];
        if  ((abs(r - sColor._r) < kTolerance) &&
             (abs(g - sColor._g) < kTolerance) &&
             (abs(b - sColor._b) < kTolerance))
        {
            break;
        }
    }
    
    return [threeColorsArray objectAtIndex:i];
}

- (UIImage *)buttonBGImageForRect:(CGRect)aRect {
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *topColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:1.0*self.brightness alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:0.9*self.brightness alpha:1.0];
    // top
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake(0, 0, aRect.size.width, aRect.size.height*0.5));
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, topColor.CGColor);
    CGContextFillRect(context, aRect);
    CGContextRestoreGState(context);
    // bottom
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake(0, aRect.size.height*0.5, aRect.size.width, aRect.size.height*0.5));
    CGContextClip(context);
    NSArray *colors = [NSArray arrayWithObjects:(id)bottomColor.CGColor, (id)topColor.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,aRect.size.height*0.5), CGPointMake(0,aRect.size.height), 0);
    CGContextRestoreGState(context);

    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage;
}


@end
