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

- (void)BB_each:(void(^)(id object))block; {
    NSParameterAssert(block);
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}
- (NSSet *)BB_filter:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (NSSet *)BB_reject:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(obj)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (id)BB_find:(BOOL(^)(id object))block; {
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
- (NSSet *)BB_map:(id _Nullable(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [retval addObject:block(obj) ?: [NSNull null]];
    }];
    
    return [retval copy];
}
- (id)BB_reduceWithStart:(id)start block:(id(^)(id sum, id object))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        retval = block(retval,obj);
    }];
    
    return retval;
}
- (CGFloat)BB_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, id _Nonnull object))block; {
    return [[self BB_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object) {
        return @(block(sum.floatValue,object));
    }] floatValue];
}
- (NSInteger)BB_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, id _Nonnull object))block; {
    return [[self BB_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object) {
        return @(block(sum.integerValue,object));
    }] integerValue];
}
- (NSSet *)BB_flatten; {
    return [[self BB_reduceWithStart:[[NSMutableSet alloc] init] block:^id _Nonnull(NSMutableSet * _Nullable sum, NSSet * _Nonnull object) {
        [sum unionSet:object];
        return sum;
    }] copy];
}
- (NSSet *)BB_flattenMap:(id _Nullable(^)(id object))block; {
    return [[self BB_flatten] BB_map:block];
}
- (BOOL)BB_any:(BOOL(^)(id object))block; {
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
- (BOOL)BB_all:(BOOL(^)(id object))block; {
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
- (BOOL)BB_none:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (id)BB_sum; {
    if (self.count > 0) {
        NSNumber *first = self.anyObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self BB_reduceWithStart:[NSDecimalNumber zero] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object) {
                return [sum decimalNumberByAdding:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self BB_reduceWithStart:@0.0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.doubleValue + object.doubleValue);
                }];
            }
            else {
                return [self BB_reduceWithStart:@0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.integerValue + object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)BB_product; {
    if (self.count > 0) {
        NSNumber *first = self.anyObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self BB_reduceWithStart:[NSDecimalNumber one] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object) {
                return [sum decimalNumberByMultiplyingBy:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self BB_reduceWithStart:@1.0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.doubleValue * object.doubleValue);
                }];
            }
            else {
                return [self BB_reduceWithStart:@1 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.integerValue * object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)BB_maximum; {
    return [self BB_reduceWithStart:self.anyObject block:^id(id sum, id object) {
        return [object compare:sum] == NSOrderedDescending ? object : sum;
    }];
}
- (id)BB_minimum; {
    return [self BB_reduceWithStart:self.anyObject block:^id(id sum, id object) {
        return [object compare:sum] == NSOrderedAscending ? object : sum;
    }];
}

@end
