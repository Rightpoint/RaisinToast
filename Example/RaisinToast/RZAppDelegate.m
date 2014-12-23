//
//  RZAppDelegate.m
//  RaisinToast
//
//  Created by CocoaPods on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import "RZAppDelegate.h"
#import <RaisinToast/RZMessagingWindow.h>
#import <RaisinToast/RZErrorMessenger.h>
#import <RaisinToast/RZErrorMessagingViewController.h>

@implementation RZAppDelegate

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
    self.errorWindow = [RZMessagingWindow messagingWindow];
    self.errorWindow.messageViewControllerClass = [RZErrorMessagingViewController class];
    
    
    self.errorWindow.viewCreationBlock = ^UIViewController *(NSError *configuration) {
        return [[RZErrorMessagingViewController alloc] init];
    };
    
    self.errorWindow.viewConfigurationBlock = ^void(UIViewController *messageVC, UIView *containerView, NSError *configuration) {
        
        RZErrorMessagingViewController *errorVC = (RZErrorMessagingViewController *)messageVC;
        
        [errorVC createConstraintsWithContainer:containerView];
        
        [errorVC updateWithError:configuration];
    };
    
    self.errorWindow.viewPresentationAnimationBlock = ^void(UIViewController *messageVC, UIView *containerView, RZMessagingWindowAnimationCompletionBlock completion) {
        
        RZErrorMessagingViewController *errorVC = (RZErrorMessagingViewController *)messageVC;
        [errorVC updateViewForDisplay:YES completion:completion];
    };
    
    self.errorWindow.viewDismissalAnimationBlock = ^void(UIViewController *messageVC, UIView *containerView, RZMessagingWindowAnimationCompletionBlock completion) {
        
        RZErrorMessagingViewController *errorVC = (RZErrorMessagingViewController *)messageVC;
        [errorVC updateViewForDisplay:NO completion:completion];
    };
    
    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:@"org.cocoapods.demo.RaisinToast.error"];
    
}

@end
