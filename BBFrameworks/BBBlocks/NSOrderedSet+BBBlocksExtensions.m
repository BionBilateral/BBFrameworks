//
//  NSOrderedSet+BBBlocksExtensions.m
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

#import "NSOrderedSet+BBBlocksExtensions.h"

@implementation NSOrderedSet (BBBlocksExtensions)

- (void)BB_each:(void(^)(id object, NSInteger idx))block; {
    NSParameterAssert(block);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj,idx);
    }];
}
- (NSOrderedSet *)BB_filter:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (id)BB_find:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSArray *)BB_findWithIndex:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = @[obj,@(idx)];
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSOrderedSet *)BB_map:(id(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [retval addObject:block(obj,idx) ?: [NSNull null]];
    }];
    
    return [retval copy];
}
- (id)BB_reduceWithStart:(id)start block:(id(^)(id sum, id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        retval = block(retval,obj,idx);
    }];
    
    return retval;
}
- (BOOL)BB_any:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)BB_all:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj,idx)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}

@end
