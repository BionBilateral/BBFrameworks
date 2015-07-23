//
//  BBFrameworksNSOrderedSetBlocksExtensionsTestCase.m
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

#import <XCTest/XCTest.h>

#import <BBFrameworks/NSOrderedSet+BBBlocksExtensions.h>

@interface BBFrameworksNSOrderedSetBlocksExtensionsTestCase : XCTestCase

@end

@implementation BBFrameworksNSOrderedSetBlocksExtensionsTestCase

- (void)testFilter {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3,@4]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@2,@4]];
    
    XCTAssertEqualObjects([begin BB_filter:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin BB_find:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFindWithIndex {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSArray *end = @[@2,@1];
    
    XCTAssertEqualObjects([begin BB_findWithIndex:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@"1",@"2",@"3"]];
    
    XCTAssertEqualObjects([begin BB_map:^id(NSNumber *object, NSInteger index) {
        return object.stringValue;
    }], end);
}
- (void)testReduce {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithObjects:[NSOrderedSet orderedSetWithObject:@1],[NSOrderedSet orderedSetWithObject:@2],[NSOrderedSet orderedSetWithObject:@3], nil];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    
    XCTAssertEqualObjects([begin BB_reduceWithStart:[[NSMutableOrderedSet alloc] init] block:^id(NSMutableOrderedSet *sum, NSOrderedSet *object, NSInteger index) {
        [sum unionOrderedSet:object];
        return sum;
    }], end);
}
- (void)testAny {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@3,@2]];
    
    XCTAssertTrue([begin BB_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@1,@3,@5]];
    
    XCTAssertFalse([begin BB_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@2,@4,@6]];
    
    XCTAssertTrue([begin BB_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@2,@4,@5]];
    
    XCTAssertFalse([begin BB_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}

@end
