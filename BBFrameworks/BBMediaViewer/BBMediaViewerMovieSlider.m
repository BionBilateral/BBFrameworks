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

@interface BBMediaViewerMovieSlider ()
@property (readwrite,strong,nonatomic) UIProgressView *progressView;
@end

@implementation BBMediaViewerMovieSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setProgressView:[[UIProgressView alloc] initWithFrame:CGRectZero]];
    [self.progressView setTrackTintColor:[UIColor clearColor]];
    [self.progressView setProgressTintColor:[UIColor whiteColor]];
    [self.progressView sizeToFit];
    [self addSubview:self.progressView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.progressView setFrame:BBCGRectCenterInRectVertically(CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self.progressView sizeThatFits:CGSizeZero].height), self.bounds)];
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect retval = [super trackRectForBounds:bounds];
    
    retval.size.height = 0;
    
    return retval;
}

@end
