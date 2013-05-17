//
//  ProductRecommendViewController.h
//  testCG
//
//  Created by Niu Zhaowang on 5/7/13.
//  Copyright (c) 2013 Niu Zhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ProductRecommendViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UIColor *sampleColor;

- (id)initWithColor:(UIColor *)color moment:(NSString *)moment;
@end
