//
//  BBMediaViewerPageHTMLToolbarContentView.m
//  BBFrameworks
//
//  Created by William Towe on 3/2/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageHTMLToolbarContentView.h"
#import "BBMediaViewerPageHTMLModel.h"
#import "BBFrameworksMacros.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPageHTMLToolbarContentView ()
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) UIButton *goBackButton;

@property (strong,nonatomic) BBMediaViewerPageHTMLModel *model;
@end

@implementation BBMediaViewerPageHTMLToolbarContentView

- (instancetype)initWithModel:(BBMediaViewerPageHTMLModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressView setTrackTintColor:[UIColor clearColor]];
    [self addSubview:_progressView];
    
    _goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goBackButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_goBackButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_go_back"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateNormal];
    [_goBackButton setRac_command:_model.goBackCommand];
    [self addSubview:_goBackButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _progressView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": _progressView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": _goBackButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progress]-[view]-|" options:0 metrics:nil views:@{@"view": _goBackButton, @"progress": _progressView}]];
    
    BBWeakify(self);
    [[[RACObserve(self.model, loading)
     distinctUntilChanged]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
             [self.progressView setAlpha:value.boolValue ? 1.0 : 0.0];
         } completion:nil];
     }];
    
    [[RACObserve(self.model, estimatedProgress)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         [self.progressView setProgress:value.floatValue];
     }];
    
    return self;
}

@end
