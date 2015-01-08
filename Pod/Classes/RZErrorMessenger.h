//
//  RZErrorMessenger.h
//  RaisinToast
//
//  Created by alex.rouse on 8/11/14.
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

@import Foundation;
#import "RZMessagingWindow.h"

/**
 *  The level possibilities for the Error messages.
 */
typedef NS_ENUM(u_int8_t, RZErrorMessengerLevel) {
    /**
     *  An error, commonly red in color.
     */
    kRZErrorMessengerLevelError,
    /**
     *  A warning, commonly orange in color.
     */
    kRZErrorMessengerLevelWarning,
    /**
     *  An informational message, commonly blue in color.
     */
    kRZErrorMessengerLevelInfo,
    /**
     *  Positive feedback, commonly green in color.
     */
    kRZErrorMessengerLevelPositive
};

@interface RZErrorMessenger : NSObject

/**
 *  Displays an error given a title and detail.  Defaults to A weak error and Severe alert type.
 *  Also sets animated to YES.
 *
 *  @param title  the title of the error.
 *  @param detail the detail message of the error.
 */
+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail;

/**
 *  Displays an error given a title and details.  Defaults to A weak error and Severe alert type.
 *  Also sets animated to YES.
 *
 *  @param title    The title of the error.
 *  @param details  An array of strings to be concatenated into an error message.
 */
+ (NSError *)displayErrorWithTitle:(NSString *)title details:(NSArray *)details;

/**
 *  Displays an error given a title and detail as well as a level.  Default Severity type is Weak.
 *
 *  @param title  The title of the error
 *  @param detail The detail message of the error
 *  @param level  The level to display the error
 *
 *  @return The new error object.
 */
+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail level:(RZErrorMessengerLevel)level;

/**
 *  Displays an error.  Defaults to weak and Red.  Also is Animated
 *
 *  @param error The error to display.
 */
+ (NSError *)displayError:(NSError *)error;


/**
 *  Creates and displays error and updates it with a couple standard error cases.  If none of those exist it uses the
 *  passed in title and detail as its text.
 *
 *  @param title  the fallback title
 *  @param detail the fallback detail
 *  @param error  the error that will be checked for standard cases.
 */
+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail error:(NSError *)error;

/**
 *  This displays an error with the strength passed in.  This should be used as the primary
 *  method for displaying any error messages.
 *
 *  @param error    The error container the required information
 *  @param strength The strength of the error message displayed.
 *  @param animated if the error should be displayed animated.
 */
+ (NSError *)displayError:(NSError *)error withStrength:(RZMessageStrength)strength animated:(BOOL)animated;

/**
 *  This displays an error with the strength and level passed in.  All other presentation 
 *  methods pass through this method.
 *  Error.localizedDescription will be used for the title of the error alert.
 *  Error.localizedRecoverSuggestion will be used for the detail text of the error.
 *
 *  @param error    The error container information about the message.
 *  @param strength The strength of the error message displayed.
 *  @param level    The level of the error message.
 *  @param animated If the error should animate.
 *
 *  @return An error instance that is modified.  Used to dismiss the message by an error.
 */
+ (NSError *)displayError:(NSError *)error withStrength:(RZMessageStrength)strength level:(RZErrorMessengerLevel)level animated:(BOOL)animated;


/**
 *  Hides the displayed error message.
 *
 *  @param animated if the hide should be animated
 */
+ (void)hideErrorAnimated:(BOOL)animated;

/**
 *  Hides an error based on the error instance.  If the error isn't displayed yet it will be 
 *  removed from the queue.
 *
 *  @param error         The error that is to be removed
 *  @param animated      if the hide should be animated.
 */
+ (void)hideError:(NSError *)error animated:(BOOL)animated;

/**
 *  Hides all the errors that displayed and destroys the queue of animations.
 */
+ (void)hideAllErrors;


/**
 *  Creates an error and updates it with a couple standard error cases.  If none of those exist it uses the
 *  passed in title and detail as its text.
 *
 *  @param title  the fallback title
 *  @param detail the fallback detail
 *  @param error  the error that will be checked for standard cases.
 */
+ (NSError *)errorWithDisplayTitle:(NSString *)title detail:(NSString *)detail error:(NSError *)error;

+ (BOOL)isErrorCurrentlyDisplayed;

+ (RZMessageStrength)strengthOfDisplayedError;

/**
 *  Configure a custom error domain to display on generated error messages
 *
 *  @param errorDomain NSString typically in reverse order. If unset defaults to com.raizlabs.error
 */
+ (void)setDefaultErrorDomain:(NSString *)errorDomain;

/**
 *  Configure the default messaging window to present the generated error messages. You must call setDefaultMessagingWindow with a valid RZMessagingWindow to display an error, typically in your app delegate when you configure the RZMessagingWindow view.
 *
 *  @param errorWindow RZMessagingWindow is configured with creation, configuration, presentation and dismissal blocks.
 */
+ (void)setDefaultMessagingWindow:(RZMessagingWindow *)errorWindow;

@end

/**
 *  Error extensions to support the method of display from the error messenger.
 */
@interface NSError (RZErrorMessenger)

/**
 *  Updates the level on the userInfo object of the NSError
 *
 *  @note  This returns a new instance of NSError since it isn't mutable
 *
 *  @param level The level stored in the NSError
 *
 *  @return A new NSError instance.
 */
- (NSError *)rz_updateLevelOnErrorWithLevel:(RZErrorMessengerLevel)level;

/**
 *  The level stored in the NSError's userInfo.  This is a convience method.
 *
 *  @return The level value.  Default is Error.
 */
- (RZErrorMessengerLevel)rz_levelFromError;

@end
