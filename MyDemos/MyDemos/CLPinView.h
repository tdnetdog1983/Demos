//
//  CLPinView.h
//  MyDemos
//
//  Created by Cai Lei on 4/25/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CColorARGB.h"

@interface CLPinView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (assign, nonatomic) CColorARGB selectedColorARGB;

@property (strong , nonatomic) UIImage *myImage;

- (void)showForPosition:(CGPoint)position;
- (void)showForPositionWithNSValue:(NSValue *)position;
- (void)changeHSB;

@end
