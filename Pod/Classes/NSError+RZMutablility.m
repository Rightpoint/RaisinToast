//
//  NSError+RZMutablility.m
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
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

#import "NSError+RZMutablility.h"

static NSString *kRZMessagingWindowDefaultWarningDomain = @"com.raizlabs.warning";

@implementation NSError (RZMutablility)

+ (instancetype)rz_error
{
    return [NSError errorWithDomain:kRZMessagingWindowDefaultWarningDomain code:999 userInfo:@{}];
}

- (NSError *)rz_updateLocalizedDescription:(NSString *)localizedDescription
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedDescription != nil ) {
        userInfo[NSLocalizedDescriptionKey] = localizedDescription;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (NSError *)rz_updateLocalizedRecoverySuggestion:(NSString *)localizedRecoverySuggestion
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedRecoverySuggestion != nil ) {
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = localizedRecoverySuggestion;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (NSError *)rz_updateLocalizedFailureReason:(NSString *)localizedFailureReason
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedFailureReason != nil ) {
        userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

@end
