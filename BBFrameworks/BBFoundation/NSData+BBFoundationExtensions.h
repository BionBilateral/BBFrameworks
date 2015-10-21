//
//  NSData+BBFoundationExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 5/15/15.
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
 Category on NSData adding various convenience methods.
 */
@interface NSData (BBFoundationExtensions)

/**
 Creates and returns an NSString representing the MD5 hash of the receiver's bytes.
 
 @return The NSString hash
 */
- (NSString *)BB_MD5String;
/**
 Creates and returns an NSString representing the SHA1 hash of the receiver's bytes.
 
 @return The NSString hash
 */
- (NSString *)BB_SHA1String;
/**
 Creates and returns an NSString representing the SHA256 hash of the receiver's bytes.
 
 @return The NSString hash
 */
- (NSString *)BB_SHA256String;
/**
 Creates and returns an NSString representing the SHA512 hash of the receiver's bytes.
 
 @return The NSString hash
 */
- (NSString *)BB_SHA512String;

@end

NS_ASSUME_NONNULL_END