//
//  CLAppDelegate.m
//  MyDemos
//
//  Created by Cai Lei on 4/23/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLAppDelegate.h"
#import <DDTTYLogger.h>
int ddLogLevel;

@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupLogger];
    return YES;
}

- (void)setupLogger
{
    ddLogLevel = LOG_LEVEL_VERBOSE;

    UIColor *pink = [UIColor colorWithRed:(255 / 255.0) green:(58 / 255.0) blue:(159 / 255.0) alpha:1.0];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    // [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];

    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    char        *xcode_colors = getenv("XcodeColors");
    NSString    *xcodecolorsInfo = nil;

    if (xcode_colors) {
        if (strcmp(xcode_colors, "YES") == 0) {
            xcodecolorsInfo = @"XcodeColors enabled";
            [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        } else {
            xcodecolorsInfo = @"XcodeColors disabled";
        }
    } else {
        xcodecolorsInfo = @"XcodeColors not detected";
    }

    DDLogVerbose(@"%@", xcodecolorsInfo);
}

@end