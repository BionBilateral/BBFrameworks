//
//  BBMediaViewerMovieSlider.m
//  BBFrameworks
//
//  Created by William Towe on 8/10/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerMovieSlider.h"
#import "BBFoundationDebugging.h"

@interface BBMediaViewerMovieSlider ()
@property (strong,nonatomic) UILabel *timeElapsedLabel;
@property (strong,nonatomic) UILabel *timeRemainingLabel;
@end

@implementation BBMediaViewerMovieSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    NSString *textStyle = UIFontTextStyleFootnote;
    
    [self setTimeElapsedLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeElapsedLabel setFont:[UIFont preferredFontForTextStyle:textStyle]];
    [self.timeElapsedLabel setTextColor:[UIColor whiteColor]];
    [self.timeElapsedLabel setText:@"00:00:00"];
    [self addSubview:self.timeElapsedLabel];
    
    [self setTimeRemainingLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeRemainingLabel setFont:[UIFont preferredFontForTextStyle:textStyle]];
    [self.timeRemainingLabel setTextColor:[UIColor whiteColor]];
    [self.timeRemainingLabel setText:@"-00:00:00"];
    [self addSubview:self.timeRemainingLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize timeElapsedLabelSize = [self.timeElapsedLabel sizeThatFits:CGSizeZero];
    CGSize timeRemainingLabelSize = [self.timeRemainingLabel sizeThatFits:CGSizeZero];
    
    [self.timeElapsedLabel setFrame:CGRectMake(0, 0, timeElapsedLabelSize.width, CGRectGetHeight(self.bounds))];
    [self.timeRemainingLabel setFrame:CGRectMake(CGRectGetWidth(self.bounds) - timeRemainingLabelSize.width, 0, timeRemainingLabelSize.width, CGRectGetHeight(self.bounds))];
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGSize timeElapsedLabelSize = [self.timeElapsedLabel sizeThatFits:CGSizeZero];
    CGSize timeRemainingLabelSize = [self.timeRemainingLabel sizeThatFits:CGSizeZero];
    CGRect retval = [super trackRectForBounds:bounds];
    
    retval.origin.x += timeElapsedLabelSize.width;
    retval.size.width -= timeElapsedLabelSize.width + timeRemainingLabelSize.width;
    
    return retval;
}

@end
