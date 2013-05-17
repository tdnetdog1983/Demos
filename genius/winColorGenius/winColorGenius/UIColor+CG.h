//
//  UIColor+CG.h
//  winColorGenius
//
//  Created by Cai Lei on 5/13/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>
class CColorARGB;

@interface UIColor (CG)
- (UIColor *)textColorSuitable;
- (NSArray *)fetchThreeColors;

- (UIImage *)buttonBGImageForRect:(CGRect)aRect;
@end
