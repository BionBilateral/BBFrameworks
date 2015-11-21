//
//  BBMediaViewerMovieView.m
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

#import "BBMediaViewerMovieView.h"
#import "BBMediaViewerDetailViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

@interface BBMediaViewerMovieView ()
@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (readonly,nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation BBMediaViewerMovieView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)layoutSubviews {
    [self.activityIndicatorView setFrame:self.bounds];
}

- (instancetype)initWithViewModel:(BBMediaViewerDetailViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setViewModel:viewModel];
    
    [self.playerLayer setPlayer:self.viewModel.player];
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    [self addSubview:self.activityIndicatorView];
    
    @weakify(self);
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel.player, status),RACObserve(self.playerLayer, readyForDisplay)] reduce:^id(NSNumber *status, NSNumber *readyForDisplay){
        return @(status.integerValue == AVPlayerStatusUnknown || !readyForDisplay.boolValue);
    }]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if (value.boolValue) {
             [self.activityIndicatorView startAnimating];
         }
         else {
             [self.activityIndicatorView stopAnimating];
         }
     }];
    
    return self;
}

- (void)setVideoGravity:(BBMediaViewerMovieViewVideoGravity)videoGravity {
    _videoGravity = videoGravity;
    
    switch (_videoGravity) {
        case BBMediaViewerMovieViewVideoGravityResizeAspect:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
            break;
        case BBMediaViewerMovieViewVideoGravityResizeAspectFill:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            break;
        case BBMediaViewerMovieViewVideoGravityResize:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResize];
            break;
        default:
            break;
    }
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
