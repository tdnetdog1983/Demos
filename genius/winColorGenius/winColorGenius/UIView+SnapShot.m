//
//  UIView+SnapShot.m
//  winCRM
//
//  Created by Cai Lei on 12/29/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import "UIView+SnapShot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (SnapShot)

- (UIImage *)snapShot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
