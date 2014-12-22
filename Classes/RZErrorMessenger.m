//
//  RZErrorMessenger.m
//  bhphoto
//
//  Created by alex.rouse on 8/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZErrorMessenger.h"

#import "RZMessagingWindow.h"

#import "NSError+RZMutablility.h"

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
    
    return [self displayErrorWithTitle:title detail:[errorString copy] color:kRZErrorMessengerColorRed];
}

+ (NSError *)displayErrorWithTitle:(NSString *)title detail:(NSString *)detail color:(RZErrorMessengerColor)color
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ( title != nil ) {
        dict[NSLocalizedDescriptionKey] = title;
    }
    
    if ( detail != nil ) {
        dict[NSLocalizedRecoverySuggestionErrorKey] = detail;
    }
    
    NSError *error = [NSError errorWithDomain:@"com.bhphotovideo.error" code:999 userInfo:dict];
    
    return [self displayError:error withStrength:kRZMessageStrengthWeak color:color animated:YES];
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
    return [self displayError:error withStrength:strength color:kRZErrorMessengerColorRed animated:animated];
}

+ (NSError *)displayError:(NSError *)error withStrength:(RZMessageStrength)strength color:(RZErrorMessengerColor)color animated:(BOOL)animated
{
    error = [self performErrorValidationOnError:error];
    error = [error bh_updateColorOnErrorWithColor:color];
    [[[BHAppDelegate appDelegate] errorWindow] showMessageFromError:error strength:strength animated:animated];
    return error;
}

#pragma mark - Hiding errors

+ (void)hideErrorAnimated:(BOOL)animated
{
    [self hideError:nil animated:animated];
}

+ (void)hideError:(NSError *)error animated:(BOOL)animated
{
    [[[BHAppDelegate appDelegate] errorWindow] hideMessage:error animated:animated];
}

+ (void)hideAllErrors
{
    [[[BHAppDelegate appDelegate] errorWindow] hideAllMessagesAnimated:YES];
}

#pragma mark - Helpers

+ (NSError *)errorWithDisplayTitle:(NSString *)title detail:(NSString *)detail error:(NSError *)error
{
    if ( error != nil ){
        
        if ( [error.domain isEqualToString:kBHWebserviceErrorDomain] ) {
            if ( [[error.userInfo valueForKey:kBHWebserviceResponseErrorHasErrorTitle] boolValue] ) {
                NSString *errorTitle = [error localizedDescription];
                if (errorTitle != nil){
                    title = errorTitle;
                }
            }
            if ( [[error.userInfo valueForKey:kBHWebserviceResponseErrorHasErrorMessage] boolValue] ) {
                NSString *errorMessage = [error localizedRecoverySuggestion];
                if ( errorMessage != nil ){
                    detail = errorMessage;
                }
            }
        }
        else {
            switch ( error.code ) {
                case NSURLErrorNotConnectedToInternet:
                    detail = kBHDefaultErrorMessageNoNetwork;
                    break;
                    
                default:
                    break;
            }
        }
    }
    else {
        error = [NSError errorWithDomain:@"com.bhphotovideo.error" code:999 userInfo:nil];
    }

    error = [error bh_updateLocalizedRecoverySuggestion:detail];
    error = [error bh_updateLocalizedDescription:title];
    return error;
}

+ (BOOL)isErrorCurrentlyDisplayed
{
    return  [[[BHAppDelegate appDelegate] errorWindow] isCurrentlyDisplayingAnError];
}

+ (RZMessageStrength)strengthOfDisplayedError
{
    return [[[BHAppDelegate appDelegate] errorWindow] strengthOfDisplayedError];
}


#pragma mark - Private Methods

+ (NSError *)performErrorValidationOnError:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet) {
        error = [error bh_updateLocalizedRecoverySuggestion:kBHDefaultErrorMessageNoNetwork];
    }
    return error;
}

@end

static NSString * const kRZErrorMessengerErrorKeyColor = @"RZErrorMessengerErrorKeyColor";

@implementation NSError (BHErrorMessenger)

- (NSError *)bh_updateColorOnErrorWithColor:(RZErrorMessengerColor)color
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    userInfo[kRZErrorMessengerErrorKeyColor] = @(color);
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (RZErrorMessengerColor)bh_colorFromError
{
    RZErrorMessengerColor color = kRZErrorMessengerColorRed;
    NSNumber *errorValue = self.userInfo[kRZErrorMessengerErrorKeyColor];
    if (errorValue != nil) {
        color = [errorValue integerValue];
    }
    return color;
}

@end
