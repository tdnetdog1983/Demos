//
//  ImageHelper.m
//  testCG
//
//  Created by Niu Zhaowang on 5/7/13.
//  Copyright (c) 2013 Niu Zhaowang. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *) imageFromView: (UIView *)theView {
    // draw a view's contents into an image context
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    [theView.layer  renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (CGImageRef) createGradientImage:(CGSize)size
{
    CGFloat colors[] = {0.0,1.0,1.0,1.0};
    //在灰色设备色彩上建立一渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,size.width,size.height,8,0,colorSpace,kCGImageAlphaNone);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,colors,NULL,2);
    CGColorSpaceRelease(colorSpace);
    
    //绘制线性渐变
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(0,size.height);
    CGContextDrawLinearGradient(context,gradient,p1,p2,kCGGradientDrawsAfterEndLocation);
    
    //Return the CGImage
    CGImageRef theCGImage = CGBitmapContextCreateImage(context);
    CFRelease(gradient);
    CGContextRelease(context);
    return theCGImage;
}

+ (UIImage *) reflectionOfView:(UIView *)theView withPercent:(CGFloat) percent
{
    //Retain the width but shrink the height
    CGSize size = CGSizeMake(theView.frame.size.width, theView.frame.size.height * percent);
    
    UIImage *image = [ImageHelper imageFromView:theView];
    //Shrink the View
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -size.height);
    [image drawInRect:CGRectMake(0, -theView.frame.size.height * (1-percent), size.width, theView.frame.size.height)];
//    [theView.layer renderInContext:context];
    UIImage *partialimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //build the mask
    CGImageRef mask = [ImageHelper createGradientImage:size];
    CGImageRef ref = CGImageCreateWithMask(partialimg.CGImage,mask);
    UIImage *theImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGImageRelease(mask);
    return theImage;
}

const CGFloat kReflectDistance = 0.0f;
+ (void) addReflectionToView: (UIView *)theView
{
    theView.clipsToBounds = NO;
    UIImageView *reflection = [[UIImageView alloc] initWithImage:[ImageHelper reflectionOfView:theView withPercent:0.45f]];
    CGRect frame = reflection.frame;
    frame.origin = CGPointMake(0.0f, theView.frame.size.height + kReflectDistance);
    reflection.frame = frame;
    
    // add the reflection as a simple subview
    [theView addSubview:reflection];
}

@end
