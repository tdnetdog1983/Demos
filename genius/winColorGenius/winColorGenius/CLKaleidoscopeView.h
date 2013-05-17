//
//  CLKaleidoscopeView.h
//  CLDemos
//
//  Created by Cai Lei on 5/2/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLKaleidoscopeGlobal.h"

@interface CLKaleidoscopeView : UIView

- (id)initWithFrame:(CGRect)aFrame andImage:(UIImage *)aImage;

@property (nonatomic, strong) UIImage *contentImage;

@end
