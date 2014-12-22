//
//  NSError+RZMutablility.h
//  bhphoto
//
//  Created by alex.rouse on 8/12/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import Foundation;

@interface NSError (RZMutablility)

/**
 *  Returns a new NSError object with the correct domain and code.
 */
+ (instancetype)bh_error;

/**
 *  Returns a new NSError object with the localized description updated to the new text
 *
 *  @param localizedDescription new localized description
 *
 *  @return update NSError object
 */
- (NSError *)bh_updateLocalizedDescription:(NSString *)localizedDescription;

/**
 *  Returns a new NSError object with the localized Recovery Suggestion updated to the new text
 *
 *  @param localizedRecoverySuggestion new localized recovery suggestion.
 *
 *  @return updated NSError object.
 */
- (NSError *)bh_updateLocalizedRecoverySuggestion:(NSString *)localizedRecoverySuggestion;

/**
 *  Returns a new NSError object with the localized failure reason updated to the new text
 *
 *  @param localizedFailureReason new localized failure reason.
 *
 *  @return updated NSError object.
 */
- (NSError *)bh_updateLocalizedFailureReason:(NSString *)localizedFailureReason;

@end
