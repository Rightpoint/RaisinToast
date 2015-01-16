# RaisinToast

[![CI Status](http://img.shields.io/travis/adamhrz/RaisinToast.svg?style=flat)](https://travis-ci.org/adamhrz/RaisinToast)
[![Version](https://img.shields.io/cocoapods/v/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![License](https://img.shields.io/cocoapods/l/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![Platform](https://img.shields.io/cocoapods/p/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)

RaisinToast provides a messaging window layer and a default "toast" view controller, ideal for presenting errors, warnings and feedback throughout your app.

![RaisinToast in action](https://github.com/Raizlabs/RaisinToast/blob/master/Example/raisin-toast-6plus.gif "RaisinToast Demo Project")

## Installation

RaisinToast is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RaisinToast"

If you're not using CocoaPods copy the Classes/ and Assets/ folders into your project and follow the instructions under [overview](#overview).

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

In implementation add private method to create the default messaging window and provide an error domain for the messages based on the bundle ID:

```objc
- (void)setupMessagingWindow
{
    self.errorWindow = [RZMessagingWindow defaultMessagingWindow];

    [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    [RZErrorMessenger setDefaultErrorDomain:[NSString stringWithFormat:@"%@.error",[[NSBundle mainBundle] bundleIdentifier]]];
}
```

Call this method in `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`

```objc
[self setupMessagingWindow];
```

To display your first notification anywhere in your app call the RZErrorMessenger class method:

```objc
[RZErrorMessenger displayErrorWithTitle:@"FYI" detail:@"This is a test of the emergency broadcast system"];
```

This presents the default info level notification for the provided title and detail.

### Controlling the message level

`RZErrorMessengerLevel` is an enum of four notification "themes".

* kRZErrorMessengerLevelError - An error, commonly red in color.
* kRZErrorMessengerLevelWarning - A warning, commonly orange in color.
* kRZErrorMessengerLevelInfo - An informational message, commonly blue in color and the default level if not specified.
* kRZErrorMessengerLevelPositive - Positive feedback, commonly green in color.

To display a notification and specify the strength call displayErrorWithTitle:detail:level:

```objc
[RZErrorMessenger displayErrorWithTitle:@"Whoops!" detail:@"Something went horribly wrong and we accidentally cut off the wrong leg" level:kRZErrorMessengerLevelError];
[RZErrorMessenger displayErrorWithTitle:@"Hang on a second" detail:@"Did you know this was happening?" level:kRZErrorMessengerLevelWarning];
[RZErrorMessenger displayErrorWithTitle:@"FYI" detail:@"This is a test of the emergency broadcast system" level:kRZErrorMessengerLevelInfo];
[RZErrorMessenger displayErrorWithTitle:@"Great job!" detail:@"You did it! You did the thing you were supposed to do!" level:kRZErrorMessengerLevelPositive];
```

### Controlling the message strength

As you saw, message level controls the message appearance but RZMessageStrength lets you control whether the message is modal (strong) or acts lets touches pass through to the underlying UIWindow (weak).

A second component to RZMessageStrength is whether the message will auto-dismiss on tap or remains on screen for you to handle the dismissal.  Most of the time the ..AutoDismiss RZMessageStrength options will be what you want.  

The manual options are useful when you might want to perform additional processing e.g. UI edits or model updates before the message is dismissed.

Another example is if you want to present a sequence of messages and then either peel them all off one at a time or dismiss them all with a single animation block.

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

## Full Documentation

For more comprehensive documentation, see the [CococaDocs](http://cocoadocs.org/docsets/RaisinToast) page.

## Author

adamhrz, adam.howitt@raizlabs.com

## License

RaisinToast is available under the MIT license. See the LICENSE file for more info.
