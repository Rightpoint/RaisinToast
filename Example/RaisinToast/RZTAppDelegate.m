//
//  RZTAppDelegate.m
//  RaisinToast
//
//  Created by CocoaPods on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import "RZTAppDelegate.h"
#import "RZMessagingWindow.h"
#import "RZErrorMessenger.h"
#import "RZTSubclassedErrorMessagingViewController.h"
#import "RZTSubclassNewXibErrorViewController.h"
#import "RZTCustomErrorViewController.h"

@implementation RZTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if ( self.errorWindow == nil ) {
        self.errorWindow = [RZMessagingWindow messagingWindow];
        [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
        self.errorWindow.messageViewControllerClass = [RZErrorMessagingViewController class];
    }
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
