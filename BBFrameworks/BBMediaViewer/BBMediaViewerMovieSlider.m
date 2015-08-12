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
@property (readwrite,strong,nonatomic) UIProgressView *progressView;
@end

@implementation BBMediaViewerMovieSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setMinimumTrackImage:[[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_scrubber_minimum_track"] BB_imageByRenderingWithColor:self.tintColor] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_scrubber_maximum_track"] BB_imageByRenderingWithColor:[UIColor lightGrayColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)] forState:UIControlStateNormal];
    
//    [self setProgressView:[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar]];
//    [self.progressView setTrackImage:[[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_progress"] BB_imageByRenderingWithColor:[UIColor whiteColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)]];
//    [self.progressView setProgressImage:[[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_progress"] BB_imageByRenderingWithColor:[UIColor orangeColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)]];
//    [self addSubview:self.progressView];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.progress > 0.0) {
        CGRect trackRect = [self trackRectForBounds:self.bounds];
        CGFloat availableWidth = CGRectGetWidth(trackRect) - 2.0;
        CGFloat width = ceil(availableWidth * self.progress);
        
        [[UIColor lightGrayColor] setFill];
        UIRectFill(BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(trackRect) + 1.0, 0, width, 9.0), self.bounds));
    }
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    CGRect trackRect = [self trackRectForBounds:self.bounds];
//    
//    [self.progressView setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(trackRect) + 1.0, 0, CGRectGetWidth(trackRect) - 2.0, CGRectGetHeight(self.bounds) - 2.0), self.bounds)];
//}

//- (CGRect)trackRectForBounds:(CGRect)bounds {
//    CGRect retval = [super trackRectForBounds:bounds];
//    
//    retval.size.height = [UIImage imageNamed:@"media_viewer_scrubber_minimum_track"].size.height;
//    
//    return retval;
//}

@end
