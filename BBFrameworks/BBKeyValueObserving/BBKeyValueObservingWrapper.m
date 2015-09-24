//
//  BBKeyValueObservingWrapper.m
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

#import "BBKeyValueObservingWrapper.h"
#import "NSObject+BBKeyValueObservingExtensionsPrivate.h"

static void *kObservingContext = &kObservingContext;

@interface BBKeyValueObservingWrapper ()
@property (readwrite,unsafe_unretained,nonatomic) id observer;
@property (readwrite,unsafe_unretained,nonatomic) id target;
@property (readwrite,copy,nonatomic) NSSet *keyPaths;
@property (readwrite,assign,nonatomic) NSKeyValueObservingOptions options;
@property (readwrite,copy,nonatomic) BBKeyValueObservingBlock block;
@end

@implementation BBKeyValueObservingWrapper

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == kObservingContext) {
        self.block(keyPath,object,change);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)stopObserving; {
    if ([_target isKindOfClass:[NSArray class]]) {
        // TODO: handle cleanup for NSArray properly
    }
    else {
        for (NSString *keyPath in _keyPaths) {
            [_target removeObserver:self forKeyPath:keyPath context:kObservingContext];
        }
    }
    
    if (_observer) {
        [_observer BB_removeKeyValueObservingWrapper:self];
    }
    
    [_target BB_removeKeyValueObservingWrapper:self];
    
    _observer = nil;
    _target = nil;
    _keyPaths = nil;
}

- (instancetype)initWithObserver:(id)observer target:(id)target keyPaths:(NSSet *)keyPaths options:(NSKeyValueObservingOptions)options block:(BBKeyValueObservingBlock)block; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    NSParameterAssert(block);
    
    _observer = observer;
    _target = target;
    _keyPaths = [keyPaths copy];
    _options = options;
    _block = block;
    
    for (NSString *keyPath in _keyPaths) {
        if ([keyPath isKindOfClass:[NSArray class]]) {
            // TODO: handle NSArray observing properly
        }
        else {
            [target addObserver:self forKeyPath:keyPath options:_options context:kObservingContext];
        }
    }
    
    if (_observer) {
        [_observer BB_addKeyValueObservingWrapper:self];
    }
    
    [_target BB_addKeyValueObservingWrapper:self];
    
    return self;
}

@end
