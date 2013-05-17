//
//  CLAppDelegate.m
//  winColorGenius
//
//  Created by Cai Lei on 5/6/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLAppDelegate.h"
#import <DDTTYLogger.h>

#import "WCPlistHelper.h"

int ddLogLevel;

@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"winColorGenius-Info" ofType:@"plist"];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle synchronizeFile];
    
    [self setupLogger];
    [self setupNetworkServices];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
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

- (void)setupNetworkServices
{
    WCNaviFileService *service = [[WCNaviFileService alloc] init];
    service.naviURLString = kNaviURL;
    
    [service startWithBlock:^(WCNaviFileItem * retItem, NSError * error) {
        self.naviServiceItem = retItem;
        NSLog (@"%@", retItem.salt);
        
        if (!error) {
            DDLogError(@"navi success, %@", retItem.salt);
            
            [WCGlobalSingleton sharedInstance].gNaviFileItem = retItem;
            [WCGlobalSingleton sharedInstance].gNaviFileItem.loadFinished = TRUE;
            
            // just for test purpose
            //[self load301];
        } else {
            DDLogError(@"navi error, %@", retItem.salt);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"致命错误" message:@"网络连接失败，请重新启动程序" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self init101];
        //[self performSelector:@selector(getAllTree) withObject:nil afterDelay:0.5];
    }];
}

-(void)init101
{
    WC101Service *service = [[WC101Service alloc]init];
    [service startWithBlock:^(NSString *token, NSError *err) {
        if (!err) {
            [WCGlobalSingleton sharedInstance].gToken=token;
        }
        [self load301];
//        [self post434];
    }];
}

- (void)load301 {
    WC301Service *service = [[WC301Service alloc] init];
    
    service.grp = [[WCGlobalSingleton sharedInstance] gGrp];
    service.serviceURLString = self.naviServiceItem.query;
    
    [service startWithBlock:^(NSString *ver, NSString *urlStr, NSError *error) {
        if (!error) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *version = [prefs objectForKey:gSWVersion];
            if (![version isEqualToString:ver]) {
                // I don't want to bother user about upgrade every 4 hours even if they really don't want to
                [prefs setObject:ver forKey:gSWVersion];
                [prefs synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                });
            }
        }
    }];
}

- (void)post434
{
    CL434Service *service = [[CL434Service alloc] init];
    
    service.serviceURLString = self.naviServiceItem.upload;
    [service startWithBlock:^(NSArray *resultArr, NSError *error) {
        if (error) {
            
        }
    }];
    
}


@end
