//
//  RZAppDelegate.h
//  RaisinToast
//
//  Created by CocoaPods on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZMessagingWindow;

@interface RZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RZMessagingWindow *errorWindow;

@end
