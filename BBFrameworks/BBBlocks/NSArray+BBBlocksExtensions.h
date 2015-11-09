//
//  NSArray+BBBlocksExtensions.h
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
 Category on NSArray adding block extensions.
 */
@interface NSArray (BBBlocksExtensions)

/**
 Invokes block once for each object in the receiver.
 
 @param block The block to invoke
 @exception NSException Thrown if block is nil
 */
- (void)BB_each:(void(^)(id object, NSInteger index))block;
/**
 Create and return a new array by enumerating the receiver, invoking block for each object, and including it in the new array if block returns YES.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 @exception NSException Thrown if block is nil
 */
- (NSArray *)BB_filter:(BOOL(^)(id object, NSInteger index))block;
/**
 Create and return a new array by enumerating the receiver, invoking block for each object, and including it in the new array if block returns NO.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 @exception NSException Thrown if block is nil
 */
- (NSArray *)BB_reject:(BOOL(^)(id object, NSInteger index))block;
/**
 Return the first object in the receiver for which block returns YES, or nil if block returns NO for all objects in the receiver.
 
 @param block The block to invoke for each object in the receiver
 @return The matching object or nil
 @exception NSException Thrown if block is nil
 */
- (nullable id)BB_find:(BOOL(^)(id object, NSInteger index))block;
/**
 Return an array of the first object in the receiver along with its index for which block returns YES, or nil if block returns NO for all objects in the receiver.
 
 @param block The block to invoke for each object in the receiver
 @return An array where the first object is an object in the receiver and second object is the index of the object in the receiver, or nil
 @exception NSException Thrown if block is nil
 */
- (nullable NSArray *)BB_findWithIndex:(BOOL(^)(id object, NSInteger index))block;
/**
 Create and return a new array by enumerating the receiver, invoking block for each object, and including the return value of block in the new array.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 */
- (NSArray *)BB_map:(id _Nullable(^)(id object, NSInteger index))block;
/**
 Return a new object that is the result of enumerating the receiver and invoking block, passing the current sum, the object, and the index of object in the receiver. The return value of block is passed in as sum to the next invocation of block.
 
 @param start The starting value for the reduction
 @param block The block to invoke for each object in the receiver
 @return The result of the reduction
 @exception NSException Thrown if block is nil
 */
- (nullable id)BB_reduceWithStart:(nullable id)start block:(id(^)(id _Nullable sum, id object, NSInteger index))block;
/**
 Return a new array that is a result of flattening the objects in the receiver, which should all be arrays.
 
 @return The flattened array
 @exception NSException Thrown if the receiver contains non-array objects
 */
- (NSArray *)BB_flatten;
/**
 Returns the result of calling `[[self BB_flatten] BB_map:block]`.
 
 @param block The block to map over the flattened array returned by BB_flatten
 @return The flattened mapped array
 @exception NSException Thrown if block is nil
 */
- (NSArray *)BB_flattenMap:(id _Nullable(^)(id object, NSInteger index))block;
/**
 Return YES if block returns YES for any object in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for any object, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)BB_any:(BOOL(^)(id object, NSInteger index))block;
/**
 Return YES if block returns YES for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for all objects, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)BB_all:(BOOL(^)(id object, NSInteger index))block;
/**
 Returns YES if block returns NO for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for all objects in the receiver
 @return YES if block returns NO for all objects, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)BB_none:(BOOL(^)(id object, NSInteger index))block;
/**
 Returns a new array created by taking the first count objects in the receiver. If count > self.count, returns self.
 
 @param count The number of objects to take from the beginning of the receiver
 @return The new array
 */
- (NSArray *)BB_take:(NSInteger)count;
/**
 Returns the largest prefix of the receiver for which block returns YES. Returns the current prefix after block returns NO for a single object.
 
 @param block The block to invoke for each object in the receiver
 @return The prefix array
 @exception NSException Thrown if block is nil
 */
- (NSArray *)BB_takeWhile:(BOOL(^)(id object, NSInteger index))block;
/**
 Returns a new array created by taking the remaining objects after dropping count objects from the beginning of the receiver. If count > self.count, returns an empty array.
 
 @param count The number of objects to drop from the beginning of the receiver
 @return The suffix array
 */
- (NSArray *)BB_drop:(NSInteger)count;
/**
 Returns the remainder of the receiver after block returns NO for an object in the receiver. If block returns YES for all objects in the receiver, returns an empty array.
 
 @param block The block to invoke for each object in the receiver
 @return The suffix array
 @exception NSException Thrown if block is nil
 */
- (NSArray *)BB_dropWhile:(BOOL(^)(id object, NSInteger index))block;
/**
 Returns a new array created by taking pairs of objects from the receiver and array. If either array has more objects than the other, the extra objects are not included in the return value.
 
 For example, `[@[@1,@2] BB_zip:@[@3,@4]]` -> `@[@[@1,@3],@[@2,@4]]`.
 
 @param array The array to zip with
 @return The new array
 @exception NSException Thrown if array is nil
 */
- (NSArray *)BB_zip:(NSArray *)array;
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
