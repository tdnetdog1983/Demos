//
//  WCGlobalSingleton.m
//  winCRM
//
//  Created by Cai Lei on 1/30/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

#import "WCGlobalSingleton.h"
#import "UIDevice+IdentifierAddition.h"

static WCGlobalSingleton *sharedInstance;
@implementation WCGlobalSingleton

+ (void)initialize {
    NSAssert([WCGlobalSingleton class] == self, @"Incorrect use of singleton : %@, %@", [WCGlobalSingleton class], [self class]);
    sharedInstance = [[WCGlobalSingleton alloc] init];
}

+ (WCGlobalSingleton *)sharedInstance {
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    // network
    _gToken = kCommonToken;
    _gIMEI = [UIDevice macAddress];
    _gPlatform = kCommonPlatform;
    _gGrp = kCommonGrp;
    _gVer = [WCPlistHelper swVersionFromProjectPlist];
    _gSw = kCommonSw;
    _gLang = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    _gSrc = kCommonSrc;
    
    // setup navi item
    _gNaviFileItem = [[WCNaviFileItem alloc] init];
    _gNaviFileItem.loadFinished = FALSE;
    _gNaviFileItem.salt = kNaviSalt;
    _gNaviFileItem.query = kNaviQuery;
    _gNaviFileItem.upload = kNaviUpload;
    
}

//- (CLDownloadManager *)gDM {
//    if (!_gDM) {
//        _gDM = [[CLDownloadManager alloc] init];
//    }
//    
//    return _gDM;
//}

#pragma mark - util methods
+ (UIImage *)imageWithColor:(UIColor *)aColor forRect:(CGRect)aRect {
    UIGraphicsBeginImageContextWithOptions(aRect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aColor set];
    CGContextFillRect(context, aRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)configureButton:(UIButton *)aButton {
    UIImage *btnBgImage = [UIImage imageNamed:@"小按钮"];
    btnBgImage = [btnBgImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *btnBgHighlightImage = [UIImage imageNamed:@"小按钮点击时"];
    btnBgHighlightImage = [btnBgHighlightImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    [aButton setBackgroundImage:btnBgHighlightImage forState:UIControlStateHighlighted];
}

@end
