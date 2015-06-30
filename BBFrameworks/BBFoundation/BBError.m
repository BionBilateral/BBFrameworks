//
//  BBError.m
//  BBFrameworks
//
//  Created by Jason Anderson on 6/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBError.h"

@interface BBError ()

@property (readwrite) NSString *alertTitle;
@property (readwrite) NSString *alertMessage;

+ (NSString *)_defaultAlertTitle;
+ (NSString *)_defaultAlertMessage;

@end

@implementation BBError

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    return [[self alloc] initWithDomain:domain code:code userInfo:dict];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code alertTitle:(NSString *)title alertMessage:(NSString *)message
{
    return [[self alloc] initWithDomain:domain code:code alertTitle:title alertMessage:message];
}

- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    if (!(self = [super initWithDomain:domain code:code userInfo:dict])) return nil;
    
    [self setAlertTitle:[[self class] _defaultAlertTitle]];
    [self setAlertMessage:[[self class] _defaultAlertMessage]];
    
    return self;
}

- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code alertTitle:(NSString *)title alertMessage:(NSString *)message
{
    if (!(self = [super initWithDomain:domain code:code userInfo:nil])) return nil;
    
    [self setAlertTitle:title];
    [self setAlertMessage:message];
    
    return self;
}

#pragma mark *** Private Methods ***
+ (NSString *)_defaultAlertTitle
{
    return @"";
}

+ (NSString *)_defaultAlertMessage
{
    return @"";
}

@end
