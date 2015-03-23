//
//  RZMessagingWindow.m
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

#import "RZMessagingWindow.h"
#import "RZErrorMessagingViewController.h"

static CGFloat const RZErrorWindowBlackoutAnimationInterval = 0.5f;

/**
 *  This is used to identify what touches need to be passed through to the main application window.
 */
@interface RZErrorWindowPassThroughView : UIView
@end
@implementation RZErrorWindowPassThroughView
@end

/**
 *  This is used to hold information about each error along with their strength and animation properties.
 *  For internal use only.
 */
@interface RZMessage : NSObject
@property (strong, nonatomic) NSError *error;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) RZMessageStrength strength;
@property (weak, nonatomic) UIViewController <RZMessagingViewController> *messageViewController;

+ (instancetype)messageFromError:(NSError *)error animated:(BOOL)animated messageStrength:(RZMessageStrength)strength;

@end

@implementation RZMessage

+ (instancetype)messageFromError:(NSError *)error animated:(BOOL)animated messageStrength:(RZMessageStrength)strength
{
    RZMessage *message = [[RZMessage alloc] init];
    message.error = error;
    message.animated = animated;
    message.strength = strength;
    return message;
}

/**
 *  Used to determine if an error passed in is equal to a Message
 */
- (BOOL)isEqual:(id)object
{
    if ( [object isKindOfClass:[NSError class]] ) {
        return ( [object isEqual:self.error] );
    }
    else {
        return [super isEqual:object];
    }
}
@end

@interface RZMessagingWindow ()

@property (strong, nonatomic) NSMutableArray *errorsToDisplay;

@property (weak, nonatomic) UIView *backgroundInterceptView;

@property (assign, nonatomic) BOOL errorPresented;
@property (assign, nonatomic) BOOL errorIsBeingPresented;
@property (assign, nonatomic) BOOL errorIsBeingDismissed;
@end

@implementation RZMessagingWindow

+ (instancetype)messagingWindow
{
    RZMessagingWindow *messageWindow = [[RZMessagingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RZRootMessagingViewController *rootVC = [[RZRootMessagingViewController alloc] init];
    messageWindow.rootViewController = rootVC;
    //Automatically adds itself
    messageWindow.hidden = NO;
    return messageWindow;
}

+ (instancetype)defaultMessagingWindow
{
    RZMessagingWindow *messageWindow = [RZMessagingWindow messagingWindow];
    messageWindow.messageViewControllerClass = [RZErrorMessagingViewController class];
    return messageWindow;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.errorsToDisplay = [NSMutableArray array];
        self.opaque = NO;
        
    }
    return self;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    [super setRootViewController:rootViewController];
    [self configurePassThroughView];
}

- (NSError *)displayedError
{
    return [[self.errorsToDisplay firstObject] error];
}

- (BOOL)isCurrentlyDisplayingAnError
{
    return ((self.errorsToDisplay.count > 0 || self.errorPresented) || self.errorIsBeingPresented || self.errorIsBeingDismissed);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // If we aren't presenting any errors, just pass the touch through to the app.
    if ( self.errorsToDisplay.count == 0 ) {
        return nil;
    }
    else {
        RZMessage *displayedMessage = [self.errorsToDisplay firstObject];
        RZMessageStrength strength = displayedMessage.strength;
        
        UIView *result = [super hitTest:point withEvent:event];
        switch ( strength ) {
            case kRZMessageStrengthWeakAutoDismiss:
                [self hideMessage:nil animated:displayedMessage.animated];
                if ( [result isKindOfClass:[RZErrorWindowPassThroughView class]] ) {
                    result = nil;
                }
                break;
            case kRZMessageStrengthStrongAutoDismiss:
                [self hideMessage:nil animated:displayedMessage.animated];
                break;
            case kRZMessageStrengthWeak:
                if ( [result isKindOfClass:[RZErrorWindowPassThroughView class]] ) {
                    result = nil;
                }
                break;
            case kRZMessageStrengthStrong:
                // nop
                break;
        }
        return result;
    }
}

#pragma mark - Public Methods
- (void)showMessageFromError:(NSError *)error
{
    [self showMessageFromError:error strength:kRZMessageStrengthWeak animated:YES];
}

- (void)showMessageFromError:(NSError *)error strength:(RZMessageStrength)strength animated:(BOOL)animated
{
    NSParameterAssert(error);
    
    RZMessage *message = [RZMessage messageFromError:error animated:animated messageStrength:strength];
    [self showMessage:message];
    [self.errorsToDisplay addObject:message];

}

- (void)hideMessage:(NSError *)error animated:(BOOL)animated
{
    if ( error == nil ) {
        [self hideDisplayedErrorAnimated:animated force:NO];
    }
    else {
        NSInteger index = [self.errorsToDisplay indexOfObject:error];
        if ( index == 1 ) {
            [self hideDisplayedErrorAnimated:animated force:NO];
        } else {
            [self.errorsToDisplay removeObject:error];
        }
    }
}

- (void)hideAllMessagesAnimated:(BOOL)animated
{
    if ( self.errorsToDisplay.count > 0 ) {
        [self.errorsToDisplay removeObjectsInRange:NSMakeRange(1, self.errorsToDisplay.count - 1)];
        [self hideDisplayedErrorAnimated:animated force:YES];
    }
}

- (RZMessageStrength)strengthOfDisplayedError
{
    if ( self.errorsToDisplay.count > 0 ) {
        RZMessage *message = [self.errorsToDisplay firstObject];
        return message.strength;
    }
    return kRZMessageStrengthWeak;
}

#pragma mark - Private Methods
- (void)showMessage:(RZMessage *)message
{

    if ( !self.errorPresented && !self.errorIsBeingPresented ) {
        self.errorIsBeingPresented = YES;

        UIViewController <RZMessagingViewController> *messageVC = nil;
        if ( self.messageViewControllerInstance ) {
            messageVC = self.messageViewControllerInstance;
        }
        else {
            messageVC = [[(Class)self.messageViewControllerClass alloc] init];            
        }

        [self.rootViewController addChildViewController:messageVC];
        [self.rootViewController.view addSubview:messageVC.view];
        [messageVC didMoveToParentViewController:self.rootViewController];
        message.messageViewController = messageVC;
        if ( [messageVC respondsToSelector:@selector(rz_configureLayoutForContainer:)] ) {
            [messageVC rz_configureLayoutForContainer:self.rootViewController.view];
        }
        [messageVC rz_configureWithError:message.error];


        [messageVC rz_presentAnimated:message.animated completion:^(BOOL finished) {
            self.errorPresented = YES;
            self.errorIsBeingPresented = NO;
        }];

        if ( message.strength == kRZMessageStrengthStrong || message.strength == kRZMessageStrengthStrongAutoDismiss ) {
            [UIView animateWithDuration:((message.animated) ? RZErrorWindowBlackoutAnimationInterval : 0.0f) animations:^{
                self.backgroundInterceptView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
            }];
        }
        
    }
}

- (void)hideDisplayedErrorAnimated:(BOOL)animated force:(BOOL)force
{
    if ( self.errorPresented || (force && self.errorIsBeingPresented) ) {
        RZMessage *message = [self.errorsToDisplay firstObject];
        self.errorIsBeingDismissed = YES;
        [message.messageViewController rz_dismissAnimated:message.animated completion:^(BOOL finished) {
            [message.messageViewController willMoveToParentViewController:nil];
            [message.messageViewController.view removeFromSuperview];
            [message.messageViewController removeFromParentViewController];
            self.errorIsBeingDismissed = NO;
        }];

        if (message.strength == kRZMessageStrengthStrong || message.strength == kRZMessageStrengthStrongAutoDismiss) {
            [UIView animateWithDuration:( animated ? RZErrorWindowBlackoutAnimationInterval : 0.0f) animations:^{
                self.backgroundInterceptView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
            }];
        }

        self.errorPresented = NO;
        [self.errorsToDisplay removeObject:message];
        if ( self.errorsToDisplay.count > 0 ) {
            [self showMessage:[self.errorsToDisplay firstObject]];
        }
    }
}

- (void)configurePassThroughView
{
    RZErrorWindowPassThroughView *passThroughClass = [[RZErrorWindowPassThroughView alloc] initWithFrame:self.frame];
    passThroughClass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.rootViewController.view addSubview:passThroughClass];
    self.backgroundInterceptView = passThroughClass;
}

@end

#pragma mark - RZRootMessagingViewController

@implementation RZRootMessagingViewController

#pragma mark - Orientation method overrides

-(UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *topViewController = [RZRootMessagingViewController topViewController];

    UIStatusBarStyle statusBarStyle;
    
    if ( [(RZMessagingWindow *)self.view.window errorIsBeingPresented] ) {
        statusBarStyle = [super preferredStatusBarStyle];
    }
    else {
        statusBarStyle = [topViewController preferredStatusBarStyle];
    }
    return statusBarStyle;
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    UIViewController *topViewController = [RZRootMessagingViewController topViewController];
    
    UIViewController *childViewController;
    if ( [(RZMessagingWindow *)self.view.window errorIsBeingPresented] ) {
        childViewController = [self.childViewControllers lastObject];
    }
    else {
        childViewController = [topViewController childViewControllerForStatusBarStyle];
    }
    return childViewController;
    
}

-(BOOL)shouldAutorotate
{
    UIViewController *topViewController = [RZRootMessagingViewController topViewController];
    
    return [topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *topViewController = [RZRootMessagingViewController topViewController];
    
    return [topViewController supportedInterfaceOrientations];
}

#pragma mark - Helper class methods

/**
 * Find the presented top view controller of the keyed UIWindow's root view controller.
 *
 * @return Returns the visible, presented view controller.
 */
+ (UIViewController *)topViewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    return [RZRootMessagingViewController topViewControllerWithRootViewController:keyWindow.rootViewController];
}

/**
 * Find the presented top view controller recursively starting from the view
 * controller passed in the parameter.
 *
 * @param rootViewController View controller to start the recursive search
 *
 * @return Returns the visible, presented view controller, otherwise the view controller
 *         where the search started. 
 */
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ( [rootViewController isKindOfClass:[UINavigationController class]] ) {
        UINavigationController* navigationController = (UINavigationController *)rootViewController;
        return [RZRootMessagingViewController topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if ( rootViewController.presentedViewController ) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [RZRootMessagingViewController topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

@end
