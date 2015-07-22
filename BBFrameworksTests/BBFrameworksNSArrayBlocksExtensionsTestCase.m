//
//  BBFrameworksNSArrayBlocksExtensionsTestCase.m
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

#import <XCTest/XCTest.h>

#import <BBFrameworks/NSArray+BBBlocksExtensions.h>

@interface BBFrameworksNSArrayBlocksExtensionsTestCase : XCTestCase

@end

@implementation BBFrameworksNSArrayBlocksExtensionsTestCase

- (void)testFilter {
    NSArray *begin = @[@1,@2,@3,@4];
    NSArray *end = @[@2,@4];
    
    XCTAssertEqualObjects([begin BB_filter:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSArray *begin = @[@1,@2,@3];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin BB_find:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFindWithIndex {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@2,@1];
    
    XCTAssertEqualObjects([begin BB_findWithIndex:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@"1",@"2",@"3"];
    
    XCTAssertEqualObjects([begin BB_map:^id(NSNumber *object, NSInteger index) {
        return object.stringValue;
    }], end);
}
- (void)testReduce {
    NSArray *begin = @[@[@1],@[@2],@[@3]];
    NSArray *end = @[@1,@2,@3];
    
    XCTAssertEqualObjects([begin BB_reduceWithStart:[[NSMutableArray alloc] init] block:^id(NSMutableArray *sum, NSArray *object, NSInteger index) {
        [sum addObjectsFromArray:object];
        return sum;
    }], end);
}
- (void)testAny {
    NSArray *begin = @[@1,@3,@2];
    
    XCTAssertTrue([begin BB_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = @[@1,@3,@5];
    
    XCTAssertFalse([begin BB_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSArray *begin = @[@2,@4,@6];
    
    XCTAssertTrue([begin BB_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = @[@2,@4,@5];
    
    XCTAssertFalse([begin BB_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}

@end
