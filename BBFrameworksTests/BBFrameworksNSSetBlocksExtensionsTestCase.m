//
//  BBFrameworksNSSetBlocksExtensionsTestCase.m
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

#import <BBFrameworks/NSSet+BBBlocksExtensions.h>

@interface BBFrameworksNSSetBlocksExtensionsTestCase : XCTestCase

@end

@implementation BBFrameworksNSSetBlocksExtensionsTestCase

- (void)testEach {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSSet *end = [NSSet setWithArray:@[@2,@3,@4]];
    NSMutableSet *temp = [[NSMutableSet alloc] init];
    
    [begin BB_each:^(NSNumber *object) {
        [temp addObject:@(object.integerValue + 1)];
    }];
    
    XCTAssertEqualObjects(temp, end);
}
- (void)testFilter {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3,@4]];
    NSSet *end = [NSSet setWithArray:@[@2,@4]];
    
    XCTAssertEqualObjects([begin BB_filter:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin BB_find:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSSet *end = [NSSet setWithArray:@[@"1",@"2",@"3"]];
    
    XCTAssertEqualObjects([begin BB_map:^id(NSNumber *object) {
        return object.stringValue;
    }], end);
}
- (void)testReduce {
    NSSet *begin = [NSSet setWithObjects:[NSSet setWithObject:@1],[NSSet setWithObject:@2],[NSSet setWithObject:@3], nil];
    NSSet *end = [NSSet setWithArray:@[@1,@2,@3]];
    
    XCTAssertEqualObjects([begin BB_reduceWithStart:[[NSMutableSet alloc] init] block:^id(NSMutableSet *sum, id object) {
        [sum unionSet:object];
        return sum;
    }], end);
}
- (void)testAny {
    NSSet *begin = [NSSet setWithArray:@[@1,@3,@2]];
    
    XCTAssertTrue([begin BB_any:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSSet setWithArray:@[@1,@3,@5]];
    
    XCTAssertFalse([begin BB_any:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSSet *begin = [NSSet setWithArray:@[@2,@4,@6]];
    
    XCTAssertTrue([begin BB_all:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSSet setWithArray:@[@2,@4,@5]];
    
    XCTAssertFalse([begin BB_all:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testSum {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin BB_sum], end);
    
    begin = [NSSet setWithArray:@[@1.0,@2.0,@3.0]];
    end = @6.0;
    
    XCTAssertEqualObjects([begin BB_sum], end);
    
    begin = [NSSet setWithArray:@[[NSDecimalNumber decimalNumberWithString:@"1"],[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin BB_sum], end);
}
- (void)testProduct {
    NSSet *begin = [NSSet setWithArray:@[@2,@3,@4]];
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin BB_product], end);
    
    begin = [NSSet setWithArray:@[@2.0,@3.0,@4.0]];
    end = @24.0;
    
    XCTAssertEqualObjects([begin BB_product], end);
    
    begin = [NSSet setWithArray:@[[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"],[NSDecimalNumber decimalNumberWithString:@"4"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin BB_product], end);
}
- (void)testMaximum {
    NSSet *begin = [NSSet setWithArray:@[@1,@3,@2]];
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin BB_maximum], end);
}

@end
