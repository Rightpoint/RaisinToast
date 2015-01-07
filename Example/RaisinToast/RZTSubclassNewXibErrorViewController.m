//
//  RZTSubclassNewXibErrorViewController.m
//  RaisinToast
//
//  Created by Adam Howitt on 1/7/15.
//  Copyright (c) 2015 adamhrz. All rights reserved.
//

#import "RZTSubclassNewXibErrorViewController.h"

@implementation RZTSubclassNewXibErrorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RZTSubclassNewXibErrorViewController" bundle:nibBundleOrNil];
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
