# RaisinToast: A Custom Alert View for iOS

[![Version](https://img.shields.io/cocoapods/v/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![License](https://img.shields.io/cocoapods/l/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![Platform](https://img.shields.io/cocoapods/p/RaisinToast.svg?style=flat)](http://cocoadocs.org/docsets/RaisinToast)
[![Analytics](https://ga-beacon.appspot.com/UA-67114-4/RaisinToast/readme)](https://github.com/igrigorik/ga-beacon)


RaisinToast provides a messaging window layer and a default "toast" view controller, ideal for presenting errors, warnings and feedback throughout your app. Think of it as bringing the really useful messaging concept of Android Toast to iOS.

RaisinToast is simple to configure and minimizes the amount of notification code you have to add to your app to get consistent app-wide messaging.  

After the initial setup if you want to customize the style of your messaging you don't have to touch any of the View Controllers where you present messages - just point the app delegate to your new RZErrorMessagingViewController subclass and the whole app gets a facelift.

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

## Basic Overview
### Configuration

In app delegate add to imports:

```objc
@class RZMessagingWindow;
```

Add new property:

```objc
@property (strong, nonatomic) RZMessagingWindow *errorWindow;
```

In implementation add the setup code to `applicationDidBecomeActive:`:


```objc
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if ( self.errorWindow == nil ) {
        self.errorWindow = [RZMessagingWindow messagingWindow];
        [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    }
}
```

### Presenting a notification

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

To use message strength use the convenience method errorWithDisplayTitle:detail:error to create an NSError configured for RZErrorMessenger:

```objc 
NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:@"World's strongest error" detail:@"Coming to an iPhone near you soon." error:nil];
```

Here we pass nil as the error object but if you're actually responding to a real NSError you can use that object to pull out the error domain and pass that through to help with debugging.

Next we present the error and provide the message strength with displayError:withStrength:animated:

```objc 
[RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss animated:YES];
```

You could, though we advise against it, use Raisin Toast to present standard NSError objects. This might be helpful during debugging but typically you wouldn't want to show the user any of the system generated errors because they're intended for devs.

## Advanced Options
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

In the app delegate use your custom class

```objc
self.errorWindow = [RZMessagingWindow messagingWindow];
self.errorWindow.messageViewControllerClass = [MyErrorMessagingViewController class];	
```

### Custom View Controller 
Declare support for the protocol RZMessagingViewController in your header file:

```objc
@interface MyAmazingMessagingViewController : UIViewController <RZMessagingViewController>
```

Implement the required methods in your implementation file:

```objc
- (void)rz_configureWithError:(NSError *)error;
- (void)rz_presentAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;
- (void)rz_dismissAnimated:(BOOL)animated completion:(RZMessagingWindowAnimationCompletionBlock)completion;
```

Optionally provide constraints for the error messaging view controller to control the positioning or appearance/disappearance:

```objc 
- (void)rz_configureLayoutForContainer:(UIView *)container;
```

In the app delegate use your custom class

```objc
self.errorWindow = [RZMessagingWindow messagingWindow];
self.errorWindow.messageViewControllerClass = [MyAmazingMessagingViewController class];	
```

### Multiple messaging styles

In the sample project you'll notice we seamlessly switch between the default setup, a custom color scheme and a funky version that turns all your messaging attempts into a UIAlertView. This was done to show you the flexibility of Raisin Toast. 

Without having to update a single view controller providing the meat of your app you can set the messageViewControllerClass property of the defaultMessagingWindow and the messaging gets a facelift. Feel free to use the subclasses provided in the sample project in your own apps.

If you want to use more than one style, maybe different themes based on the section of your app or a style of presenting view controller you would set the messageViewControllerClass of the messagingWindow before you make the call to display the error:

```objc 
[[RZMessagingWindow messagingWindow] setMessageViewControllerClass:[RZAmityvilleErrorMessagingViewController class]];
[RZErrorMessenger displayErrorWithTitle:@"Gross!" detail:@"Flies everywhere!" level:kRZErrorMessengerLevelError];
```

## Full Documentation

For more comprehensive documentation, see the [CococaDocs](http://cocoadocs.org/docsets/RaisinToast) page.

## Author

adamhrz, adam.howitt@raizlabs.com, [@earnshavian](https://twitter.com/earnshavian)

## Contributors

arrouse, alex@raizlabs.com, [@arrouse](https://twitter.com/arrouse)

## License

RaisinToast is available under the MIT license. See the LICENSE file for more info.
