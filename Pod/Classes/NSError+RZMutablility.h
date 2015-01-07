//
//  NSError+RZMutablility.h
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

@import Foundation;

@interface NSError (RZMutablility)

/**
 *  Returns a new NSError object with the correct domain and code.
 */
+ (instancetype)rz_error;

/**
 *  Returns a new NSError object with the localized description updated to the new text
 *
 *  @param localizedDescription new localized description
 *
 *  @return update NSError object
 */
- (NSError *)rz_updateLocalizedDescription:(NSString *)localizedDescription;

/**
 *  Returns a new NSError object with the localized Recovery Suggestion updated to the new text
 *
 *  @param localizedRecoverySuggestion new localized recovery suggestion.
 *
 *  @return updated NSError object.
 */
- (NSError *)rz_updateLocalizedRecoverySuggestion:(NSString *)localizedRecoverySuggestion;

/**
 *  Returns a new NSError object with the localized failure reason updated to the new text
 *
 *  @param localizedFailureReason new localized failure reason.
 *
 *  @return updated NSError object.
 */
- (NSError *)rz_updateLocalizedFailureReason:(NSString *)localizedFailureReason;

@end
