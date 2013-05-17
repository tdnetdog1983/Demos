//
//  CLMainLandingViewController.m
//  winColorGenius
//
//  Created by Cai Lei on 5/6/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLMainLandingViewController.h"
#import "CLKaleidoscopeView.h"
#import "CLColorAnalyzerViewController.h"
#import <UIImage+FixRotation.h>
#import <QuartzCore/QuartzCore.h>

static const NSTimeInterval kAnimationDuration = 0.6;
static const NSUInteger kContent1Count = 3;

@interface CLMainLandingViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerBorderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerContent0ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerContent1_1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerContent1_2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerContent1_3ImageView;
@property (strong, nonatomic) IBOutlet UIView *centerContent1View;

@property (strong, nonatomic) IBOutlet UIButton *landingLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *landingRightButton;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIImageView *bottomLogoImageView;
@property (strong, nonatomic) IBOutlet UIButton *v2LeftButton;
@property (strong, nonatomic) IBOutlet UIButton *v2RightButton;
@end

@implementation CLMainLandingViewController {
    CLKaleidoscopeView *_kaleidoscopeBgView;
    UIImageView *_imageBgView;
    BOOL _bOnAnimation;
    
    UIImage *_image;
}

- (void)setKaleidoscopeContentImage:(UIImage *)kaleidoscopeContentImage {
    _kaleidoscopeContentImage = kaleidoscopeContentImage;
    [_kaleidoscopeBgView setContentImage:kaleidoscopeContentImage];
    [self.view setNeedsDisplay];
}

- (void)adjustOneMainButton {
    self.landingLeftButton.center = self.centerBorderImageView.center;
    [self.landingLeftButton setImage:[UIImage imageNamed:@"landingMainBtn"] forState:UIControlStateNormal];
    [self.landingLeftButton setImage:[UIImage imageNamed:@"landingMainBtn"] forState:UIControlStateHighlighted];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustOneMainButton];
    
	_kaleidoscopeBgView = [[CLKaleidoscopeView alloc] initWithFrame:self.view.bounds andImage:[UIImage imageNamed:@"kal_menu1.jpg"]];
    [self.view insertSubview:_kaleidoscopeBgView atIndex:0];
    
    _imageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask"]];
    _imageBgView.frame = self.view.bounds;
    [self.view insertSubview:_imageBgView atIndex:1];
    
    [[NSBundle mainBundle] loadNibNamed:@"CLMainLandingViews" owner:self options:nil];
    self.centerContent0ImageView.center = CGPointMake(self.centerBorderImageView.bounds.size.width*0.5, self.centerBorderImageView.bounds.size.height*0.5);
    [self.centerBorderImageView addSubview:self.centerContent0ImageView];

    self.titleImageView.hidden = YES;
    self.landingLeftButton.hidden = YES;
    self.landingRightButton.hidden = YES;
    self.infoButton.hidden = YES;
    self.bottomLogoImageView.hidden = YES;
    [self doTitleAnimation];
    [self doBottomAnimation];
    
    _bOnAnimation = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.landingLeftButton.transform = CGAffineTransformIdentity;
    self.landingRightButton.transform = CGAffineTransformIdentity;
    
    self.v2LeftButton.hidden = YES;
    self.v2RightButton.hidden = YES;
    
    if (!_bOnAnimation) {
        self.landingLeftButton.hidden = NO;
        self.landingRightButton.hidden = YES;//NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _image = nil;
}

- (void)viewDidUnload {
    [self setInfoButton:nil];
    [self setBottomLogoImageView:nil];
    [self setV2LeftButton:nil];
    [self setV2RightButton:nil];
    [super viewDidUnload];
}

- (void)enableBgImageSwitch {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerActionForBgImageSwitch) userInfo:nil repeats:YES];
    [timer performSelector:@selector(fire) withObject:nil afterDelay:15];
}

- (void)timerActionForBgImageSwitch {
    static UInt8 _imageNumber = 0;
    _imageNumber++;
    NSString *imageName = [NSString stringWithFormat:@"kal_menu%d.jpg", _imageNumber%3 + 1];
    self.kaleidoscopeContentImage = [UIImage imageNamed:imageName];
}

#pragma mark - animations
- (void)doBottomAnimation {
    self.infoButton.hidden = NO;
    self.infoButton.alpha = 0.0f;
    self.bottomLogoImageView.hidden = NO;
    self.bottomLogoImageView.alpha = 0.0f;
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDuration options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.infoButton.alpha = 0.6f;
                         self.bottomLogoImageView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)doTitleAnimation {
    CGRect srcFrame = self.titleImageView.frame;
    CGRect desFrame = self.titleImageView.frame;
    srcFrame.origin.y -= srcFrame.size.width * 0.5;
    self.titleImageView.frame = srcFrame;
    self.titleImageView.hidden = NO;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.titleImageView.frame = desFrame;
    } completion:^(BOOL finished) {
        [self doCenter0Animation];
    }];
}

- (void)doCenter0Animation {
    CGPoint srcPoint = self.centerBorderImageView.center;
    CGPoint desPoint = CGPointMake(-self.centerBorderImageView.bounds.size.width*0.5, srcPoint.y);
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.centerBorderImageView.center = desPoint;
                     } completion:^(BOOL finished) {
                         [self.centerContent0ImageView removeFromSuperview];
                         self.centerBorderImageView.center = srcPoint;
                         [self doCenter1Animation];
                     }];
}

- (void)doCenter1Animation {
    CGPoint srcPoint = CGPointMake(self.view.bounds.size.width + self.centerBorderImageView.bounds.size.width*0.5, self.centerBorderImageView.center.y);
    CGPoint desPoint = self.centerBorderImageView.center;
    self.centerBorderImageView.clipsToBounds = YES;
    [self.centerBorderImageView addSubview:self.centerContent1View];
    
    self.centerBorderImageView.center = srcPoint;
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.centerBorderImageView.center = desPoint;
                     } completion:^(BOOL finished) {
                         [self doCenter1ContentAnimation:kContent1Count];
                     }];
}

- (void)doCenter1ContentAnimation:(NSUInteger)aCount {
    if (!aCount) {
        [self doCenter1FinishedAnimation];
    }
    
    [UIView animateWithDuration:kAnimationDuration-0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGPoint center = self.centerContent1View.center;
                         center.x -= self.centerBorderImageView.bounds.size.width;
                         self.centerContent1View.center = center;
                     } completion:^(BOOL finished) {
                         [self doCenter1ContentAnimation:aCount-1];
                     }];
    
}

- (void)doCenter1FinishedAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.centerContent1View.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.centerBorderImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
                                              self.centerBorderImageView.alpha = 0.2f;
                                          } completion:^(BOOL finished) {
                                              [self.centerBorderImageView removeFromSuperview];
                                          }];
                         [self doTwoButtonAnimation];
                     }];
}

- (void)doTwoButtonAnimation {
    self.landingLeftButton.hidden = NO;
    self.landingRightButton.hidden = YES;//NO;
    self.landingLeftButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    self.landingRightButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    self.landingLeftButton.alpha = 0.2f;
    self.landingRightButton.alpha = 0.2f;
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.landingLeftButton.alpha = 1.0f;
                         self.landingRightButton.alpha = 1.0f;
                         self.landingLeftButton.transform = CGAffineTransformIdentity;
                         self.landingRightButton.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self allAnimationDone];
                     }];
}

- (void)allAnimationDone {
    [self enableBgImageSwitch];
    _bOnAnimation = NO;
}

- (void)doGoV2Animation {
    self.landingLeftButton.enabled = NO;
    self.landingRightButton.enabled = NO;
    
    self.v2LeftButton.hidden = NO;
    self.v2RightButton.hidden = NO;
    self.v2LeftButton.alpha = 0.4;
    self.v2RightButton.alpha = 0.4;
    self.v2LeftButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    self.v2RightButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.landingLeftButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
                         self.landingRightButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
                         self.v2LeftButton.alpha = 1.0f;
                         self.v2RightButton.alpha = 1.0f;
                         self.v2LeftButton.transform = CGAffineTransformIdentity;
                         self.v2RightButton.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         self.landingLeftButton.hidden = YES;
                         self.landingRightButton.hidden = YES;
                         self.landingLeftButton.enabled = YES;
                         self.landingRightButton.enabled = YES;

                     }];
    
    
}

#pragma mark - actions
- (IBAction)leftBtnAction:(id)sender {
    [self doGoV2Animation];
}

- (IBAction)rightBtnAction:(id)sender {
}

- (IBAction)infoBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"AboutInfo" sender:self];
}

// load from image lib
- (IBAction)v2LeftBtnAction:(id)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePickerVC animated:YES];
}

// camera
- (IBAction)v2RightBtnAction:(id)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:imagePickerVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ColorAnalyzer"]) {
        CLColorAnalyzerViewController *desVC = (CLColorAnalyzerViewController *)segue.destinationViewController;
        desVC.image = [_image fixOrientation];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    _image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [self performSegueWithIdentifier:@"ColorAnalyzer" sender:self];
}

@end
