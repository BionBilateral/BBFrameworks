//
//  BBMediaViewerScrollView.m
//  BBFrameworks
//
//  Created by William Towe on 8/8/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerImageScrollView.h"
#import "BBMediaViewerDetailViewModel.h"

@interface BBMediaViewerImageScrollView ()
@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;

@property (readwrite,strong,nonatomic) UIImageView *imageView;

- (void)_centerImageView;
- (void)_updateZoomScale;
@end

@implementation BBMediaViewerImageScrollView

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    
    [self setContentSize:self.imageView.image.size];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self _centerImageView];
    [self _updateZoomScale];
}

- (instancetype)initWithViewModel:(BBMediaViewerDetailViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setViewModel:viewModel];
    
    [self setBouncesZoom:YES];
    [self setDecelerationRate:UIScrollViewDecelerationRateFast];
    
    [self setImageView:[[UIImageView alloc] initWithImage:self.viewModel.image]];
    [self addSubview:self.imageView];
    
    return self;
}

- (void)centerImageView; {
    [self _centerImageView];
}
- (void)updateZoomScale; {
    [self _updateZoomScale];
}

- (void)_centerImageView; {
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
    if (!self.imageView.image) {
        return;
    }
    
    CGRect scrollViewFrame = self.bounds;
    
    CGFloat scaleWidth = scrollViewFrame.size.width / self.imageView.image.size.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.imageView.image.size.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = MAX(minScale, self.maximumZoomScale);
    
    self.zoomScale = self.minimumZoomScale;
}

@end
