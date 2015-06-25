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

#import <ReactiveCocoa/ReactiveCocoa.h>

CGFloat const BBMoviePlayerEmbeddedBottomViewHeight = 44.0;

@interface BBMoviePlayerEmbeddedBottomView ()
@property (strong,nonatomic) UIVisualEffectView *blurVisualEffectView;
@property (strong,nonatomic) UIVisualEffectView *vibrancyVisualEffectView;
@property (strong,nonatomic) UIButton *playPauseButton;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerEmbeddedBottomView
#define kTableName @"MediaPlayer"
- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super init]))
        return nil;

    [self setBackgroundColor:[UIColor clearColor]];
    [self setMoviePlayerController:moviePlayerController];
    
    [self setBlurVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]];
    [self.blurVisualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.blurVisualEffectView];
    
    [self setVibrancyVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.blurVisualEffectView.effect]]];
    [self.vibrancyVisualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.blurVisualEffectView.contentView addSubview:self.vibrancyVisualEffectView];
    
    [self setPlayPauseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.playPauseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playPauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.playPauseButton setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PLAYER_MOVIE_PLAYER_PLAY_BUTTON_TITLE", @"MediaPlayer", [NSBundle bundleForClass:self.class], @"Play", @"media player play button title") forState:UIControlStateNormal];
    [self.playPauseButton setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PLAYER_MOVIE_PLAYER_PAUSE_BUTTON_TITLE", @"MediaPlayer", [NSBundle bundleForClass:self.class], @"Pause", @"media player pause button title") forState:UIControlStateSelected];
    [self.vibrancyVisualEffectView.contentView addSubview:self.playPauseButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.blurVisualEffectView}]];
    
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyVisualEffectView}]];
    [self.blurVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyVisualEffectView}]];
    
    [self.vibrancyVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[view]" options:0 metrics:@{@"padding": @(BBMediaPlayerSubviewPadding)} views:@{@"view": self.playPauseButton}]];
    [self.vibrancyVisualEffectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.playPauseButton}]];
    
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
    
    return self;
}

@end
