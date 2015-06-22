//
//  NSMutableArray+BBFoundationExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 5/15/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSMutableArray+BBFoundationExtensions.h"

@implementation NSMutableArray (BBFoundationExtensions)

- (void)BB_removeFirstObject; {
    if (self.count > 0) {
        [self removeObjectAtIndex:0];
    }
}

- (void)BB_push:(id)object; {
    [self insertObject:object atIndex:0];
}
- (void)BB_pop; {
    [self BB_removeFirstObject];
}

- (void)BB_shuffle {
    NSUInteger max = self.count - 1;
    
    for (NSUInteger i=0; i<self.count; i++) {
        NSUInteger n = arc4random_uniform((u_int32_t)max) + i;
        
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
