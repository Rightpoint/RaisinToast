//
//  RZTAppDelegate.m
//  RaisinToast
//
//  Created by CocoaPods on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import "RZTAppDelegate.h"
#import <RaisinToast/RZMessagingWindow.h>
#import <RaisinToast/RZErrorMessenger.h>
#import <RaisinToast/RZErrorMessagingViewController.h>

@implementation RZTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self setupMessagingWindow];
    return YES;
}

#pragma mark RaisinToast AppDelegate code
- (void)setupMessagingWindow
{
    self.errorWindow = [RZMessagingWindow defaultMessagingWindow];
    
    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
    
}
//    self.errorWindow = [RZMessagingWindow messagingWindow];
//    self.errorWindow.viewConfigurationBlock = ^void(UIViewController *messageVC, UIView *containerView, NSError *configuration) {
//        RZErrorMessagingViewController *errorVC = (RZErrorMessagingViewController *)messageVC;
//        [errorVC setColorForLevelDictionary:@{
//                                              kRZLevelError :[UIColor grayColor],
//                                              kRZLevelInfo : [UIColor blueColor],
//                                              kRZLevelWarning : [UIColor orangeColor],
//                                              kRZLevelPositive : [UIColor greenColor]
//                                              }];
//    };
@end
