//
//  BBFrameworksMacros.h
//  BBFrameworks
//
//  Created by William Towe on 7/23/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_MACROS__
#define __BB_FRAMEWORKS_MACROS__

#import "BBFrameworksMacrosPrivate.h"

/**
 Macro to create a weakly referenced variable of type var.
 
 @param The variable you want to weakly reference
 */
#define BBWeakify(var) __weak typeof(var) BBWeak_##var = var;

/**
 Macro to strongly reference a previously weakly referenced variable created by using BBWeakify. The strongly referenced variable shadows the weakly referenced variable, preventing a retain cycle. Especially useful for referencing self within a block.
 
 BBWeakify(self); // expands to __weak typeof(self) BBWeak_selfvar = self;
 self.myBlock = ^{
    BBStrongify(self); // expands to  __strong typeof(self) self = BBWeak_selfvar;
    // safely reference self within the block because self is actually a shadow variable
    self.myString = @"myStringValue";
 }
 
 @param The variable you want to strongly reference, which must have been previously created using BBWeakify
 */
#define BBStrongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = BBWeak_##var; \
_Pragma("clang diagnostic pop")

/**
 Given a real object receiver and key path, returns the string concatentation of all arguments except the first. If the keypath is invalid, it will be flagged at compile time.
 
     NSString *string = ...;
     NSString *keypath = @BBKeypath(string.lowercaseString); // @"lowercaseString"
 
     keypath = @BBKeypath(NSObject, version); // @"version"
 
     keypath = @BBKeypath(NSString.new, lowercaseString); // @"lowercaseString"
 */
#define BBKeypath(...) \
BBmetamacro_if_eq(1, BBmetamacro_argcount(__VA_ARGS__))(BBkeypath1(__VA_ARGS__))(BBkeypath2(__VA_ARGS__))

#endif
