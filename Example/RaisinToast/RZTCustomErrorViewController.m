//
//  RZTCustomErrorViewController.m
//  RaisinToast
//
//  Created by Adam Howitt on 1/7/15.
//  Copyright (c) 2015 adamhrz. All rights reserved.
//

#import "RZTCustomErrorViewController.h"

@interface RZTCustomErrorViewController ()
@property (weak, nonatomic) NSError *error;
@property (strong, nonatomic) UIAlertController *alertViewController;
@property (weak, nonatomic) NSLayoutConstraint *bottomAnimationConstraint;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@end

@implementation RZTCustomErrorViewController

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.view.alpha = 0.5f;
    }
    return self;
}

#pragma RZMessagingViewController
- (void)rz_configureWithError:(NSError *)error
{
    self.error = error;
    self.alertViewController = [UIAlertController alertControllerWithTitle:self.error.localizedDescription message:self.error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [self.alertViewController addAction:defaultAction];
}

- (void)rz_presentAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion
{
    self.view.hidden = NO;
    [self presentViewController:self.alertViewController animated:YES completion:nil];

    if ( completion != nil ) {
        completion(YES);
    }
}

- (void)rz_dismissAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion
{
    [self dismissViewControllerAnimated:animated completion:nil];

    self.bottomAnimationConstraint.constant = 0.0f;
    self.view.alpha = 0.0f;
    self.view.hidden = YES;
    if ( completion != nil ) {
        completion(YES);
    }

}

- (void)rz_configureLayoutForContainer:(UIView *)container
{
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    // Setup all the needed constraints for the view.
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:CGRectGetHeight(self.view.bounds)];
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

@end
