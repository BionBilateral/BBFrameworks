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
#import "BBFoundationGeometryFunctions.h"
#import "UIImage+BBKitExtensions.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBFoundationDebugging.h"

@interface BBMediaViewerMovieSlider ()

@end

@implementation BBMediaViewerMovieSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setMinimumTrackTintColor:[UIColor clearColor]];
    [self setMaximumTrackTintColor:[UIColor clearColor]];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.isTracking) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    
    [[UIColor lightGrayColor] setFill];
    UIRectFill(trackRect);
    
    if (self.progress > 0.0) {
        CGRect trackRect = [self trackRectForBounds:self.bounds];
        CGFloat availableWidth = CGRectGetWidth(trackRect);
        CGFloat width = ceil(availableWidth * self.progress);
        
        [[self.tintColor colorWithAlphaComponent:0.2] setFill];
        UIRectFill(CGRectMake(CGRectGetMinX(trackRect), CGRectGetMinY(trackRect), width, CGRectGetHeight(trackRect)));
    }
    
    CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];

    [self.tintColor setFill];
    UIRectFill(CGRectMake(CGRectGetMinX(trackRect), CGRectGetMinY(trackRect), CGRectGetMidX(thumbRect), CGRectGetHeight(trackRect)));
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL retval = [super continueTrackingWithTouch:touch withEvent:event];
    
    if (retval) {
        [self setNeedsDisplay];
    }
    
    return retval;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

@end
