//
//  RZMessagingWindow.h
//  RaisinToast
//
//  Created by alex.rouse on 8/13/14.
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

#pragma mark - Declarations

/**
 *  The strength of the Error message.  This is used to specify how the error is displayed
 *  as well as what the user has to do to dismiss the error message
 */
typedef NS_ENUM(u_int8_t, RZMessageStrength)
{
    /**
     *  A weak error message.  This is one that displays and as soon as a user taps anywhere
     *  it dismisses.
     */
    kRZMessageStrengthWeakAutoDismiss,
    /**
     *  A strong error message.  This is displayed and blacks out the screen behind it.  The
     *  user must click the message to dismiss
     */
    kRZMessageStrengthStrongAutoDismiss,
    /**
     *  An error message that will display but not block any touches.  The presenter
     *  of the error message must dismiss the error when they are done.
     */
    kRZMessageStrengthWeak,
    /**
     *  An error message that blocks user touches and doesn't dismiss until the presenter of
     *  the error tells it to dismiss.
     */
    kRZMessageStrengthStrong
};

/**
 *  Completion block type for getting a finished status when a UIView animation completes
 *
 *  @param finished BOOL indicating the animation is complete
 */
typedef void(^RZMessagingWindowAnimationCompletionBlock)(BOOL finished);

#pragma mark - RZMessagingWindow

/**
 *  Protocol to support if using a custom view controller for presenting errors. If you provide preferredStatusBarStyle in your custom messaging view controller the error message will use the specified style when an error presents and can animate it in and out.
 */
@protocol RZMessagingViewController <NSObject>
/**
 *  Typically responsible for, but not limited to, configuring the error UI based on the received error.
 *
 *  @param error An error containing information a localizedDescription, commonly used as a title and a localizedRecoverySuggestion commonly used as the body.  If provided, a userInfo dictionary key of RZErrorMessengerErrorKeyLevel will be used to set the background color from the colorForLevelDictionary based on the strength of the error (kRZLevelError, etc.)
 */
- (void)rz_configureWithError:(NSError *)error;

/**
 *  Sets up the appearance of the error message and configures the height of the error window to match the message.
 *
 *  Call [self setNeedsStatusBarAppearanceUpdate] inside this method to respect the preferredStatusBarStyle you provide in your messaging view controller
 *
 *  @param animated   If error appearance is animated, responsible for providing the animation block and executing the completion block upon finishing.  Without animation, it simply presents the error and executes the completion block.
 *  @param completion Any code to execute once presented. For example you could not use autodismiss property (dismisses on tap) and have the completion handler start a timer and dismiss the error window upon expiration.
 */
- (void)rz_presentAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;

/**
 *  Sets up the constraints necessary to hide the error window and animate if desired.
 *
 *  Call [self setNeedsStatusBarAppearanceUpdate] inside this method to respect the preferredStatusBarStyle you provide in your messaging view controller
 *
 *  @param animated   If animated, will configure the view animation and execute the completion block if provided. If not, it just calls the completion block.
 *  @param completion Cleanup to do after an error is dismissed. For example you may want to pop out of a view controller or reload a network request.
 */
- (void)rz_dismissAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;

@optional
/**
 *  Establishes constraints necessary for programatically animating the appearance and disappearance of the error window.
 *
 *  @param container The error container object used by an element to attach constraints.
 */
- (void)rz_configureLayoutForContainer:(UIView *)container;

@end

/**
 *  A UIWindow subclass used to message information to the users of your app.  This currently
 *  sits at the standard windowLevel so it should be added after your main application window.
 *  If needed you can change the windowLevel to statusBar or Alert to always sit on top.
 */
@interface RZMessagingWindow : UIWindow

/**
 *  Set this to tell the window what class of ViewController it should initialize.  A standard 
 *  [[Class alloc] init] will be called on it and added to the subview and the viewController.
 */
@property (assign, nonatomic) Class <RZMessagingViewController> messageViewControllerClass;

/**
 * Set this to assign an instance of ViewController that conforms to RZMessagingViewController.
 * If such ViewController is set on the window it takes a precedence over a ViewController that
 * would be created from the property messageViewControllerClass.
 */
@property (strong, nonatomic) UIViewController <RZMessagingViewController> *messageViewControllerInstance;

/**
 *  The Message that is currently being displayed.
 */
@property (nonatomic, readonly) NSError *displayedError;

/**
 *  Returns a flag if the window is currently displaying an error, presenting and error, or dismissing.
 */
@property (nonatomic, readonly) BOOL isCurrentlyDisplayingAnError;

/**
 *  Designated Initializer.  This does not return a shared instance.  Should only be called once
 *  unless you want multiple instances of the window.
 *
 *  @return The RZMessagingWindow instance.
 */
+ (instancetype)messagingWindow;

/**
 *  Returns a messagingWindow configured with default colors and to use RZErrorMessagingViewController
 *
 *  @return fully configured RZMessagingWindow
 */
+ (instancetype)defaultMessagingWindow;

/**
 *  Shows a message from an NSError object.  This object will be passed to the messageVC that you
 *  provide in the viewConfigurationBlock.
 *
 *  @param error The error containing your message information.
 */
- (void)showMessageFromError:(NSError *)error;

/**
 *  Shows a message from an NSError object.  The object will be passed to the messageVC that you 
 *  provide in the ViewConfigurationBlock.
 *  The display strength will determin what interaction needs to be taken to dismiss the Message
 *  and how it will be animated.
 *
 *  @param error    The error container the message information.
 *  @param strength The strength of the message.
 *  @param animated if the presentation should be animated or not.
 */
- (void)showMessageFromError:(NSError *)error strength:(RZMessageStrength)strength animated:(BOOL)animated;

/**
 *  Hides a displayed message if it is currently being shown, or removes it from the queue if it
 *  hasen't made it to the screen yet.  If nil is passed in for the error object, the first message
 *  will automatically be removed.
 *
 *  @param error    The error pertaining to the message to be removed.
 *  @param animated if the hide should be animated or not.
 */
- (void)hideMessage:(NSError *)error animated:(BOOL)animated;

/**
 *  Hides all messages and clears out the entire queue.
 *
 *  @param animated if the removal should be animated or not.
 */
- (void)hideAllMessagesAnimated:(BOOL)animated;

/**
 *  Returns the strength of the displayed error message.  If no error message will return weak.
 *
 *  @return The message strength of the displayed error
 */
- (RZMessageStrength)strengthOfDisplayedError;

@end

#pragma mark - RZRootMessagingViewController

/**
 *  Root messaging View Controller. This is the class of the RZMessagingWindow root view controller. Very simple implementation.
 */
@interface RZRootMessagingViewController : UIViewController
@end
