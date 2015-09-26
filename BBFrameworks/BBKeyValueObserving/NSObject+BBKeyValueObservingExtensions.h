//
//  NSObject+BBKeyValueObservingExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 9/23/15.
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
#import "BBKeyValueObservingDefines.h"
#import "BBKeyValueObservingToken.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Category on NSObject adding block based KVO methods. The object returned from each of these methods can be used to stop observing early. If the observing is not stopped beforehand, it will stop upon deallocation of self.
 */
@interface NSObject (BBKeyValueObservingExtensions)

/**
 Calls `[self BB_addObserverForKeyPaths:options:block:]`, passing @[keyPath], options, and block respectively.
 
 @param keyPath The key path to observe on self
 @param options The KVO options to use when setting up the observation
 @param block The block to invoke on each KVO change
 @return An object that can be used to stop observing early
 @exception NSException Thrown if keyPath or block are nil
 @see BBKeyValueObservingBlock
 */
- (id<BBKeyValueObservingToken>)BB_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(BBKeyValueObservingBlock)block;
/**
 Starts observing self for changes on the provided key paths.
 
 @param keyPaths A collection of key paths to observe on self
 @param options The KVO options to use when setting up the observation
 @param block The block to invoke on each KVO change
 @return An object that can be used to stop observing early
 @exception NSException Thrown if keyPath or block are nil
 @see BBKeyValueObservingBlock
 */
- (id<BBKeyValueObservingToken>)BB_addObserverForKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options block:(BBKeyValueObservingBlock)block;

@end

NS_ASSUME_NONNULL_END
