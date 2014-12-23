//
//  RZErrorMessagingViewController.m
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZErrorMessagingViewController.h"
#import "RZErrorMessenger.h"

#import <RZUtils/NSString+RZStringSize.h>
#import <RZUtils/UIView+RZAutoLayoutHelpers.h>

CGFloat const kRZErrorMessagingViewVisibleHeight = 90.0f;
CGFloat const kRZErrorMessagingViewVerticalPadding = 20.0f;

@interface RZErrorMessagingViewController ()

@property (weak, nonatomic) IBOutlet UIView *errorContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) NSLayoutConstraint *bottomAnimationConstraint;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) NSError *displayedError;

@end

@implementation RZErrorMessagingViewController

#pragma mark - UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Since we are presented in a different window.  Rotation is handled a bit odd...  May make this better later though.
    CGFloat width = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ? self.view.superview.frame.size.width : self.view.superview.frame.size.height;
    width -= 2 * kRZErrorMessagingViewVerticalPadding;
    CGFloat newHeight = [self updatedHeightWithWidth:width];
    self.heightConstraint.constant = newHeight;
    self.bottomAnimationConstraint.constant = newHeight - kRZErrorMessagingViewVerticalPadding;
    [self.view layoutIfNeeded];
}

#pragma mark - Public Methods
- (void)updateWithError:(NSError *)error
{
    self.displayedError = error;

    self.titleLabel.text = [error.localizedDescription uppercaseString];
    self.detailLabel.text = error.localizedRecoverySuggestion;
    
    switch ( [error rz_levelFromError] ) {
        case kRZErrorMessengerLevelError:
            self.errorContainer.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:56.0f/255.0f blue:54.0f/255.0f alpha:1.0f];
            break;
        case kRZErrorMessengerLevelInfo:
            self.errorContainer.backgroundColor = [UIColor colorWithRed:66.0f/255.0f green:151.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
            break;
        case kRZErrorMessengerLevelWarning:
            self.errorContainer.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:172.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            break;
        case kRZErrorMessengerLevelPositive:
            self.errorContainer.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            break;
        default:
            self.errorContainer.backgroundColor = [UIColor colorWithRed:66.0f/255.0f green:151.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
            break;
    }
    CGFloat updatedHeight = [self updatedHeight];
    self.heightConstraint.constant = updatedHeight;
    [self.view layoutIfNeeded];
}

- (void)createConstraintsWithContainer:(UIView *)container
{
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    // Setup all the needed constraints for the view.
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:kRZErrorMessagingViewVisibleHeight];
    [container addConstraint:heightConstraint];
    self.heightConstraint = heightConstraint;

    NSLayoutConstraint *errorBottomConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:container
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f
                                                                              constant:0.0f];
    [container addConstraint:errorBottomConstraint];
    self.bottomAnimationConstraint = errorBottomConstraint;
    
    NSLayoutConstraint *leftSpaceConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view.superview
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self.view.superview addConstraint:leftSpaceConstraint];
    
    NSLayoutConstraint *rightSpaceConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view.superview
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:-0.0f];
    [self.view.superview addConstraint:rightSpaceConstraint];

    self.view.alpha = 0.0f;
    [self.view setNeedsLayout];
    
}

- (void)updateViewForDisplay:(BOOL)visible completion:(void (^)(BOOL finished))completion
{
    if (visible) {
        CGFloat updatedHeight = [self updatedHeight];
        self.bottomAnimationConstraint.constant = updatedHeight - kRZErrorMessagingViewVerticalPadding;
        self.heightConstraint.constant = updatedHeight;
        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.65f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view.superview layoutIfNeeded];
            self.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (completion != nil) {
                completion(finished);
            }
        }];
    }
    else {
        self.bottomAnimationConstraint.constant = 0.0f;
        [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.65f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view.superview layoutIfNeeded];
            self.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (completion != nil) {
                completion(finished);
            }
        }];
    }
}

#pragma mark - Private Methods

- (CGFloat)updatedHeight
{
    return [self updatedHeightWithWidth:(self.view.frame.size.width - (2 * kRZErrorMessagingViewVerticalPadding))];
}

- (CGFloat)updatedHeightWithWidth:(CGFloat)width
{
    CGFloat height = kRZErrorMessagingViewVisibleHeight;
    height += [self.detailLabel.text rz_sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].height;
    return height;
}

@end
