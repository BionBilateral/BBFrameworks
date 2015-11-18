//
//  NSSet+BBBlocksExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 7/22/15.
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
 Category on NSSet adding block extensions.
 */
@interface NSSet<__covariant ObjectType> (BBBlocksExtensions)

/**
 Invokes block once for each object in the receiver.
 
 @param block The block to invoke
 @exception NSException Thrown if block is nil
 */
- (void)BB_each:(void(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including it in the new set if block returns YES.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet<ObjectType> *)BB_filter:(BOOL(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including it in the new set if block returns NO.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet<ObjectType> *)BB_reject:(BOOL(^)(ObjectType object))block;
/**
 Return the first object in the receiver for which block returns YES, otherwise return nil.
 
 @param block The block to invoke for each object in the receiver
 @return The matching object or nil
 @exception NSException Thrown if block is nil
 */
- (nullable ObjectType)BB_find:(BOOL(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including the return value of block in the new set.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet *)BB_map:(id _Nullable(^)(ObjectType object))block;
/**
 Return a new object that is the result of enumerating the receiver and invoking block, passing the current sum and the object. The return value of block is passed in as sum to the next invocation of block.
 
 @param start The starting value for the reduction
 @param block The block to invoke for each object in the receiver
 @return The result of the reduction
 @exception NSException Thrown if block is nil
 */
- (nullable id)BB_reduceWithStart:(nullable id)start block:(id(^)(id _Nullable sum, ObjectType object))block;
/**
 Return a new set which is the result of unioning all the objects in the receiver, which should be sets.
 
 @return The flattened set
 @exception NSException Thrown if the receiver contains any non-set objects
 */
- (NSSet<ObjectType> *)BB_flatten;
/**
 Returns the result of calling `[[self BB_flatten] BB_map:block]`.
 
 @param block The block to map over the flattened set returned by BB_flatten
 @return The flattened mapped set
 @exception NSException Thrown if block is nil
 */
- (NSSet *)BB_flattenMap:(id _Nullable(^)(id object))block;
/**
 Return YES if block returns YES for any object in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for any object, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)BB_any:(BOOL(^)(ObjectType object))block;
/**
 Return YES if block returns YES for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)BB_all:(BOOL(^)(ObjectType object))block;
/**
 Return YES if block returns NO for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns NO for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)BB_none:(BOOL(^)(ObjectType object))block;
/**
 Returns the sum of the objects in the receiver, which should be NSNumber instances, as an NSNumber.
 
 @return The sum
 */
- (id)BB_sum;
/**
 Returns the product of the objects in the receiver, which should be NSNumber instances, as an NSNumber.
 
 @return The product
 */
- (id)BB_product;
/**
 Returns the maximum value of the objects in the receiver, which should all respond to the `compare:` method.
 
 @return The maximum value
 */
- (id)BB_maximum;
/**
 Returns the minimum value of the objects in the receiver, which should all respond to the `compare`: method.
 
 @return The minimum value
 */
- (id)BB_minimum;

@end

NS_ASSUME_NONNULL_END
