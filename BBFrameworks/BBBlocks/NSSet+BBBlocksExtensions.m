//
//  NSSet+BBBlocksExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 7/22/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSSet+BBBlocksExtensions.h"

@implementation NSSet (BBBlocksExtensions)

- (NSSet *)BB_filter:(BBBlockPredicateObjectBlock)block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (id)BB_find:(BBBlockPredicateObjectBlock)block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSSet *)BB_map:(BBBlockObjectBlock)block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [retval addObject:block(obj) ?: [NSNull null]];
    }];
    
    return [retval copy];
}
- (id)BB_reduceWithStart:(id)start block:(BBBlockSumObjectBlock)block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        retval = block(retval,obj);
    }];
    
    return retval;
}
- (BOOL)BB_any:(BBBlockPredicateObjectBlock)block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)BB_all:(BBBlockPredicateObjectBlock)block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (!block(obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}

@end
