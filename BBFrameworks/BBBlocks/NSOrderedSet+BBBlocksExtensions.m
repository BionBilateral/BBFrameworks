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
- (NSOrderedSet *)BB_reject:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block(obj,idx)) {
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
- (NSOrderedSet *)BB_map:(id _Nullable(^)(id object, NSInteger index))block; {
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
- (NSOrderedSet *)BB_flatten; {
    return [[self BB_reduceWithStart:[[NSMutableOrderedSet alloc] init] block:^id _Nonnull(NSMutableOrderedSet * _Nullable sum, NSOrderedSet * _Nonnull object, NSInteger index) {
        [sum addObjectsFromArray:object.array];
        return sum;
    }] copy];
}
- (NSOrderedSet *)BB_flattenMap:(id _Nullable(^)(id object, NSInteger index))block; {
    return [[self BB_flatten] BB_map:block];
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
- (BOOL)BB_none:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSOrderedSet *)BB_take:(NSInteger)count; {
    if (count > self.count) {
        return self;
    }
    else {
        return [NSOrderedSet orderedSetWithArray:[self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)]]];
    }
}
- (NSOrderedSet *)BB_drop:(NSInteger)count; {
    if (count > self.count) {
        return [NSOrderedSet orderedSet];
    }
    else {
        return [NSOrderedSet orderedSetWithArray:[self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.count - count)]]];
    }
}
- (NSOrderedSet *)BB_zip:(NSOrderedSet *)orderedSet; {
    NSParameterAssert(orderedSet);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < orderedSet.count) {
            [retval addObject:[NSOrderedSet orderedSetWithArray:@[obj,orderedSet[idx]]]];
        }
    }];
    
    return [retval copy];
}
- (id)BB_sum; {
    if (self.count > 0) {
        NSNumber *first = self.firstObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self BB_reduceWithStart:[NSDecimalNumber zero] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object, NSInteger index) {
                return [sum decimalNumberByAdding:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self BB_reduceWithStart:@0.0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.doubleValue + object.doubleValue);
                }];
            }
            else {
                return [self BB_reduceWithStart:@0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.integerValue + object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)BB_product; {
    if (self.count > 0) {
        NSNumber *first = self.firstObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self BB_reduceWithStart:[NSDecimalNumber one] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object, NSInteger index) {
                return [sum decimalNumberByMultiplyingBy:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self BB_reduceWithStart:@1.0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.doubleValue * object.doubleValue);
                }];
            }
            else {
                return [self BB_reduceWithStart:@1 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.integerValue * object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)BB_maximum; {
    return [self BB_reduceWithStart:self.firstObject block:^id(id sum, id object, NSInteger index) {
        return [object compare:sum] == NSOrderedDescending ? object : sum;
    }];
}
- (id)BB_minimum; {
    return [self BB_reduceWithStart:self.firstObject block:^id(id sum, id object, NSInteger index) {
        return [object compare:sum] == NSOrderedAscending ? object : sum;
    }];
}

@end
