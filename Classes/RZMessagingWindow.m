//
//  RZMessagingWindow.m
//  bhphoto
//
//  Created by alex.rouse on 8/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZMessagingWindow.h"

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
@property (weak, nonatomic) UIViewController *messageViewController;

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

@property (nonatomic, readonly) RZRootMessagingViewController *rootErrorVC;
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
    messageWindow.hidden = NO;
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
    return [self.errorsToDisplay firstObject];
}

- (BOOL)isCurrentlyDisplayingAnError
{
    return ((self.errorsToDisplay.count > 0 || self.errorPresented) || self.errorIsBeingPresented || self.errorIsBeingDismissed);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // If we arn't presenting any errors, just pass the touch through to the app.
    if ( self.errorsToDisplay.count == 0 ) {
        return nil;
    }
    else {
        RZMessage *displayedMessage = [self.errorsToDisplay firstObject];
        RZMessageStrength strength = displayedMessage.strength;
        
        UIView *result = [super hitTest:point withEvent:event];
        switch ( strength ) {
            case kRZMessageStrengthWeak:
                [self hideMessage:nil animated:displayedMessage.animated];
                if ( [result isKindOfClass:[RZErrorWindowPassThroughView class]] ) {
                    result = nil;
                }
                break;
            case kRZMessageStrengthStrong:
                [self hideMessage:nil animated:displayedMessage.animated];
                break;
            case kRZMessageStrengthWeakUserControlled:
                if ( [result isKindOfClass:[RZErrorWindowPassThroughView class]] ) {
                    result = nil;
                }
                break;
            case kRZMessageStrengthStrongUserControlled:
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
        [self hideDisplayedError];
    }
    else {
        NSInteger index = [self.errorsToDisplay indexOfObject:error];
        if ( index == 1 ) {
            [self hideDisplayedError];
        } else {
            [self.errorsToDisplay removeObject:error];
        }
    }
}

- (void)hideAllMessagesAnimated:(BOOL)animated
{
    //!TODO:  Make Animated property take affect here.
    if ( self.errorsToDisplay.count > 0 ) {
        [self.errorsToDisplay removeObjectsInRange:NSMakeRange(1, self.errorsToDisplay.count - 1)];
        [self forceHideDisplayedError];
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
    //!TODO: refactor this method a bit.
    if ( !self.errorPresented && !self.errorIsBeingPresented ) {
        self.errorIsBeingPresented = YES;
        UIViewController *messageVC = [[self.messageViewControllerClass alloc] init];
        [self.rootViewController addChildViewController:messageVC];
        [self.rootViewController.view addSubview:messageVC.view];
        [messageVC didMoveToParentViewController:self.rootViewController];
        message.messageViewController = messageVC;
        
        if ( self.viewConfigurationBlock != nil ) {
            self.viewConfigurationBlock(messageVC, self.rootViewController.view, message.error);
        }
        

        if ( message.animated && self.viewPresentationAnimationBlock != nil ) {
            self.viewPresentationAnimationBlock(messageVC, self.rootViewController.view, ^(BOOL finished) {
                self.errorPresented = YES;
                self.errorIsBeingPresented = NO;
            });
        }
        else {
            self.errorPresented = YES;
            self.errorIsBeingPresented = NO;
        }
        if (message.strength == kRZMessageStrengthStrong || message.strength == kRZMessageStrengthStrongUserControlled) {
            [UIView animateWithDuration:((message.animated) ? RZErrorWindowBlackoutAnimationInterval : 0.0f) animations:^{
                self.backgroundInterceptView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
            }];
        }
        
    }
}

- (void)hideDisplayedError
{
    if ( self.errorPresented == YES ) {
        RZMessage *message = [self.errorsToDisplay firstObject];
        if ( self.viewDismissalAnimationBlock != nil && message.animated ) {
            self.errorIsBeingDismissed = YES;
            self.viewDismissalAnimationBlock(message.messageViewController, self.rootViewController.view, ^(BOOL finished) {
                [message.messageViewController willMoveToParentViewController:nil];
                [message.messageViewController.view removeFromSuperview];
                [message.messageViewController removeFromParentViewController];
                self.errorIsBeingDismissed = NO;
            });
        }
        else {
            [message.messageViewController willMoveToParentViewController:nil];
            [message.messageViewController.view removeFromSuperview];
            [message.messageViewController removeFromParentViewController];
        }
        if (message.strength == kRZMessageStrengthStrong || message.strength == kRZMessageStrengthStrongUserControlled) {
            [UIView animateWithDuration:((message.animated) ? RZErrorWindowBlackoutAnimationInterval : 0.0f) animations:^{
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

- (void)forceHideDisplayedError
{
    if ( self.errorPresented || self.errorIsBeingPresented ) {
        RZMessage *message = [self.errorsToDisplay firstObject];
        if ( self.viewDismissalAnimationBlock != nil && message.animated ) {
            self.errorIsBeingDismissed = YES;
            self.viewDismissalAnimationBlock(message.messageViewController, self.rootViewController.view, ^(BOOL finished) {
                [message.messageViewController willMoveToParentViewController:nil];
                [message.messageViewController.view removeFromSuperview];
                [message.messageViewController removeFromParentViewController];
                self.errorIsBeingDismissed = NO;
            });
        }
        else {
            [message.messageViewController willMoveToParentViewController:nil];
            [message.messageViewController.view removeFromSuperview];
            [message.messageViewController removeFromParentViewController];
        }
        if (message.strength == kRZMessageStrengthStrong || message.strength == kRZMessageStrengthStrongUserControlled) {
            [UIView animateWithDuration:((message.animated) ? RZErrorWindowBlackoutAnimationInterval : 0.0f) animations:^{
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
@end
