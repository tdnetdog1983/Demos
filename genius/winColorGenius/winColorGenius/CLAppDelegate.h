//
//  CLAppDelegate.h
//  winColorGenius
//
//  Created by Cai Lei on 5/6/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import <UIKit/UIKit.h>

//server
#import "CL434Service.h"
#import "WCNaviFileService.h"
#import "WCStrategyService.h"
#import "WC101Service.h"
#import "WC301Service.h"

@interface CLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) WCNaviFileItem *naviServiceItem;

@end
