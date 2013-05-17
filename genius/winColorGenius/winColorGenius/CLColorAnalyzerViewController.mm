//
//  CLColorAnalyzerViewController.m
//  winColorGenius
//
//  Created by Cai Lei on 5/8/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#define MOMENT_BUTTON_WIDTH   100

#import "CLColorAnalyzerViewController.h"
#import "CLPinView.h"
#import "UIImage+Adjust.h"
#import "ProductRecommendViewController.h"
static const uint kMaxRegionNumber = 8;
static const uint kMinPixelInRegion = 100;
static const uint kStep = 10;
static const uint kThreshold = 30000;
//static const uint kAlphaThreshold = 60;
static const uint kGap = 63; // we only deal with the center part of the image

@interface CLColorAnalyzerViewController () <CLPinViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) UIImageView *selectedColorView;
@property (strong, nonatomic) UIButton *dayBtn;
@property (strong, nonatomic) UIButton *nightBtn;
@property (nonatomic,strong)MBProgressHUD *progressView;
@property (assign, nonatomic) CColorARGB selectedColorARGB;

@end

@implementation CLColorAnalyzerViewController {
    CGSize _size;
    CColorARGB _sampleColorARGB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentImageView.image = self.image;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentImageView.userInteractionEnabled = YES;
    _size = [self imageSizeAfterAspectFit:self.contentImageView];

    self.progressView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressView];
    [self.progressView show:YES];
    
    self.dayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MOMENT_BUTTON_WIDTH, MOMENT_BUTTON_WIDTH)];
    [self.dayBtn setBackgroundImage:[UIImage imageNamed:@"button_day.png"] forState:UIControlStateNormal];
    self.dayBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self.dayBtn addTarget:self action:@selector(dayAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.nightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MOMENT_BUTTON_WIDTH, MOMENT_BUTTON_WIDTH)];
    [self.nightBtn setBackgroundImage:[UIImage imageNamed:@"button_night.png"] forState:UIControlStateNormal];
    self.nightBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self.nightBtn addTarget:self action:@selector(nightAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self performSelector:@selector(analyzeImage) withObject:nil afterDelay:0.1];
}

- (void)viewDidUnload {
    [self setContentImageView:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    self.image = nil;
}

-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    float newwidth;
    float newheight;
    
    UIImage *image=imgview.image;
    
    if (image.size.height>=image.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(image.size.width/image.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
        
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(image.size.height/image.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    
    return CGSizeMake(newwidth, newheight);
}

- (void)analyzeImage {
//    CColorARGB pSample[] = {
//        CColorARGB(0xff, 184, 204, 228),
//        CColorARGB(0xff, 230, 184, 183),
//        CColorARGB(0xff, 255, 255, 153),
//        CColorARGB(0xff, 204, 255, 153),
//        CColorARGB(0xff, 51, 51, 204),
//        
//        CColorARGB(0xff, 102, 153, 0),
//        CColorARGB(0xff, 204, 0, 0),
//        CColorARGB(0xff, 255, 255, 0),
//        CColorARGB(0xff, 204, 0, 102),
//        CColorARGB(0xff, 226, 107, 10),
//        
//        CColorARGB(0xff, 153, 51, 255),
//        CColorARGB(0xff, 102, 153, 255),
//        CColorARGB(0xff, 238, 236, 225),
//        CColorARGB(0xff, 255, 255, 255),
//        CColorARGB(0xff, 207, 207, 207),
//        
//        CColorARGB(0xff, 89, 89, 89),
//        CColorARGB(0xff, 0, 0, 0),
//        CColorARGB(0xff, 122, 122, 122),
//        CColorARGB(0xff, 0, 32, 96),
//        CColorARGB(0xff, 0, 102, 0),
//        
//        CColorARGB(0xff, 204, 102, 0),
//        CColorARGB(0xff, 204, 0, 255),
//        CColorARGB(0xff, 153, 0, 0),
//    };
    uint sampleSize = sizeof(pSample)/sizeof(CColorARGB);
    
    uint gap = kGap * 0.5 / self.contentImageView.bounds.size.width * self.image.size.width;
    
    NSMutableArray *sampleArray = [UIImage genRegionArrayForImage:self.image
                                                       withSample:pSample
                                                   andSampleCount:sampleSize
                                                 similarThreshold:kThreshold
                                                          stepLen:kStep
                                                        borderGap:gap
                                   ];
    for (int i = 0; i < kMaxRegionNumber; i++) {
        NSArray *singleArray = [sampleArray lastObject];
        [sampleArray removeLastObject];
        if ([singleArray count] > kMinPixelInRegion) {
            DDLogInfo(@"sample %d count: %d", i, [singleArray count]);
            CColorPoint *p = [singleArray objectAtIndex:[singleArray count]/2];
            CGPoint point = [self changeToScreenPointFromX:p.x andY:p.y];
            
            CColorPoint *sampleP = [singleArray objectAtIndex:0];
            CLPinView *pinview = [[[NSBundle mainBundle] loadNibNamed:@"CLPinView" owner:self options:nil] lastObject];
            [self.contentImageView addSubview:pinview];
            pinview.selectedColorARGB = p.colorARGB;
            pinview.sampleColorARGB = sampleP.colorARGB;
            [pinview adjustContentImage];
            [pinview performSelector:@selector(showForPositionWithNSValue:) withObject:[NSValue valueWithCGPoint:point] afterDelay:[self randomDoubleFrom:0 To:1]];
            pinview.delegate = self;
            [self.progressView hide:YES];
        }
    }
}

- (CGPoint)changeToScreenPointFromX:(int)x andY:(int)y {
    CGFloat nx = _size.width * x / self.image.size.width + (self.contentImageView.bounds.size.width - _size.width) * 0.5;
    CGFloat ny = _size.height * y / self.image.size.height + (self.contentImageView.bounds.size.height - _size.height) * 0.5;
    return CGPointMake(nx, ny);
}

- (CGPoint)changeFromScreenPointFromX:(int)x andY:(int)y {
    CGFloat nx = (x - (self.contentImageView.bounds.size.width - _size.width) * 0.5) * self.image.size.width / _size.width;
    CGFloat ny = (y - (self.contentImageView.bounds.size.height - _size.height) * 0.5) * self.image.size.height / _size.height;
    return CGPointMake(nx, ny);
}


- (double)randomDoubleFrom:(double)aStart To:(double)aEnd {
    double random = (double)rand() / (double)RAND_MAX;
    double diff = aEnd - aStart;
    return aStart + random*diff;
}

- (void)clicked:(CLPinView *)aCLPinView withColor:(const CColorARGB&)aColorARGB {
    _sampleColorARGB = aCLPinView.sampleColorARGB;
    self.selectedColorARGB = aColorARGB;
    // add selected color view
    self.selectedColorView = [[UIImageView alloc]initWithImage:aCLPinView.contentImageView.image];
    CGRect rect = [aCLPinView.contentImageView convertRect:aCLPinView.contentImageView.bounds toView:self.view];
    self.selectedColorView.frame = rect;
    UILabel *label = [[UILabel alloc]initWithFrame:self.selectedColorView.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"或";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.selectedColorView addSubview:label];
    [self.view addSubview:self.selectedColorView];
    
    // set button position
    self.dayBtn.center = CGPointMake((320-MOMENT_BUTTON_WIDTH-self.selectedColorView.frame.size.width)/2+5, _selectedColorView.center.y);
    self.nightBtn.center = CGPointMake(160+(MOMENT_BUTTON_WIDTH+self.selectedColorView.frame.size.width)/2-6, _selectedColorView.center.y);
    
    //set initial button status
    self.dayBtn.alpha = 0;
    self.dayBtn.transform = CGAffineTransformMakeScale(2, 2);
    self.nightBtn.alpha = 0;
    self.nightBtn.transform = CGAffineTransformMakeScale(2, 2);
    
    [self.view addSubview:self.dayBtn];
    [self.view addSubview:self.nightBtn];

    [UIView animateWithDuration:0.5 animations:^{
        self.selectedColorView.center = CGPointMake(160, self.selectedColorView.center.y);
        self.dayBtn.transform = CGAffineTransformIdentity;
        self.nightBtn.transform = CGAffineTransformIdentity;
        self.dayBtn.alpha = 1;
        self.nightBtn.alpha = 1;
        NSArray *array = self.contentImageView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[CLPinView class]]) {
                view.alpha = 0;
            }
        }
    }];
    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dayAction
{
    [self.selectedColorView removeFromSuperview];
    [self.dayBtn removeFromSuperview];
    [self.nightBtn removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        NSArray *array = self.contentImageView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[CLPinView class]]) {
                view.alpha = 1;
            }
        }
    }];
    UIColor *color = [UIColor colorWithRed:self.selectedColorARGB._r/255.0f green:self.selectedColorARGB._g/255.0f blue:self.selectedColorARGB._b/255.0f alpha:self.selectedColorARGB._a/255.0f];
    ProductRecommendViewController *vc = [[ProductRecommendViewController alloc]initWithColor:color moment:@"Day"];
    vc.sampleColor = [UIColor colorWithRed:_sampleColorARGB._r/255.0f green:_sampleColorARGB._g/255.0f blue:_sampleColorARGB._b/255.0f alpha:1];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)nightAction
{
    [self.selectedColorView removeFromSuperview];
    [self.dayBtn removeFromSuperview];
    [self.nightBtn removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        NSArray *array = self.contentImageView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[CLPinView class]]) {
                view.alpha = 1;
            }
        }
    }];
    UIColor *color = [UIColor colorWithRed:self.selectedColorARGB._r/255.0f green:self.selectedColorARGB._g/255.0f blue:self.selectedColorARGB._b/255.0f alpha:self.selectedColorARGB._a/255.0f];
    ProductRecommendViewController *vc = [[ProductRecommendViewController alloc]initWithColor:color moment:@"Night"];
    vc.sampleColor = [UIColor colorWithRed:_sampleColorARGB._r/255.0f green:_sampleColorARGB._g/255.0f blue:_sampleColorARGB._b/255.0f alpha:1];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
