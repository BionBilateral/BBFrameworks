//
//  NSError+BBExtensions.h
//  BBFrameworks
//
//  Created by Jason Anderson on 7/3/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The key used to identify the alert title.
 */
extern NSString *const BBErrorAlertTitleKey;
/**
 The key used to identify the alert message.
 */
extern NSString *const BBErrorAlertMessageKey;

/**
 Category on NSError adding convenience methods to get the alert title and message using the above keys.
 */
@interface NSError (BBFoundationExtensions)

/**
 Returns the value for the BBErrorAlertTitleKey key in the receiver's userInfo dictionary if non-nil, otherwise returns a default title.
 
 @return The alert title
 */
- (NSString *)BB_alertTitle;
/**
 Returns the value for the BBErrorAlertMessageKey key in the receiver's userInfo dictionary if non-nil, then the value for the NSLocalizedDescriptionKey key, then a default title.
 
 @return The alert message
 */
- (NSString *)BB_alertMessage;

@end

NS_ASSUME_NONNULL_END