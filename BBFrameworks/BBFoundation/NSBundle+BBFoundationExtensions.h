//
//  NSBundle+BBFoundationExtensions.h
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

@interface NSBundle (BBFoundationExtensions)

/**
 Returns the bundle identifier. For example, "com.bionbilateral.app".
 
 @return The bundle identifier
 */
- (NSString *)BB_bundleIdentifier;
/**
 Returns the bundle display name. For example, "App". This value is localized.
 
 @return The bundle display name
 */
- (NSString *)BB_bundleDisplayName;
/**
 Returns the bundle executable. For example, "App". This value is not localized.
 
 @return The bundle executable
 */
- (NSString *)BB_bundleExecutable;
/**
 Returns the bundle short version string. For example, "1.0.0".
 
 @return The bundle short version string
 */
- (NSString *)BB_bundleShortVersionString;
/**
 Returns the bundle version. For example, "1".
 
 @return The bundle version
 */
- (NSString *)BB_bundleVersion;

@end
