//
//  BBSnakeCaseToLlamaCaseValueTransformerTestCase.m
//  BBFrameworks
//
//  Created by William Towe on 7/2/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <BBFrameworks/BBSnakeCaseToLlamaCaseValueTransformer.h>

@interface BBSnakeCaseToLlamaCaseValueTransformerTestCase : XCTestCase

@end

@implementation BBSnakeCaseToLlamaCaseValueTransformerTestCase

- (void)testTransformedValue {
    NSString *start = @"first_middle_last";
    NSString *end = @"firstMiddleLast";
    
    XCTAssertEqualObjects([[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] transformedValue:start], end);
    
    start = @"first";
    end = @"first";
    
    XCTAssertEqualObjects([[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] transformedValue:start], end);
}
- (void)testReverseTransformedValue {
    NSString *start = @"firstMiddleLast";
    NSString *end = @"first_middle_last";
    
    XCTAssertEqualObjects([[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] reverseTransformedValue:start], end);
    
    start = @"first";
    end = @"first";
    
    XCTAssertEqualObjects([[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] reverseTransformedValue:start], end);
}

@end
