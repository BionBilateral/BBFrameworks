//
//  BBMoviePlayerEmbeddedBottomView.m
//  BBFrameworks
//
//  Created by William Towe on 6/25/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerEmbeddedBottomView.h"
#import "BBMoviePlayerController.h"
#import "BBMediaPlayerDefines.h"
#import "BBMoviePlayerSliderView.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMoviePlayerEmbeddedBottomView ()
@property (strong,nonatomic) UIVisualEffectView *blurVisualEffectView;
@property (strong,nonatomic) UIButton *playPauseButton;
@property (strong,nonatomic) BBMoviePlayerSliderView *sliderView;
@property (strong,nonatomic) UIButton *fullscreenButton;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerEmbeddedBottomView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 44.0);
}

- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super init]))
        return nil;

    [self setMoviePlayerController:moviePlayerController];
    
    [self setBlurVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]];
    [self.blurVisualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.blurVisualEffectView];
    
    [self setPlayPauseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.playPauseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playPauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_play"] BB_imageByRenderingWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_play"] BB_imageByRenderingWithColor:[UIColor whiteColor]] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_pause"] BB_imageByRenderingWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_pause"] BB_imageByRenderingWithColor:[UIColor whiteColor]] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.blurVisualEffectView.contentView addSubview:self.playPauseButton];
    
    [self setSliderView:[[BBMoviePlayerSliderView alloc] initWithMoviePlayerController:self.moviePlayerController]];
    [self.sliderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.blurVisualEffectView.contentView addSubview:self.sliderView];
    
    [self setFullscreenButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.fullscreenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fullscreenButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_maximize"] BB_imageByRenderingWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.fullscreenButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_minimize"] BB_imageByRenderingWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    [self.blurVisualEffectView.contentView addSubview:self.fullscreenButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[view]" options:0 metrics:@{@"padding": @(BBMediaPlayerSubviewPadding)} views:@{@"view": self.playPauseButton}]];
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.playPauseButton}]];
    
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(padding)-|" options:0 metrics:@{@"padding": @(BBMediaPlayerSubviewPadding)} views:@{@"view": self.fullscreenButton}]];
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.fullscreenButton}]];
    
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button1]-(margin)-[view]-(margin)-[button2]" options:0 metrics:@{@"margin": @(BBMediaPlayerSubviewMargin)} views:@{@"button1": self.playPauseButton, @"view": self.sliderView, @"button2": self.fullscreenButton}]];
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.sliderView}]];
    
    @weakify(self);
    
    RAC(self.playPauseButton,selected) = [[RACObserve(self.moviePlayerController, currentPlaybackRate)
                                          map:^id(NSNumber *value) {
                                              return @(value.floatValue != 0.0);
                                          }]
                                          deliverOn:[RACScheduler mainThreadScheduler]];
    
    [self.playPauseButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [[[self.playPauseButton.rac_command.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         if (self.moviePlayerController.currentPlaybackRate == 0.0) {
             [self.moviePlayerController play];
         }
         else {
             [self.moviePlayerController pause];
         }
     }];
    
    RAC(self.fullscreenButton,selected) = [RACObserve(self.moviePlayerController, fullscreen)
                                           deliverOn:[RACScheduler mainThreadScheduler]];
    
    [self.fullscreenButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [[[self.fullscreenButton.rac_command.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.moviePlayerController setFullscreen:YES animated:YES];
     }];
    
    return self;
}

@end
