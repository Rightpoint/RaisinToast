//
//  RZErrorMessenger.m
//  RaisinToast
//
//  Created by alex.rouse on 8/11/14.
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

#import "RZErrorMessenger.h"

#import "RZMessagingWindow.h"

#import "NSError+RZMutablility.h"

static RZMessagingWindow *kRZMessagingWindowDefaultMessagingWindow = nil;
static NSString *kRZMessagingWindowDefaultErrorDomain = @"com.raizlabs.error";
static NSString *kRZDefaultErrorMessageNoNetwork      = @"You are not connected to the internet. Please fix your connection and try again.";

@implementation RZErrorMessenger

#pragma mark - Displaying Errors
+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [self displayErrorWithTitle:title details:[NSArray arrayWithObjects:detail, nil]];
}

+ (NSError *)displayErrorWithTitle:(NSString *)title details:(NSArray *)details
{
    NSMutableString *errorString = [NSMutableString string];
    
    [details enumerateObjectsUsingBlock:^(NSString *detail, NSUInteger idx, BOOL *stop) {
        [errorString appendString:detail];
        
        if ( idx < [details count] - 1 ) {
            [errorString appendString:@"\n"];
        }
    }];
    
    return [self displayErrorWithTitle:title detail:[errorString copy] level:kRZErrorMessengerLevelError];
}

+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail level:(RZErrorMessengerLevel)level
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ( title != nil ) {
        dict[NSLocalizedDescriptionKey] = title;
    }
    
    if ( detail != nil ) {
        dict[NSLocalizedRecoverySuggestionErrorKey] = detail;
    }
    
    NSError *error = [NSError errorWithDomain:[RZErrorMessenger getDefaultErrorDomain] code:999 userInfo:dict];
    
    return [self displayError:error withStrength:kRZMessageStrengthWeak level:level animated:YES];
}

+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail error:(NSError *)error
{
    NSError *newError = [self errorWithDisplayTitle:title detail:detail error:error];
    return [self displayError:newError];
}

+ (NSError *)displayError:(NSError *)error
{
    return [self displayError:error withStrength:kRZMessageStrengthWeak animated:YES];
}

+ (NSError *)displayError:(NSError *)error withStrength:(RZMessageStrength)strength animated:(BOOL)animated
{
    return [self displayError:error withStrength:strength level:kRZErrorMessengerLevelError animated:animated];
}

+ (NSError *)displayError:(NSError *)error withStrength:(RZMessageStrength)strength level:(RZErrorMessengerLevel)level animated:(BOOL)animated
{
    NSAssert([RZErrorMessenger getDefaultMessagingWindow] != nil, @"You must call setDefaultMessagingWindow with a valid RZMessagingWindow to display an error, typically in your app delegate when you configure the RZMessagingWindow view creation, configuration, preesntation and dismissal blocks.");
    error = [error rz_updateLevelOnErrorWithLevel:level];
    [[RZErrorMessenger getDefaultMessagingWindow] showMessageFromError:error strength:strength animated:animated];
    return error;
}

#pragma mark - Hiding errors

+ (void)hideErrorAnimated:(BOOL)animated
{
    [self hideError:nil animated:animated];
}

+ (void)hideError:(NSError *)error animated:(BOOL)animated
{
    [[RZErrorMessenger getDefaultMessagingWindow] hideMessage:error animated:animated];
}

+ (void)hideAllErrors
{
    [[RZErrorMessenger getDefaultMessagingWindow] hideAllMessagesAnimated:YES];
}

#pragma mark - Helpers

+ (NSError *)errorWithDisplayTitle:(NSString *)title detail:(NSString *)detail error:(NSError *)error
{
    if ( error == nil ) {
        error = [NSError errorWithDomain:[RZErrorMessenger getDefaultErrorDomain] code:999 userInfo:nil];
    }

    error = [error rz_updateLocalizedRecoverySuggestion:detail];
    error = [error rz_updateLocalizedDescription:title];
    return error;
}

+ (BOOL)isErrorCurrentlyDisplayed
{
    return  [[RZErrorMessenger getDefaultMessagingWindow] isCurrentlyDisplayingAnError];
}

+ (RZMessageStrength)strengthOfDisplayedError
{
    return [[RZErrorMessenger getDefaultMessagingWindow] strengthOfDisplayedError];
}


#pragma mark - Private Methods

+ (NSString *)getDefaultErrorDomain
{
    return kRZMessagingWindowDefaultErrorDomain;
}

+ (void)setDefaultErrorDomain:(NSString *)errorDomain
{
    kRZMessagingWindowDefaultErrorDomain = [errorDomain copy];
}

+ (RZMessagingWindow *)getDefaultMessagingWindow
{
    return kRZMessagingWindowDefaultMessagingWindow;
}

+ (void)setDefaultMessagingWindow:(RZMessagingWindow *)errorWindow
{
    kRZMessagingWindowDefaultMessagingWindow = errorWindow;
}

@end

static NSString * const kRZErrorMessengerErrorKeyLevel = @"RZErrorMessengerErrorKeyLevel";

@implementation NSError (RZErrorMessenger)

- (NSError *)rz_updateLevelOnErrorWithLevel:(RZErrorMessengerLevel)level
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    userInfo[kRZErrorMessengerErrorKeyLevel] = @(level);
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (RZErrorMessengerLevel)rz_levelFromError
{
    RZErrorMessengerLevel level = kRZErrorMessengerLevelError;
    NSNumber *errorValue = self.userInfo[kRZErrorMessengerErrorKeyLevel];
    if ( errorValue != nil ) {
        level = [errorValue integerValue];
    }
    return level;
}

@end
