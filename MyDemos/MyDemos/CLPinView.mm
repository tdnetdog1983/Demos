//
//  CLPinView.m
//  MyDemos
//
//  Created by Cai Lei on 4/25/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLPinView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+RawData.h"
#import <UIColor+Expanded.h>

@implementation CLPinView {
    float _timeOffset;
}

- (void)awakeFromNib {
    CGRect frame = self.arrowImageView.frame;
    CGFloat y = frame.origin.y + frame.size.height*0.5;
    frame.origin.y = y;
    self.arrowImageView.frame = frame;
    
    self.contentImageView.hidden = YES;
    self.arrowImageView.hidden = YES;
}

- (void)showForPosition:(CGPoint)position {
    position.x -= self.bounds.size.width*0.5;
    self.frame = CGRectMake(position.x, position.y, self.bounds.size.width, self.bounds.size.height);
    _timeOffset = 0.0f;
    //*/
    self.contentImageView.hidden = NO;
    
    float duration = 0.6f;
    CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fall.fromValue = [NSNumber numberWithFloat:2.f];
    fall.toValue = [NSNumber numberWithFloat:1.f];
    fall.duration = duration;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = [NSNumber numberWithFloat:0.f];
    fade.toValue = [NSNumber numberWithFloat:1.f];
    fade.duration = duration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:fall, fade, nil];
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //group.beginTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil] + _timeOffset;
    group.delegate = self;
    
    [self.contentImageView.layer addAnimation:group forKey:@"content"];
    _timeOffset += duration;
}

- (void)showForPositionWithNSValue:(NSValue *)position {
    CGPoint p = [position CGPointValue];
    [self showForPosition:p];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    self.arrowImageView.hidden = NO;
    //*/
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint p = self.arrowImageView.layer.position;
    move.fromValue = [NSValue valueWithCGPoint:p];
    p.y -= self.arrowImageView.layer.bounds.size.height * 0.5;
    move.toValue = [NSValue valueWithCGPoint:p];
    move.duration = 0.4;
    move.removedOnCompletion = NO;
    move.fillMode = kCAFillModeForwards;
    //move.beginTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil] + _timeOffset;
    [self.arrowImageView.layer addAnimation:move forKey:@"arrow"];
    //*/
}

- (void)changeHSB {
    UIImage *image = self.contentImageView.image;
    NSData *data = [image rawImageData];
    
    UInt8 *pHead = (UInt8 *)[data bytes];
    
    float centerPoint = image.size.width*0.5 + image.size.height*0.5*image.size.width;
    UInt8 *pCenter = pHead + (int)centerPoint*4;
    UInt8 a = *(pCenter);
    UInt8 r = *(pCenter+1);
    UInt8 g = *(pCenter+2);
    UInt8 b = *(pCenter+3);
    float red = r/255.0f;
    float green = g/255.0f;
    float blue = b/255.0f;
    float hue, saturation, bright;
    [UIColor red:red green:green blue:blue toHue:&hue saturation:&saturation brightness:&bright];
    float centerBright = bright;
    
    float dRed = _selectedColorARGB._r/255.0f;
    float dGreen = _selectedColorARGB._g/255.0f;
    float dBlue = _selectedColorARGB._b/255.0f;
    [UIColor red:dRed green:dGreen blue:dBlue toHue:&hue saturation:&saturation brightness:&bright];
    float deltaBright = bright - centerBright;
    
    a = *(pCenter);
    r = *(pCenter+1);
    g = *(pCenter+2);
    b = *(pCenter+3);
    
    //    NSLog(@"%d", a);
    //    NSLog(@"%d, %d, %d", r, g, b);
    
    
    for (int row = 0; row < image.size.height; row++) {
        for (int col = 0; col < image.size.width; col++) {
            UInt8 *pPixelHead = pHead + (col + row*(int)image.size.width)*4;
            UInt8 a = *(pPixelHead);
            
            if (a < 60) {
                *(pPixelHead) = 0;
                continue;
            }
            //NSLog(@"%d", a);
            UInt8 r = *(pPixelHead+1);
            UInt8 g = *(pPixelHead+2);
            UInt8 b = *(pPixelHead+3);
            
            float red = r/255.0f;
            float green = g/255.0f;
            float blue = b/255.0f;
            float hue, saturation, bright;
            [UIColor red:red green:green blue:blue toHue:&hue saturation:&saturation brightness:&bright];
            
            float dRed = _selectedColorARGB._r/255.0f;
            float dGreen = _selectedColorARGB._g/255.0f;
            float dBlue = _selectedColorARGB._b/255.0f;
            [UIColor red:dRed green:dGreen blue:dBlue toHue:&hue saturation:&saturation brightness:NULL];
            bright = bright + deltaBright;
            bright = MIN(bright, 1);
            bright = MAX(bright, 0);
            
            [UIColor hue:hue saturation:saturation brightness:bright toRed:&red green:&green blue:&blue];
            
            *(pPixelHead +1) = (UInt8)(red*255);
            *(pPixelHead +2) = (UInt8)(green*255);
            *(pPixelHead +3) = (UInt8)(blue*255);
        }
    }
    
    pCenter = pHead + (int)centerPoint*4;
    
//    a = *(pCenter);
//    r = *(pCenter+1);
//    g = *(pCenter+2);
//    b = *(pCenter+3);
    
    //    NSLog(@"%d", a);
    //    NSLog(@"%d, %d, %d", r, g, b);
    //NSLog(@"%d, %d, %d", _selectedColorARGB.r, _selectedColorARGB.g, _selectedColorARGB.b);
    
    UIImage *image2 = [UIImage imageWithRawImageData:data width:image.size.width height:image.size.height];
    //self.myImage = image2;
    self.contentImageView.image = image2;
    //self.contentImageView.image = [UIImage imageNamed:@"pin_content"];
//    self.backgroundColor = [UIColor clearColor];
}

@end
