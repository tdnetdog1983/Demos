//
//  ProductRecommendViewController.m
//  testCG
//
//  Created by Niu Zhaowang on 5/7/13.
//  Copyright (c) 2013 Niu Zhaowang. All rights reserved.
//

#define PRODUCT_WIDTH   120
#define PRODUCT_HEIGHT  200

#import "ProductRecommendViewController.h"
#import "ImageHelper.h"
#import "ProInfo.h"
#import "CircleView.h"
#import "CL434Service.h"
#import "CLKaleidoscopeView.h"
#import "UIImage+Adjust.h"
#import "UIColor+CG.h"
#import "UIColor+CG.h"
//static const uint kAlphaThreshold = 60;

@interface ProductRecommendViewController ()
- (IBAction)back:(id)sender;
- (IBAction)backToHome:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *centerBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
- (IBAction)leftBtnPressed:(id)sender;
- (IBAction)centerBtnPressed:(id)sender;
- (IBAction)rightBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *styleView;

@property (strong, nonatomic) NSArray *productArray;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) ProInfo *proInfo;
@property (strong, nonatomic) UIView *coverView;
@property (assign, nonatomic) BOOL isProInfoShowing;
@property (strong, nonatomic) CircleView *circle;
@property (strong, nonatomic) UIColor *color;
@property (copy, nonatomic) NSString *moment;
@property (copy, nonatomic) NSString *mix;
@property (strong, nonatomic) CL434Service *service;

@end

@implementation ProductRecommendViewController {
    CLKaleidoscopeView *_kaleidoscopeBgView;
    NSArray *_threeColorsArray;
    uint _momentBase;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithColor:(UIColor *)color moment:(NSString *)moment
{
    if (self = [super init]) {
        self.color = color;
        self.moment = moment;
        self.mix = @"Matches";
        _service = [[CL434Service alloc] init];
        [self getProducts];
        
//        self.itemArray = [[NSMutableArray alloc]init];
//        [_itemArray addObject:[UIImage imageNamed:@"1.png"]];
//        [_itemArray addObject:[UIImage imageNamed:@"2.png"]];
//        [_itemArray addObject:[UIImage imageNamed:@"3.png"]];
//        [self.carousel reloadData];
    }
    return self;
}

- (void)getProducts
{
    CLAppDelegate *appDelegate = (CLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    service.colorB = [NSString stringWithFormat:@"%.0f",self.color.blue * 255];
//    service.colorG = [NSString stringWithFormat:@"%.0f",self.color.green * 255];
//    service.colorR = [NSString stringWithFormat:@"%.0f",self.color.red * 255];
    _service.moment = self.moment;
    _service.mix = self.mix;
    _service.serviceURLString =appDelegate.naviServiceItem.upload;
    [_service startWithBlock:^(NSArray *resultArr, NSError *error) {
        if (!error) {
            self.productArray = resultArr;
            [self.carousel reloadData];
        }
    }];
}

- (void)reloadCarouselView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _threeColorsArray = [self.sampleColor fetchThreeColors];
    if ([self.moment isEqualToString:@"Day"]) {
        _momentBase = 0;
    } else {
        _momentBase = 3;
    }
    
    UIImage *srcImage = [UIImage imageNamed:@"kal_reco_manicure"];
    
    UIImage *desImage = [UIImage adjustImage:srcImage
                               withColorARGB:CColorARGB(0xff, self.color.red*255, self.color.green*255, self.color.blue*255)
                          withAlphaThreshold:kAlphaThreshold
                                    forPoint:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    _kaleidoscopeBgView = [[CLKaleidoscopeView alloc] initWithFrame:self.backgroundView.bounds andImage:desImage];
    [self.backgroundView insertSubview:_kaleidoscopeBgView atIndex:0];
    
    // setup carousel
    _carousel.type = iCarouselTypeRotary;
    
    //setup proInfo view
    self.proInfo = [[[NSBundle mainBundle]loadNibNamed:@"ProInfo" owner:self options:nil]lastObject];
    [self.proInfo.backBtn addTarget:self action:@selector(backToRecommendPage) forControlEvents:UIControlEventTouchUpInside];
    
    //setup coverView
    self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height, 320, 800)];
    self.coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    
    //setup colorView
    self.colorView.backgroundColor = self.color;
    self.colorView.backgroundColor = [_threeColorsArray objectAtIndex:0+_momentBase];
    self.circle = [CircleView circleViewWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.colorView addSubview:_circle];
    
    //setup top buttons
    self.leftBtn.selected = YES;
    self.leftBtn.backgroundColor = self.color;
    UIImage *bgImage = [[_threeColorsArray objectAtIndex:0+_momentBase] buttonBGImageForRect:self.leftBtn.bounds];
    self.leftBtn.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setColorView:nil];
    [self setTopView:nil];
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setStyleView:nil];
    [super viewDidUnload];
}
-(void)backToRecommendPage
{
    if (_isProInfoShowing) {
        [self hideProductInfo];
    }
}
- (IBAction)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)leftBtnPressed:(id)sender {
    if (!self.leftBtn.selected) {
        self.leftBtn.selected = YES;
        self.centerBtn.selected = NO;
        self.rightBtn.selected = NO;
        self.leftBtn.backgroundColor = self.color;
        UIImage *bgImage = [[_threeColorsArray objectAtIndex:0+_momentBase] buttonBGImageForRect:self.leftBtn.bounds];
        self.leftBtn.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.centerBtn.backgroundColor = [UIColor whiteColor];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        self.colorView.backgroundColor = [_threeColorsArray objectAtIndex:0+_momentBase];
        self.mix = @"Matches";
        [self getProducts];
    }
}

- (IBAction)centerBtnPressed:(id)sender {
    if (!self.centerBtn.selected) {
        self.centerBtn.selected = YES;
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
        self.centerBtn.backgroundColor = self.color;
        UIImage *bgImage = [[_threeColorsArray objectAtIndex:1+_momentBase] buttonBGImageForRect:self.centerBtn.bounds];
        self.centerBtn.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.leftBtn.backgroundColor = [UIColor whiteColor];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        self.colorView.backgroundColor = [_threeColorsArray objectAtIndex:1+_momentBase];
        self.mix = @"Blends";
        [self getProducts];
    }
}

- (IBAction)rightBtnPressed:(id)sender {
    if (!self.rightBtn.selected) {
        self.rightBtn.selected = YES;
        self.centerBtn.selected = NO;
        self.leftBtn.selected = NO;
        self.rightBtn.backgroundColor = self.color;
        UIImage *bgImage = [[_threeColorsArray objectAtIndex:2+_momentBase] buttonBGImageForRect:self.rightBtn.bounds];
        self.rightBtn.backgroundColor = [UIColor colorWithPatternImage:bgImage];
        self.centerBtn.backgroundColor = [UIColor whiteColor];
        self.leftBtn.backgroundColor = [UIColor whiteColor];
        self.colorView.backgroundColor = [_threeColorsArray objectAtIndex:2+_momentBase];
        self.mix = @"Clashes";
        [self getProducts];
    }
}
-(void)setupProductInfoWithIndex:(NSInteger)index
{
    for (UIView *view in _proInfo.infoView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
    CLProductInfo *info = [self.productArray objectAtIndex:index];
     UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, height, _proInfo.infoView.bounds.size.width/2, 30)];
    name.text = info.resname;
    name.textColor = [UIColor whiteColor];
    name.font = font;
    name.backgroundColor = [UIColor clearColor];
    name.adjustsFontSizeToFitWidth = YES;
    [_proInfo.infoView addSubview:name];
    
    UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.size.width, height, _proInfo.infoView.bounds.size.width/4, 30)];
    code.text = info.memo4;
    code.textColor = [UIColor whiteColor];
    code.font = font;
    code.backgroundColor = [UIColor clearColor];
    code.textAlignment = NSTextAlignmentCenter;
    code.adjustsFontSizeToFitWidth = YES;
    [_proInfo.infoView addSubview:code];
    
    UILabel *standard = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.size.width+code.frame.size.width, height, _proInfo.infoView.bounds.size.width/4, 30)];
    standard.text = info.memo7;
    standard.textColor = [UIColor whiteColor];
    standard.font = font;
    standard.backgroundColor = [UIColor clearColor];
    standard.textAlignment = NSTextAlignmentCenter;
    standard.adjustsFontSizeToFitWidth = YES;
    [_proInfo.infoView addSubview:standard];
    
    height += name.frame.size.height+10;
    
    UILabel *shortDes = [[UILabel alloc]init];
    shortDes.text = info.resdesc;
    shortDes.textColor = [UIColor whiteColor];
    shortDes.font = font;
    shortDes.backgroundColor = [UIColor clearColor];
    shortDes.numberOfLines = 0;
    CGSize shortDesSize = [info.resdesc sizeWithFont:font constrainedToSize:CGSizeMake(_proInfo.infoView.frame.size.width, 1000)];
    shortDes.frame = CGRectMake(0, height, shortDesSize.width, shortDesSize.height);
    [_proInfo.infoView addSubview:shortDes];
    
    height += shortDes.frame.size.height+20;
    
    UILabel *detailDes = [[UILabel alloc]init];
    detailDes.text = info.memo11;
    detailDes.textColor = [UIColor whiteColor];
    detailDes.font = font;
    detailDes.backgroundColor = [UIColor clearColor];
    detailDes.numberOfLines = 0;
    CGSize detailDesSize = [info.memo11 sizeWithFont:font constrainedToSize:CGSizeMake(_proInfo.infoView.frame.size.width, 1000)];
    detailDes.frame = CGRectMake(0, height, detailDesSize.width, detailDesSize.height);
    [_proInfo.infoView addSubview:detailDes];
    
    height += detailDes.frame.size.height+20;
    
    UILabel *method = [[UILabel alloc]init];
    method.text = info.memo9;
    method.textColor = [UIColor whiteColor];
    method.font = font;
    method.backgroundColor = [UIColor clearColor];
    method.numberOfLines = 0;
    CGSize methodSize = [info.memo9 sizeWithFont:font constrainedToSize:CGSizeMake(_proInfo.infoView.frame.size.width, 1000)];
    method.frame = CGRectMake(0, height, methodSize.width, methodSize.height);
    [_proInfo.infoView addSubview:method];
    
    height += method.frame.size.height+20;
    
    _proInfo.infoView.contentSize = CGSizeMake(_proInfo.infoView.frame.size.width, height);
    
}
-(void)showProductInfoWithIndex:(NSInteger)index
{
    self.isProInfoShowing = TRUE;
    UIImageView *view = (UIImageView *)[self.carousel itemViewAtIndex:index];
    CGPoint p = [view convertPoint:CGPointZero toView:self.view.window];
    for (UIView *view in _proInfo.productView.subviews) {
        [view removeFromSuperview];
    }
    _proInfo.productView.image = view.image;
    _proInfo.productView.frame = CGRectMake(0, p.y-_topView.bounds.size.height, view.frame.size.width, view.frame.size.height);
    [ImageHelper addReflectionToView:_proInfo.productView];
    _proInfo.infoView.frame = CGRectMake(PRODUCT_WIDTH, _proInfo.infoView.frame.origin.y, _proInfo.infoView.frame.size.width+_proInfo.infoView.frame.origin.x-PRODUCT_WIDTH, _proInfo.infoView.frame.size.height);
    [self setupProductInfoWithIndex:index];
    _proInfo.frame = CGRectMake(p.x, _topView.frame.size.height, _proInfo.frame.size.width, _proInfo.frame.size.height);
    _proInfo.backBtn.alpha = 0;
    _proInfo.infoView.alpha = 0;
    _proInfo.purchaseBtn.alpha = 0;
    [_proInfo.purchaseBtn addTarget:self action:@selector(goToTMall) forControlEvents:UIControlEventTouchUpInside];
    _proInfo.purchaseBtn.hidden = NO;
    if (![self canGoToMall]) {
        _proInfo.purchaseBtn.hidden = YES;
    }
    self.carousel.alpha = 0;
    _carousel.center = CGPointMake(_carousel.center.x-(320-PRODUCT_WIDTH)/2, _carousel.center.y);
    [self.view addSubview:_coverView];
    [self.view addSubview:_proInfo];
    [UIView animateWithDuration:0.5 animations:^{

        self.styleView.alpha = 0;
        self.label1.alpha = 0;
        self.label2.alpha= 0;
        self.circle.alpha = 0;
        _coverView.alpha = 0.6;
        _proInfo.backBtn.alpha = 1;
        _proInfo.infoView.alpha = 1;
        _proInfo.purchaseBtn.alpha = 1;
        _proInfo.frame = CGRectMake(0, _topView.frame.size.height, _proInfo.frame.size.width, _proInfo.frame.size.height);
        
    }];
}
-(void)hideProductInfo
{
    self.isProInfoShowing = FALSE;
    [_proInfo removeFromSuperview];
    self.carousel.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.styleView.alpha = 1;
        self.label1.alpha = 1;
        self.label2.alpha= 1;
        self.circle.alpha = 1;
        _coverView.alpha = 0;
        _carousel.center = CGPointMake(_carousel.center.x+(320-PRODUCT_WIDTH)/2, _carousel.center.y);
    }];
}
-(void)goToTMall
{
    NSInteger index = _carousel.currentItemIndex;
    CLProductInfo *info = [self.productArray objectAtIndex:index];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:info.tmallurl]];
}
-(BOOL)canGoToMall
{
    NSInteger index = _carousel.currentItemIndex;
    CLProductInfo *info = [self.productArray objectAtIndex:index];
    if (!info.tmallurl || [info.tmallurl isEqualToString:@""]) {
        return NO;
    }
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:info.tmallurl]]) {
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_productArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    CLProductInfo *info = [_productArray objectAtIndex:index];
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PRODUCT_WIDTH, PRODUCT_HEIGHT)];
        __weak UIView *wView = view;
        
        UIImage *localImage = [UIImage imageNamed:[info.resurl lastPathComponent]];
        if (localImage) {
            ((UIImageView*)view).image = localImage;
            view.contentMode = UIViewContentModeScaleAspectFit;
            [ImageHelper addReflectionToView:view];
        }else{
            [(UIImageView *)view setImageWithURL:[NSURL URLWithString:info.resurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                UIView *sView = wView;
                if (sView) {
                    ((UIImageView *)sView).image = image;
                    sView.contentMode = UIViewContentModeScaleAspectFit;
                    [ImageHelper addReflectionToView:sView];
                }

            }];
        }
//        NSLog(@"resulr:%@",info.resurl);

    }
    else
    {
        __weak UIView *wView = view;
        
        UIImage *localImage = [UIImage imageNamed:[info.resurl lastPathComponent]];
        if (localImage) {
            ((UIImageView*)view).image = localImage;
            view.contentMode = UIViewContentModeScaleAspectFit;
            [ImageHelper addReflectionToView:view];
        }else{
            [(UIImageView *)view setImageWithURL:[NSURL URLWithString:info.resurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                UIView *sView = wView;
                if (sView) {
                    ((UIImageView *)sView).image = image;
                    NSInteger count = [sView.subviews count];
                    if (count>0) {
                        UIView *reflect = [sView.subviews objectAtIndex:count-1];
                        [reflect removeFromSuperview];
                    }
                    [ImageHelper addReflectionToView:sView];
                }
            }];
        }
    }
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}
- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.2f;
        }
        case iCarouselOptionFadeMax:
        {
            return value;
        }
        default:
        {
            return value;
        }
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [self showProductInfoWithIndex:index];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSLog(@"%d", carousel.currentItemIndex);
    if ([self.productArray count] > carousel.currentItemIndex) {
        CLProductInfo *info = [self.productArray objectAtIndex:carousel.currentItemIndex];
        self.label1.text = info.memo2;
        self.label2.text = info.resname;
        
        self.label1.textColor = [_sampleColor textColorSuitable];
        self.label2.textColor = [_sampleColor textColorSuitable];
    }
}
#pragma mark -

@end
