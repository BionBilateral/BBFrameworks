//
//  BBFoundationNSArrayExtensionsTestCase.m
//  BBFrameworks
//
//  Created by William Towe on 5/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <BBFrameworks/NSArray+BBFoundationExtensions.h>

@interface BBFoundationNSArrayExtensionsTestCase : XCTestCase

@end

@implementation BBFoundationNSArrayExtensionsTestCase

- (void)testBBSet {
    NSArray *const array = @[@1,@2,@3];
    NSSet *const set = [NSSet setWithArray:array];
    
    XCTAssertEqualObjects([array BB_set], set);
}
- (void)setBBMutableSet {
    NSArray *const array = @[@1,@2,@3];
    NSMutableSet *const set = [NSMutableSet setWithArray:array];
    
    XCTAssertEqualObjects([array BB_mutableSet], set);
}

@end
