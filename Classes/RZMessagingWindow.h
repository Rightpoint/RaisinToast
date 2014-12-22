//
//  RZMessagingWindow.h
//  bhphoto
//
//  Created by alex.rouse on 8/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
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
    kRZMessageStrengthWeak,
    /**
     *  A strong error message.  This is displayed and blacks out the screen behind it.  The
     *  user must click the message to dismiss
     */
    kRZMessageStrengthStrong,
    /**
     *  An error message that will display but not block any touches.  The presenter
     *  of the error message must dismiss the error when they are done.
     */
    kRZMessageStrengthWeakUserControlled,
    /**
     *  An error message that blocks user touches and doesn't dismiss until the presenter of
     *  the error tells it to dismiss.
     */
    kRZMessageStrengthStrongUserControlled
};

typedef UIViewController *(^RZMessagingWindowViewCreationBlock)(NSError *configuration);

/**
 *  ViewController configuration block.  Given a viewController of the passed in class and allows the caller
 *  to configure its layout and other properties based off of an NSError object.
 *
 *  @param messageViewController The newly created Viewcontroller.  Will be added to the container view already.
 *  @param containerView         The container for the messageViewController.
 *  @param configuration         The NSError object that is used to configure the message viewController.
 */
typedef void(^RZMessagingWindowViewControllerBlock)(UIViewController *messageViewController, UIView *containerView, NSError *configuration);

typedef void(^RZMessagingWindowAnimationCompletionBlock)(BOOL finished);

/**
 *  An animation block for presenting or dismissing a message View controller.
 *
 *  @param messageVC     The viewController that is going to be presented/dismissed.
 *  @param containerView The container view that the viewcontroller lives inside.
 */
typedef void(^RZMessagingWindowAnimationBlock)(UIViewController *messageVC, UIView *containerView, RZMessagingWindowAnimationCompletionBlock completion);

#pragma mark - RZMessagingWindow

/**
 *  A UIWindow subclass used to message information to the users of your app.  This currently
 *  sits at the standard windowLevel so it should be added after your main application window.
 *  If needed you can change the windowLevel to statusBar or Alert to always sit on top.
 */
@interface RZMessagingWindow : UIWindow

/**
 *  Used to get the ViewController and configure it in the main View.  See 
 *  RZMessagingWindowViewControllerBlock for more info.
 */
@property (copy, nonatomic) RZMessagingWindowViewControllerBlock viewConfigurationBlock;

@property (copy, nonatomic) RZMessagingWindowViewCreationBlock viewCreationBlock;
@property (copy, nonatomic) RZMessagingWindowAnimationBlock viewPresentationAnimationBlock;
@property (copy, nonatomic) RZMessagingWindowAnimationBlock viewDismissalAnimationBlock;

/**
 *  Set this to tell the window what class of ViewController it should initialize.  A standard 
 *  [[Class alloc] init] will be called on it and added to the subview and the viewController.
 */
@property (assign, nonatomic) Class messageViewControllerClass;


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
 *  Root messaging View Controller.  Very simple implementation.
 */
@interface RZRootMessagingViewController : UIViewController
@end
