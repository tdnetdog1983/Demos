//
//  WCGlobalSingleton.h
//  winCRM
//
//  Created by Cai Lei on 1/30/13.
//  Copyright (c) 2013 com.cailei. All rights reserved.
//

//*/ mdm item
static NSString * const kDefaultDMURL = @"http://192.168.9.90:8080/mobilemdm/plugin.servlet";
//*/

//*/ fetch tree item
static NSString * const kDefaultFetchTreeURL = @"http://192.168.9.90:8080/mobilemdm/plugin.servlet";
//*/

//*/ phone info item
static NSString * const kDefaultPhoneInfoURL = @"http://192.168.9.90:8080/mobilemdm/plugin.servlet";
//*/

//*/ strategy item
static NSString * const kDefaultStrategyURL = @"http://192.168.9.90:8080/mobilemdm/plugin.servlet";
//*/

//*/ navi item
//static NSString * const kNaviURL = @"http://colorgenius.winmdm.com:8087/mdma_cccil.jpg";
//static NSString * const kNaviURL = @"http://192.168.1.63:8087/mdma_cccil.jpg";
static NSString * const kNaviURL = @"http://192.168.1.54:8087/mdma_cccil.jpg";

//static NSString * const kNaviURL = @"http://go.winmdm.com/2013/crmi_loreal.jpg";
static NSString * const kNaviSalt = @"7238799724734f41992b3890d575bb1d";
static NSString * const kNaviQuery = @"http://192.168.1.54:8087/plugin.servlet";
static NSString * const kNaviUpload = @"http://192.168.1.54:8087/plugin.servlet";
//*/

//*/ location
#define kGlobalLatitude         @ "global_latitude"
#define kGlobalLongitude        @ "global_longitude"
//*/

//*/ network
#define kCommonToken @""
#define kCommonPlatform @"crmi_loreal"
#define kCommonGrp @"colorgenius"
#define kCommonVer @"1.0.0"
#define kCommonSw @"CRM_LOREAL_A"
#define kCommonLang @"936"
#define kCommonSrc @"crmi_colorgenius_01"
//*/

//*/ settings from UED
#define NAV_BUTTON_SIZE  12
#define NAV_TITLE_SIZE   22
#define LIST_TITLE_SIZE       20
#define PRODUCT_SORT_TITLE_SIZE   22
#define TEXT_SIZE        18
#define BUTTON_TITLE_SIZE  18
#define ICON_TEXT_SIZE   20

#define PINK_COLOR  [UIColor colorWithRed:212.0f/255 green:0 blue:125.0f/255 alpha:1]
#define BLACK_COLOR  [UIColor colorWithRed:52.0f/255 green:52.0f/255 blue:52.0f/255 alpha:1]
#define GRAY_COLOR  [UIColor colorWithRed:113.0f/255 green:113.0f/255 blue:111.0f/255 alpha:1]
#define WHITE_COLOR  [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1]
#define YELLOW_COLOR  [UIColor colorWithRed:238.0f/255 green:222.0f/255 blue:187.0f/255 alpha:1]
#define GOLD_COLOR  [UIColor colorWithRed:192.0f/255 green:159.0f/255 blue:94.0f/255 alpha:1]
#define BG_TRANSPARENT_BLACK_COLOR  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define BLACK_TEXT_COLOR  [UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:1]

// landing page
#define GOLD_COLOR_NORMAL [UIColor colorWithRed:192.0f/255 green:159.0f/255 blue:94.0f/255 alpha:1]
#define GOLD_COLOR_HIGHLIGHT [UIColor colorWithRed:159.0f/255 green:115.0f/255 blue:53.0f/255 alpha:1]
#define BLACK_COLOR_LANDING_BG [UIColor colorWithRed:25.0f/255 green:25.0f/255 blue:25.0f/255 alpha:1]
#define LUCKYDRAW_ACVTCODE @"LOREAL_LOTTERY_1"

#define SIDE_MARGIN   20

#define HEIGHT_BIG_SIZE  190
#define HEIGHT_MEDIUM_SIZE  145
#define HEIGHT_SMALL_SIZE   85

#define DEFAULT_POINT  100
//*/

//*/ Sign In Up
#define gplistHAS_SIGN_IN       @"plist has sign in"
#define gplistHAS_LUCKY_DRAW    @"plist has lucky draw"
#define gplistUSER_NAME         @"plist user name"
#define gplistSOFTWARE_VERSION  @"plist software version"
#define gSWVersion              @"SWVersion"
//*/


#import <Foundation/Foundation.h>
#import "WCNaviFileService.h"

#pragma mark - WCGlobalSingleton interface

@interface WCGlobalSingleton : NSObject
+ (WCGlobalSingleton *)sharedInstance;

// network
@property (nonatomic, copy) NSString *gToken;
@property (nonatomic, copy) NSString *gIMEI;
@property (nonatomic, copy) NSString *gPlatform;
@property (nonatomic, copy) NSString *gGrp;
@property (nonatomic, copy) NSString *gVer;
@property (nonatomic, copy) NSString *gSw;
@property (nonatomic, copy) NSString *gLang;
@property (nonatomic, copy) NSString *gSrc;

// navi item
@property (nonatomic, strong) WCNaviFileItem *gNaviFileItem;

// util methods
+ (UIImage *)imageWithColor:(UIColor *)aColor forRect:(CGRect)aRect;
+ (void)configureButton:(UIButton *)aButton;

@end
