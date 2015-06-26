//
//  BBMoviePlayerFullscreenTopView.m
//  BBFrameworks
//
//  Created by William Towe on 6/26/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerFullscreenTopView.h"
#import "BBMoviePlayerController.h"
#import "BBMediaPlayerDefines.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMoviePlayerFullscreenTopView ()
@property (strong,nonatomic) UIVisualEffectView *blurVisualEffectView;
@property (strong,nonatomic) UIButton *fullscreenButton;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerFullscreenTopView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 60.0);
}

- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setMoviePlayerController:moviePlayerController];
    
    [self setBlurVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]];
    [self.blurVisualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.blurVisualEffectView];
    
    [self setFullscreenButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.fullscreenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fullscreenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.fullscreenButton setTitle:@"Fullscreen" forState:UIControlStateNormal];
    [self.blurVisualEffectView.contentView addSubview:self.fullscreenButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(padding)-|" options:0 metrics:@{@"padding": @(BBMediaPlayerSubviewPadding)} views:@{@"view": self.fullscreenButton}]];
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.fullscreenButton}]];
    
    @weakify(self);
    [self.fullscreenButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [[[self.fullscreenButton.rac_command.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.moviePlayerController setFullscreen:NO animated:YES];
     }];
    
    return self;
}

@end
