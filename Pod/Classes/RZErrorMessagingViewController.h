//
//  RZErrorMessagingViewController.h
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;
#import <RaisinToast/RZMessagingWindow.h>

OBJC_EXPORT NSString * const kRZLevelError;
OBJC_EXPORT NSString * const kRZLevelInfo;
OBJC_EXPORT NSString * const kRZLevelWarning;
OBJC_EXPORT NSString * const kRZLevelPositive;

@interface RZErrorMessagingViewController : UIViewController <RZMessagingViewController>

@property (strong, nonatomic) NSDictionary *colorForLevelDictionary;
@property (assign, nonatomic) CGFloat errorMessagingViewVisibleHeight;
@property (assign, nonatomic) CGFloat errorMessagingViewVerticalPadding;

@end
