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
#import "RZTSubclassedErrorMessagingViewController.h"
#import "RZTSubclassNewXibErrorViewController.h"
#import "RZTCustomErrorViewController.h"

@implementation RZTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.errorWindow = [RZMessagingWindow messagingWindow];
    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - Public
- (void)reconfigureMessagingWindowForDemoPurposes:(RZTWindowType)windowType
{
    switch ( windowType ) {
        case kRZTWindowTypeDefault:
            self.errorWindow.messageViewControllerClass = [RZErrorMessagingViewController class];
            break;
        case RZTWindowTypeSubclassedForStyle:
            self.errorWindow.messageViewControllerClass = [RZTSubclassedErrorMessagingViewController class];
            break;
        case RZTWindowTypeSubclassedWithCustomXib:
            self.errorWindow.messageViewControllerClass = [RZTSubclassNewXibErrorViewController class];
            break;
        case RZTWindowTypeCustomAlertViewVC:
            self.errorWindow.messageViewControllerClass = [RZTCustomErrorViewController class];
            break;
        default:
            break;
    }
}

@end
