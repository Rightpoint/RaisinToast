//
//  NSError+RZMutablility.m
//  RaisinToast
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
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
