//
//  RZErrorMessagingViewController.h
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
// Copyright 2014 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

@import UIKit;
#import "RZMessagingWindow.h"

OBJC_EXPORT NSString * const kRZLevelError;
OBJC_EXPORT NSString * const kRZLevelInfo;
OBJC_EXPORT NSString * const kRZLevelWarning;
OBJC_EXPORT NSString * const kRZLevelPositive;

@interface RZErrorMessagingViewController : UIViewController <RZMessagingViewController>

/**
 *  Title label appears at the top of the alert
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  Detail label is the description of the alert/error
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/**
 *  A dictionary with values representing your custom color for kRZLevelError, kRZLevelInfo, kRZLevelWarning, kRZLevelPositive
 */
@property (copy, nonatomic) NSDictionary *colorForLevelDictionary;

/**
 *  The minimum height of the error messaging view
 */
@property (assign, nonatomic) CGFloat errorMessagingViewVisibleHeight;

/**
 *  The padding to apply to the top of the error messaging view. 20.0f places the view at the top of the screen.
 */
@property (assign, nonatomic) CGFloat errorMessagingViewVerticalPadding;

@end
