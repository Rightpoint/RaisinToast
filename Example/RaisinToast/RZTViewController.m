//
//  RZViewController.m
//  RaisinToast
//
//  Created by adamhrz on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import "RZTViewController.h"

@interface RZTViewController ()

@end

@implementation RZTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [RZErrorMessenger displayErrorWithTitle:@"First test" detail:@"This should present a default title"];
    NSError *myError = [RZErrorMessenger errorWithDisplayTitle:@"Adam" detail:@"Knows nothing" error:nil];
    [RZErrorMessenger displayError:myError withStrength:kRZMessageStrengthWeakAutoDismiss animated:YES];
    [RZErrorMessenger displayError:myError withStrength:kRZMessageStrengthWeakAutoDismiss animated:YES];
    [RZErrorMessenger displayError:myError withStrength:kRZMessageStrengthWeakAutoDismiss animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [RZErrorMessenger hideErrorAnimated:YES];
//        [RZErrorMessenger hideAllErrors];
//    });

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
