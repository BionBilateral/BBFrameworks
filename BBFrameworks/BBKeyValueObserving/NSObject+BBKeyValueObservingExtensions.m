//
//  NSObject+BBKeyValueObservingExtensions.m
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

#import "NSObject+BBKeyValueObservingExtensions.h"
#import "BBFoundationDebugging.h"

#import <objc/runtime.h>

static NSMutableSet *kSwizzledClasses;

@class _BBKeyValueObservingObserver;

@interface NSObject (BBKeyValueObservingExtensionsPrivate)
- (void)_BB_addKeyValueObservingObserver:(_BBKeyValueObservingObserver *)observer;
- (void)_BB_removeKeyValueObservingObserver:(_BBKeyValueObservingObserver *)observer;

- (void)_swizzleObjectClassIfNeeded:(id)object;
@end

@interface _BBKeyValueObservingObserver : NSObject

@property (weak,nonatomic) id target;
@property (copy,nonatomic) NSString *keyPath;
@property (assign,nonatomic) NSKeyValueObservingOptions options;
@property (assign,nonatomic) void *context;
@property (copy,nonatomic) BBKeyValueObservingBlock block;

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(BBKeyValueObservingBlock)block;

@end

@implementation _BBKeyValueObservingObserver

- (void)dealloc {
    BBLog();
    [_target removeObserver:self forKeyPath:_keyPath context:_context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == self.context) {
        self.block(keyPath,object,change,context);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(BBKeyValueObservingBlock)block; {
    if (!(self = [super init]))
        return nil;
    
    [self setTarget:target];
    [self setKeyPath:keyPath];
    [self setOptions:options];
    [self setContext:context];
    [self setBlock:block];
    
    [_target addObserver:self forKeyPath:_keyPath options:_options context:_context];
    
    return self;
}

@end

@implementation NSObject (BBKeyValueObservingExtensions)

- (void)BB_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(BBKeyValueObservingBlock)block; {
    _BBKeyValueObservingObserver *observer = [[_BBKeyValueObservingObserver alloc] initWithTarget:self keyPath:keyPath options:options context:context block:block];
    
    [self _BB_addKeyValueObservingObserver:observer];
}

@end

@implementation NSObject (BBKeyValueObservingExtensionsPrivate)

- (void)_BB_addKeyValueObservingObserver:(_BBKeyValueObservingObserver *)observer; {
    const void *key = [NSString stringWithFormat:@"%p",observer].UTF8String;
    
    objc_setAssociatedObject(self, key, observer, OBJC_ASSOCIATION_RETAIN);
}
- (void)_BB_removeKeyValueObservingObserver:(_BBKeyValueObservingObserver *)observer; {
    const void *key = [NSString stringWithFormat:@"%p",observer].UTF8String;
    
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)_swizzleObjectClassIfNeeded:(id)object; {
    
}

@end
