//
//  NSDate+BBFoundationExtensions.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BBFoundationExtensions)

/**
 Returns the day component from a NSDateComponents created from the receiver.
 
 @return The day of the receiver
 */
- (NSInteger)BB_day;
/**
 Returns the month component from a NSDateComponents created from the receiver.
 
 @return The month of the receiver
 */
- (NSInteger)BB_month;
/**
 Returns the year component from a NSDateComponents created from the receiver.
 
 @return The year of the receiver
 */
- (NSInteger)BB_year;

/**
 Returns a NSDate representing the beginning of the day, which is 12:00:00 AM.
 
 @return The beginning of the day date
 */
- (NSDate *)BB_beginningOfDay;
/**
 Returns a NSDate representing the end of the day, which is 11:59:59 PM.
 
 @return The end of the day date
 */
- (NSDate *)BB_endOfDay;

@end

NS_ASSUME_NONNULL_END