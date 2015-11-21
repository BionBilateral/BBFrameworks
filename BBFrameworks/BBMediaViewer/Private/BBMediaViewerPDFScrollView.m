//
//  BBMediaViewerPDFScrollView.m
//  BBFrameworks
//
//  Created by William Towe on 11/21/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPDFScrollView.h"
#import "BBMediaViewerPDFPageView.h"

@interface BBMediaViewerPDFScrollView ()
@property (strong,nonatomic) BBMediaViewerPDFPageView *PDFPageView;

- (void)_centerContentView;
- (void)_updateZoomScale;
@end

@implementation BBMediaViewerPDFScrollView

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    
    [self setContentSize:self.PDFPageView.bounds.size];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self _centerContentView];
    [self _updateZoomScale];
}

- (instancetype)initWithPDFPageRef:(CGPDFPageRef)PDFPageRef; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setBouncesZoom:YES];
    [self setDecelerationRate:UIScrollViewDecelerationRateFast];
    
    [self setPDFPageView:[[BBMediaViewerPDFPageView alloc] initWithPDFPageRef:PDFPageRef]];
    [self addSubview:self.PDFPageView];
    
    return self;
}

- (void)centerContentView; {
    [self _centerContentView];
}
- (void)updateZoomScale; {
    [self _updateZoomScale];
}

- (UIView *)viewForZooming {
    return self.PDFPageView;
}

- (void)_centerContentView; {
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;
    
    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5;
    }
    
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5;
    }
    
    if (self.window.screen.scale < 2.0) {
        horizontalInset = floor(horizontalInset);
        verticalInset = floor(verticalInset);
    }
    
    [self setContentInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}
- (void)_updateZoomScale; {
    CGRect scrollViewFrame = self.bounds;
    
    CGFloat scaleWidth = scrollViewFrame.size.width / CGRectGetWidth(self.PDFPageView.bounds);
    CGFloat scaleHeight = scrollViewFrame.size.height / CGRectGetHeight(self.PDFPageView.bounds);
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = MAX(minScale, self.maximumZoomScale);
    
    self.zoomScale = self.minimumZoomScale;
}

@end
