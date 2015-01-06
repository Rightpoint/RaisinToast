//
//  RZTCustomViewController.m
//  
//
//  Created by Adam Howitt on 1/6/15.
//
//

#import "RZTCustomViewController.h"

@implementation RZTCustomViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RZErrorMessagingViewController" bundle:nibBundleOrNil];
    if ( self ) {
        self.colorForLevelDictionary = @{
                                         kRZLevelError :[UIColor redColor],
                                         kRZLevelInfo : [UIColor blueColor],
                                         kRZLevelWarning : [UIColor orangeColor],
                                         kRZLevelPositive : [UIColor greenColor]
                                         };
        self.errorMessagingViewVerticalPadding = -200.0f;
    }
    return self;
}

@end
