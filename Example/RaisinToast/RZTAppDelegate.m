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
#import "RZTCustomViewController.h"

@implementation RZTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self setupDefaultMessagingWindow];
//    [self setupCustomMessagingWindow];
    return YES;
}

#pragma mark RaisinToast AppDelegate code
- (void)setupDefaultMessagingWindow
{
    self.errorWindow = [RZMessagingWindow defaultMessagingWindow];
    
    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
    
}

- (void)setupCustomMessagingWindow
{
    self.errorWindow = [RZMessagingWindow messagingWindow];
    self.errorWindow.messageViewControllerClass = [RZTCustomViewController class];
    
    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
    
}

@end
