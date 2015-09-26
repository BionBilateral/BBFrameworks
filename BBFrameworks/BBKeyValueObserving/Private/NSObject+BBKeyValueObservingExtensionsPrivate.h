//
//  NSObject+BBKeyValueObservingExtensionsPrivate.h
//  BBFrameworks
//
//  Created by William Towe on 9/24/15.
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

@class BBKeyValueObservingWrapper;

/**
 Private category on NSObject used to access the BBKeyValueObservingWrapper objects tied to a particular object. Also used to add and remove BBKeyValueObservingWrapper objects in a thread safe manner.
 */
@interface NSObject (BBKeyValueObservingExtensionsPrivate)

/**
 Get the set of wrappers attached to self. You should not add and remove objects from this set directly, instead use the methods below.
 */
@property (readonly,nonatomic) NSMutableSet *BB_keyValueObservingWrappers;

/**
 Add the wrapper to the set of wrappers associated with self.
 
 @param wrapper The wrapper to add
 */
- (void)BB_addKeyValueObservingWrapper:(BBKeyValueObservingWrapper *)wrapper;
/**
 Remove the wrapper from the set of wrappers associated with self.
 
 @param wrapper The wrapper to remove
 */
- (void)BB_removeKeyValueObservingWrapper:(BBKeyValueObservingWrapper *)wrapper;

@end

NS_ASSUME_NONNULL_END
