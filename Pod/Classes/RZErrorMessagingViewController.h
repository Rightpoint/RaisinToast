//
//  RZErrorMessagingViewController.h
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@class BHError;

OBJC_EXTERN CGFloat const kRZErrorMessagingViewVisibleHeight;
OBJC_EXTERN CGFloat const kRZErrorMessagingViewVerticalPadding;

@interface RZErrorMessagingViewController : UIViewController


- (void)updateWithError:(NSError *)error;

- (void)createConstraintsWithContainer:(UIView *)container;

- (void)updateViewForDisplay:(BOOL)visible completion:(void (^)(BOOL finished))completion;

@end
