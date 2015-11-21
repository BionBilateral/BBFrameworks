//
//  BBMediaViewerBottomContainerView.m
//  BBFrameworks
//
//  Created by William Towe on 8/17/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerBottomContainerView.h"
#import "BBGradientView.h"
#import "BBMediaViewerViewModel.h"
#import "BBKitColorMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerBottomContainerView ()
@property (strong,nonatomic) BBGradientView *gradientView;

@property (strong,nonatomic) BBMediaViewerViewModel *viewModel;
@end

@implementation BBMediaViewerBottomContainerView

- (void)layoutSubviews {
    [self.gradientView setFrame:self.bounds];
    [self.contentView setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, [self.contentView sizeThatFits:CGSizeZero].height);
}

- (instancetype)initWithViewModel:(BBMediaViewerViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    [self setGradientView:[[BBGradientView alloc] initWithFrame:CGRectZero]];
    [self.gradientView setColors:@[BBColorWA(0.0, 0.0),BBColorWA(0.0, 0.75)]];
    [self addSubview:self.gradientView];
    
    return self;
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    if (_contentView) {
        [self addSubview:_contentView];
    }
}

@end
