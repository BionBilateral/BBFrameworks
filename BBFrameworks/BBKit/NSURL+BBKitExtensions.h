//
//  NSURL+BBKitExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 5/13/15.
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

#if (TARGET_OS_IPHONE)
#import <UIKit/UIImage.h>
#else
#import <AppKit/NSImage.h>
#endif

/**
 Category providing access to NSURL resource values through convenient methods.
 */
@interface NSURL (BBKitExtensions)

/**
 Returns the value associated with the NSURLCreationDateKey key.
 
 @return The associated creation date
 */
- (NSDate *)BB_creationDate;
/**
 Returns the value associated with the NSURLContentModificationDateKey key.
 
 @return The associated content modification date
 */
- (NSDate *)BB_contentModificationDate;
/**
 Returns the value associated with the NSURLIsDirectoryKey key.
 
 @return The associated isDirectory value
 */
- (BOOL)BB_isDirectory;
/**
 Returns the value associated with the NSURLTypeIdentifierKey key.
 
 @return The associated type identifier
 */
- (NSString *)BB_typeIdentifier;
/**
 Returns the value associated with the NSURLEffectiveIconKey key or nil if no such value exists.
 
 @return The associated image
 */
#if (TARGET_OS_IPHONE)
- (UIImage *)BB_effectiveIcon;
#else
- (NSImage *)BB_effectiveIcon;
#endif

@end
