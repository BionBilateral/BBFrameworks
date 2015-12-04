//
//  BBNetworkActivityIndicatorManager.h
//  BBFrameworks
//
//  Created by William Towe on 12/4/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
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
 BBNetworkActivityIndicatorManager is a NSObject subclass that manages the display of the network activity indicator.
 */
@interface BBNetworkActivityIndicatorManager : NSObject

/**
 Set and get whether the receiver is enabled. If YES, calls to `incrementActivityCount`, `decrementActivityCount`, and `resetActivityCount` will show/hide the network activity indicator as necessary.
 
 The default is NO.
 */
@property (assign,nonatomic,getter=isEnabled) BOOL enabled;
/**
 Get whether the network activity indicator is visible.
 */
@property (readonly,nonatomic,getter=isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;

/**
 Returns the shared manager instance.
 
 @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 Increments the internal activity count and changes the visibility of the network activity indicator to match. This method is thread safe.
 */
- (void)incrementActivityCount;
/**
 Decrements the internal activity count and changes the visibility of the network activity indicator to match. This method is thread safe.
 */
- (void)decrementActivityCount;
/**
 Resets the internal activity count to 0 and hides the network activity indicator.
 */
- (void)resetActivityCount;

@end

NS_ASSUME_NONNULL_END
