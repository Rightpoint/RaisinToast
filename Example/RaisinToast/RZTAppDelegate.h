//
//  RZTAppDelegate.h
//  RaisinToast
//
//  Created by CocoaPods on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZMessagingWindow;

typedef NS_ENUM(u_int8_t, RZTWindowType) {
    kRZTWindowTypeDefault,
    RZTWindowTypeSubclassedForStyle,
    RZTWindowTypeSubclassedWithCustomXib,
    RZTWindowTypeCustomAlertViewVC
};

@interface RZTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RZMessagingWindow *errorWindow;

- (void)reconfigureMessagingWindowForDemoPurposes:(RZTWindowType)windowType;

@end
