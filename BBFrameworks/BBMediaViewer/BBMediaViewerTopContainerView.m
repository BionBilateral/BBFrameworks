//
//  BBMediaViewerTopContainerView.m
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

#import "BBMediaViewerTopContainerView.h"
#import "BBGradientView.h"
#import "BBKitColorMacros.h"
#import "BBMediaViewerViewModel.h"
#import "BBFoundationGeometryFunctions.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static CGFloat const kMarginX = 16.0;

@interface BBMediaViewerTopContainerView ()
@property (strong,nonatomic) BBGradientView *gradientView;
@property (strong,nonatomic) UIButton *closeButton;
@property (strong,nonatomic) UIButton *actionButton;
@property (strong,nonatomic) UILabel *titleLabel;

@property (readonly,nonatomic) UIColor *renderColor;

@property (strong,nonatomic) BBMediaViewerViewModel *viewModel;
@end

@implementation BBMediaViewerTopContainerView

- (void)layoutSubviews {
    [self.gradientView setFrame:self.bounds];
    
    CGSize closeButtonSize = [self.closeButton sizeThatFits:CGSizeZero];
    
    [self.closeButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(kMarginX, 0, closeButtonSize.width, closeButtonSize.height), self.bounds)];
    [self.actionButton setFrame:CGRectMake(CGRectGetWidth(self.bounds) - [self.actionButton sizeThatFits:CGSizeZero].width - kMarginX, 0, [self.actionButton sizeThatFits:CGSizeZero].width, CGRectGetHeight(self.bounds))];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(self.closeButton.frame), 0, CGRectGetMinX(self.actionButton.frame) - CGRectGetMaxX(self.closeButton.frame), CGRectGetHeight(self.bounds))];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, 44.0);
}

- (instancetype)initWithViewModel:(BBMediaViewerViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    [self setGradientView:[[BBGradientView alloc] initWithFrame:CGRectZero]];
    [self.gradientView setColors:@[BBColorWA(0.0, 0.75),BBColorWA(0.0, 0.0)]];
    [self addSubview:self.gradientView];
    
    [self setCloseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.closeButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_close"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.closeButton setRac_command:self.viewModel.doneCommand];
    [self.closeButton sizeToFit];
    [self addSubview:self.closeButton];
    
    [self setActionButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.actionButton setTitleColor:self.renderColor forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Action" forState:UIControlStateNormal];
    [self.actionButton setRac_command:self.viewModel.actionCommand];
    [self.actionButton sizeToFit];
    [self addSubview:self.actionButton];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setFont:[UINavigationBar appearance].titleTextAttributes[NSFontAttributeName]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
    
    RAC(self.titleLabel,text) = RACObserve(self.viewModel, title);
    
    return self;
}

- (UIColor *)renderColor {
    return [UIColor whiteColor];
}

@end
