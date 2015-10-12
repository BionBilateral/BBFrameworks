//
//  NSDate+BBFoundationExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 9/20/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSDate+BBFoundationExtensions.h"

@implementation NSDate (BBFoundationExtensions)

- (NSInteger)BB_day; {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    
    return comps.day;
}
- (NSInteger)BB_month; {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    
    return comps.month;
}
- (NSInteger)BB_year; {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    
    return comps.year;
}

- (NSDate *)BB_beginningOfDay; {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDate *retval = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    return retval;
}
- (NSDate *)BB_endOfDay; {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:1];
    
    NSDate *retval = [[[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[self BB_beginningOfDay] options:0] dateByAddingTimeInterval:-1.0];
    
    return retval;
}

@end
