//
//  NSFileManager+BBFoundationExtensions.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 Category on NSFileManager providing various convenience methods.
 */
@interface NSFileManager (BBFoundationExtensions)

/**
 Returns the NSURL instance representing the application support directory, creating the directory if it does not exist. On OSX, appends the bundle executable name to the returned URL (e.g. <application_support>/<bundle_executable>).
 
 @return The application support NSURL instance
 */
- (NSURL *)BB_applicationSupportDirectoryURL;
/**
 Returns the NSURL instance representing the caches directory. On OSX, appends the bundle identifier to the returned URL (e.g. <caches>/<bundle_identifier>) and creates the directory if it does not already exist. On iOS, the base caches directory will always exist.
 
 @return The caches NSURL instance
 */
- (NSURL *)BB_cachesDirectoryURL;
/**
 Returns the NSURL instance representing the document directory.
 
 @return The document NSURL instance
 */
- (NSURL *)BB_documentDirectoryURL;

@end

NS_ASSUME_NONNULL_END