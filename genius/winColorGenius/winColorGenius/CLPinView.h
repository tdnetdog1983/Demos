//
//  CLPinView.h
//  MyDemos
//
//  Created by Cai Lei on 4/25/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CColorARGB.h"
@class CLPinView;

@protocol CLPinViewDelegate <NSObject>
- (void)clicked:(CLPinView *)aCLPinView withColor:(const CColorARGB&)aColorARGB;
@end


@interface CLPinView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (assign, nonatomic) CColorARGB selectedColorARGB;
@property (assign, nonatomic) CColorARGB sampleColorARGB;
@property (strong , nonatomic) UIImage *myImage;

@property (weak, nonatomic) id<CLPinViewDelegate> delegate;

- (void)showForPosition:(CGPoint)position;
- (void)showForPositionWithNSValue:(NSValue *)position;
- (void)adjustContentImage;

@end
