//
//  CLContentView.h
//  CLDemos
//
//  Created by Cai Lei on 5/2/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLKaleidoscopeGlobal.h"

@interface CLContentView : UIView

@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, assign) NSUInteger countOfImagePerLine;
@property (nonatomic, assign) CGFloat maskRadius;
- (void)updateView;

- (void)startRotate;
- (void)stopRotate;

@end
