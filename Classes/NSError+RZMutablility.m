//
//  NSError+RZMutablility.m
//  bhphoto
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSError+RZMutablility.h"

@implementation NSError (RZMutablility)

+ (instancetype)bh_error
{
    return [NSError errorWithDomain:@"com.bhphotovideo.warning" code:999 userInfo:@{}];
}

- (NSError *)bh_updateLocalizedDescription:(NSString *)localizedDescription
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedDescription != nil ) {
        userInfo[NSLocalizedDescriptionKey] = localizedDescription;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (NSError *)bh_updateLocalizedRecoverySuggestion:(NSString *)localizedRecoverySuggestion
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedRecoverySuggestion != nil ) {
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = localizedRecoverySuggestion;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

- (NSError *)bh_updateLocalizedFailureReason:(NSString *)localizedFailureReason
{
    NSMutableDictionary *userInfo = [self.userInfo mutableCopy];
    if ( localizedFailureReason != nil ) {
        userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    }
    return [NSError errorWithDomain:self.domain code:self.code userInfo:userInfo];
}

@end
