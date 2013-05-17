//
//  CLKaleidoscopeView.m
//  CLDemos
//
//  Created by Cai Lei on 5/2/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLKaleidoscopeView.h"
#import "CLContentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLKaleidoscopeView {
    NSMutableArray *_contentViewArray;
}

- (id)initWithFrame:(CGRect)aFrame andImage:(UIImage *)aImage {
    self = [super initWithFrame:aFrame];
    if (self) {
        _contentImage = aImage;
        [self setup];
    }
    return self;
}

- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    for (UIView *v in _contentViewArray) {
        [v removeFromSuperview];
    }
    
    [self setup];
    [self setNeedsDisplay];
}

- (void)setup {
    CGFloat delta = 2*M_PI/kCountOfContentView;
    _contentViewArray = [NSMutableArray arrayWithCapacity:kCountOfContentView];
    
    for (int i=0; i<kCountOfContentView; i++) {
        CLContentView *contentView = [[CLContentView alloc] initWithFrame:CGRectMake(0, 0, kContentViewLength, kContentViewLength)];
        contentView.contentImage = self.contentImage;
        contentView.countOfImagePerLine = kCountOfImagePerLine;
        contentView.maskRadius = delta;
        [contentView updateView];
        contentView.layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        CATransform3D transform = CATransform3DIdentity;
        if (i%2) {
            transform = CATransform3DScale(transform, 1, -1, 1);
            transform = CATransform3DRotate(transform, -delta - kAdjustMaskRadius, 0, 0, 1);
            transform = CATransform3DRotate(transform, -delta*i, 0, 0, 1);
        } else {
            transform = CATransform3DRotate(transform, delta*i, 0, 0, 1);
        }
        contentView.layer.transform = transform;
        
        [_contentViewArray addObject:contentView];
        [self addSubview: contentView];
    }
    
    for (int i = 0; i < [_contentViewArray count]; i++) {
        [_contentViewArray[i] startRotate];
    }
}

@end
