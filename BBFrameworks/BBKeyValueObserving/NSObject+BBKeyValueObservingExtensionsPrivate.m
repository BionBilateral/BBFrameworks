//
//  NSObject+BBKeyValueObservingExtensionsPrivate.m
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

#import "NSObject+BBKeyValueObservingExtensionsPrivate.h"

#import <objc/runtime.h>

static void const *kWrappersKey = &kWrappersKey;

@implementation NSObject (BBKeyValueObservingExtensionsPrivate)

- (void)BB_addKeyValueObservingWrapper:(BBKeyValueObservingWrapper *)wrapper; {
    NSMutableSet *set = self.BB_keyValueObservingWrappers;
    
    @synchronized(set) {
        [set addObject:wrapper];
    }
}
- (void)BB_removeKeyValueObservingWrapper:(BBKeyValueObservingWrapper *)wrapper; {
    NSMutableSet *set = self.BB_keyValueObservingWrappers;
    
    @synchronized(set) {
        [set removeObject:wrapper];
    }
}

- (NSMutableSet *)BB_keyValueObservingWrappers {
    NSMutableSet *retval = nil;
    
    @synchronized(self) {
        retval = objc_getAssociatedObject(self, kWrappersKey);
        
        if (!retval) {
            retval = [[NSMutableSet alloc] init];
            
            objc_setAssociatedObject(self, kWrappersKey, retval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    return retval;
}

@end
