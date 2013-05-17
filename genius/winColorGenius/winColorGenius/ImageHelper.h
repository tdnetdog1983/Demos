//
//  ImageHelper.h
//  testCG
//
//  Created by Niu Zhaowang on 5/7/13.
//  Copyright (c) 2013 Niu Zhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ImageHelper : NSObject
+ (UIImage *) imageFromView: (UIView *)theView;
+ (CGImageRef) createGradientImage:(CGSize)size;
+ (UIImage *) reflectionOfView:(UIView *)theView withPercent:(CGFloat) percent;
+ (void) addReflectionToView: (UIView *)theView;
@end
