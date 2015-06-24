//
//  BBTextView.m
//  BBFrameworks
//
//  Created by Jason Anderson on 6/24/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBTextView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBTextView ()

@property (strong,nonatomic) UILabel *placeholderLabel;

- (void)_BBTextViewInit;

+ (UIFont *)_defaultPlaceholderFont;
+ (UIColor *)_defaultPlaceholderTextColor;

@end

@implementation BBTextView
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBTextViewInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (!(self = [super initWithFrame:frame textContainer:textContainer]))
        return nil;
    
    [self _BBTextViewInit];
    
    return self;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBTextViewInit];
    
    return self;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setPlaceholderFont:self.font];
}
- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    [self setPlaceholderTextColor:self.textColor];
}

#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = (placeholderFont) ?: [self.class _defaultPlaceholderFont];
}
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = (placeholderTextColor) ?: [self.class _defaultPlaceholderTextColor];
}

#pragma mark *** Private Methods ***
- (void)_BBTextViewInit {
    
}

+ (UIFont *)_defaultPlaceholderFont {
    return [UIFont systemFontOfSize:17];
}

+ (UIColor *)_defaultPlaceholderTextColor {
    return [UIColor blackColor];
}

@end
