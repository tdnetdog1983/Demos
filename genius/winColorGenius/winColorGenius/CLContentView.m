//
//  CLContentView.m
//  CLDemos
//
//  Created by Cai Lei on 5/2/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLContentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLContentView {
    UIView *_containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _countOfImagePerLine = 3;
    _maskRadius = M_PI_2;
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_containerView];
}

- (void)updateView {
    if (0 == self.countOfImagePerLine) {
        self.countOfImagePerLine = 1;
    }
    
    for (UIView *v in [_containerView subviews]) {
        [v removeFromSuperview];
    }
    
    CGFloat width = self.bounds.size.width / self.countOfImagePerLine;
    CGFloat height = self.bounds.size.height / self.countOfImagePerLine;
    
    for (int row = 0; row < self.countOfImagePerLine; row++) {
        for (int col = 0; col < self.countOfImagePerLine; col++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.contentImage];
            imageView.frame = CGRectMake(row * width, col * height, width, height);
            
            [_containerView addSubview:imageView];
        }
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:self.bounds.size.width startAngle:0 endAngle:self.maskRadius + kAdjustMaskRadius clockwise:YES];
    [path addLineToPoint:center];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)startRotate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    animation.fromValue = @(M_PI*2);
    animation.toValue = @0;
    animation.duration = 120;
    animation.cumulative = NO;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_containerView.layer addAnimation:animation forKey:@"CLRotation"];
}

- (void)stopRotate {
    [_containerView.layer removeAllAnimations];
}

@end
