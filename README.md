# RaisinToast

[![CI Status](http://img.shields.io/travis/adamhrz/RaisinToast.svg?style=flat)](https://travis-ci.org/adamhrz/RaisinToast)
[![Version](https://img.shields.io/cocoapods/v/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![License](https://img.shields.io/cocoapods/l/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![Platform](https://img.shields.io/cocoapods/p/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)

RaisinToast provides a messaging window layer and a default "toast" view controller, ideal for presenting errors, warnings and feedback throughout your app.

Insert GIF here of demo project in action

## Installation

RaisinToast is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RaisinToast"


## Demo Project

A demo project is available in the Example directory. The demo project uses CocoaPods, and can be opened from a temporary directory by running

    pod try RaisinToast

Alternatively, the demo can be configured by running the following commands from the root project directory.

    cd Example
    pod install

Then, open `RaisinToast.xcworkspace` and check out the demo!

Note: The above steps assume that the CocoaPods gem is installed.

If you do not have CocoaPods installed, follow the instructions [here](http://cocoapods.org/).

## Overview
### Out of the box configuration

In app delegate add to imports:

```objc
@class RZMessagingWindow;
```

Add new property:

```objc
@property (strong, nonatomic) RZMessagingWindow *errorWindow;
```

In implementation add private method:

```objc
- (void)setupMessagingWindow
{
    self.errorWindow = [RZMessagingWindow defaultMessagingWindow];

    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
}
```

### Style override

Subclass RZErrorMessagingViewController 

```objc
@interface MyErrorMessagingViewController : RZErrorMessagingViewController <RZMessagingViewController>
```

Override init and provide an alternative color definition for each level of error

```objc
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

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
```

In app delegate use your custom class

```objc
self.errorWindow = [RZMessagingWindow messagingWindow];
self.errorWindow.messageViewControllerClass = [MyErrorMessagingViewController class];	
```

### Custom View Controller 
Implement protocol RZMessagingViewController

```objc
- (void)rz_configureWithError:(NSError *)error;
- (void)rz_presentAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;
- (void)rz_dismissAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;
```

## Author

adamhrz, adam.howitt@raizlabs.com

## License

RaisinToast is available under the MIT license. See the LICENSE file for more info.