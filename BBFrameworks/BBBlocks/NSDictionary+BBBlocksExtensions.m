//
//  NSDictionary+BBBlockExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 11/3/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSDictionary+BBBlocksExtensions.h"
#import "NSArray+BBBlocksExtensions.h"

@implementation NSDictionary (BBBlocksExtensions)

- (void)BB_each:(void(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key,obj);
    }];
}
- (NSDictionary *)BB_filter:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            [retval setObject:obj forKey:key];
        }
    }];
    
    return [retval copy];
}
- (NSDictionary *)BB_reject:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(key,obj)) {
            [retval setObject:obj forKey:key];
        }
    }];
    
    return [retval copy];
}
- (nullable id)BB_find:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (nullable NSDictionary *)BB_findWithKey:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block NSDictionary *retval = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = @{key: obj};
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSDictionary *)BB_map:(id _Nullable(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [retval setObject:block(key,obj) ?: [NSNull null] forKey:key];
    }];
    
    return [retval copy];
}
- (nullable id)BB_reduceWithStart:(nullable id)start block:(id _Nullable(^)(id _Nullable sum, id key, id value))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        retval = block(retval,key,obj);
    }];
    
    return retval;
}
- (BOOL)BB_any:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)BB_all:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(key,obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (id)BB_sumOfKeys {
    return [self.allKeys BB_sum];
}
- (id)BB_sumOfValues; {
    return [self.allValues BB_sum];
}
- (id)BB_productOfKeys {
    return [self.allKeys BB_product];
}
- (id)BB_productOfValues; {
    return [self.allValues BB_product];
}
- (id)BB_maximumKey {
    return [self.allKeys BB_maximum];
}
- (id)BB_maximumValue; {
    return [self.allValues BB_maximum];
}
- (id)BB_minimumKey {
    return [self.allKeys BB_minimum];
}
- (id)BB_minimumValue; {
    return [self.allValues BB_minimum];
}

@end
