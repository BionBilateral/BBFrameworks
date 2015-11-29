//
//  NSDictionary+BBFoundationExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 11/28/15.
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
 Category on NSDictionary adding various convenience methods.
 */
@interface NSDictionary<KeyType, ObjectType> (BBFoundationExtensions)

/**
 Returns an array containing all the keys in the receiver.
 
 @return The array containing keys
 */
- (NSArray<KeyType> *)BB_keyArray;
/**
 Returns an array containing all the values in the receiver.
 
 @return The array containing values
 */
- (NSArray<ObjectType> *)BB_valueArray;
/**
 Returns a set containing all the keys in the receiver.
 
 @return The set containing keys
 */
- (NSSet<KeyType> *)BB_keySet;
/**
 Returns a set containing all the values in the receiver.
 
 @return The set containing values
 */
- (NSSet<ObjectType> *)BB_valueSet;

@end

NS_ASSUME_NONNULL_END
