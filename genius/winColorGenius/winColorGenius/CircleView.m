//
//  CircleView.m
//  testCG
//
//  Created by Niu Zhaowang on 5/8/13.
//  Copyright (c) 2013 Niu Zhaowang. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageHelper.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIEdgeInsets inset = UIEdgeInsetsMake(30, 30, 30, 30);
    CGRect centerRect = UIEdgeInsetsInsetRect(rect, inset);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rect.size.width/2, rect.size.height/2);
    CGContextRotateCTM(context, M_PI_4);
    CGContextTranslateCTM(context, -rect.size.width/2, -rect.size.height/2);
    CGContextSetAlpha(context, 0.3);
    [[UIColor whiteColor]setStroke];
    CGContextAddEllipseInRect(context, centerRect);
    CGContextStrokePath(context);
    UIImage *lImg = [UIImage imageNamed:@"arrow_left.png"];
    [lImg drawAtPoint:CGPointMake(rect.size.width/2, rect.size.height-40)];
    UIImage *rImg = [UIImage imageNamed:@"arrow_right.png"];
    [rImg drawAtPoint:CGPointMake(rect.size.width/2, 20)];
}
+(CircleView *)circleViewWithFrame:(CGRect)frame
{
    CGFloat len = frame.size.width>frame.size.height? frame.size.width:frame.size.height;
    CircleView *circle = [[CircleView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, len, len)];

    CGFloat scaleY = frame.size.width>frame.size.height? frame.size.height/frame.size.width:frame.size.width/frame.size.height;
    CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -len*(1-scaleY)/2);
    CGAffineTransform scale = CGAffineTransformScale(trans, 1, scaleY);
    circle.transform = scale;
    return circle;
}

@end
