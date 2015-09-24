//
//  BBKeyValueObservingController.h
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

/**
 BBKeyValueObservingController is a singleton instance that all KVO block observing methods funnel through.
 */
@interface BBKeyValueObservingController : NSObject

/**
 Get the shared instance.
 */
+ (instancetype)sharedInstance;

/**
 Add a key value observer to target for the keyPaths with options using block.
 
 @param observer The observer to add, can be nil
 @param target The target to observe, cannot be nil
 @param keyPaths The collection of keyPaths to observe, cannot be nil
 @param options The KVO options to use
 @param block The block that is invoked on each KVO change
 @return An object that can be used to stop observing the target
 @exception NSException Thrown if observer and target are nil, if keyPaths or block are nil
 @see BBKeyValueObservingBlock
 */
- (id<BBKeyValueObservingToken>)addKeyValueObserver:(id)observer target:(id)target forKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options block:(BBKeyValueObservingBlock)block;

@end
