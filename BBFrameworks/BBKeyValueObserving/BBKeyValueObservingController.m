//
//  BBKeyValueObservingController.m
//  BBFrameworks
//
//  Created by William Towe on 9/23/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBKeyValueObservingController.h"
#import "BBKeyValueObservingWrapper.h"
#import "NSObject+BBKeyValueObservingExtensionsPrivate.h"

#import <objc/runtime.h>

static NSMutableSet *kSwizzledClasses;

@interface BBKeyValueObservingController ()
- (void)_swizzleObjectClassIfNeeded:(id)object;
@end

@implementation BBKeyValueObservingController

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSwizzledClasses = [[NSMutableSet alloc] init];
    });
}

+ (instancetype)sharedInstance; {
    static BBKeyValueObservingController *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[BBKeyValueObservingController alloc] init];
    });
    return kRetval;
}

- (id<BBKeyValueObservingToken>)addKeyValueObserver:(id)observer target:(id)target forKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options block:(BBKeyValueObservingBlock)block; {
    [self _swizzleObjectClassIfNeeded:observer];
    [self _swizzleObjectClassIfNeeded:target];
    
    NSMutableSet *setKeyPaths = [[NSMutableSet alloc] init];
    
    for (NSString *keyPath in keyPaths) {
        [setKeyPaths addObject:keyPath];
    }
    
    return [[BBKeyValueObservingWrapper alloc] initWithObserver:observer target:target keyPaths:setKeyPaths options:options block:block];
}

- (void)_swizzleObjectClassIfNeeded:(id)object; {
    if (!object) {
        return;
    }
    
    @synchronized(kSwizzledClasses) {
        Class class = [object class];
        
        if ([kSwizzledClasses containsObject:class]) {
            return;
        }
        
        SEL deallocSel = NSSelectorFromString(@"dealloc");
        Method dealloc = class_getInstanceMethod(class, deallocSel);
        IMP origImpl = method_getImplementation(dealloc);
        IMP newImpl = imp_implementationWithBlock(^(void *obj){
            @autoreleasepool {
                for (BBKeyValueObservingWrapper *wrapper in [[(__bridge id)obj BB_keyValueObservingWrappers] copy]) {
                    [wrapper stopObserving];
                }
            }
            
            ((void (*)(void *, SEL))origImpl)(obj, deallocSel);
        });
        
        class_replaceMethod(class, deallocSel, newImpl, method_getTypeEncoding(dealloc));
        
        [kSwizzledClasses addObject:class];
    }
}

@end
