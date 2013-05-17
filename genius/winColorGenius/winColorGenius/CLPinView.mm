//
//  CLPinView.m
//  MyDemos
//
//  Created by Cai Lei on 4/25/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLPinView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Adjust.h"

//static const uint kAlphaThreshold = 60;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(id)sender {
    [self.delegate clicked:self withColor:self.selectedColorARGB];
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

- (void)adjustContentImage {
    UIImage *orgImage = self.contentImageView.image;
    UIImage *desImage = [UIImage adjustImage:orgImage
                               withColorARGB:self.selectedColorARGB
                          withAlphaThreshold:kAlphaThreshold
                                    forPoint:CGPointMake(orgImage.size.width*0.5, orgImage.size.height*0.5)];
    self.contentImageView.image = desImage;
}

@end
