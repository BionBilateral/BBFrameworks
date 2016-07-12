//
//  BBMediaViewerPageMovieModel.h
//  BBFrameworks
//
//  Created by William Towe on 2/29/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageModel.h"
#import <AVFoundation/AVPlayer.h>

NS_ASSUME_NONNULL_BEGIN

extern float const BBMediaViewerPageMovieModelRatePlay;
extern float const BBMediaViewerPageMovieModelRatePause;
extern float const BBMediaViewerPageMovieModelRateSlowForward;
extern float const BBMediaViewerPageMovieModelRateFastForward;
extern float const BBMediaViewerPageMovieModelRateSlowReverse;
extern float const BBMediaViewerPageMovieModelRateFastReverse;

@class RACSignal,RACCommand;

@interface BBMediaViewerPageMovieModel : BBMediaViewerPageModel

@property (readonly,strong,nonatomic) AVPlayer *player;

@property (readonly,nonatomic) NSTimeInterval duration;

@property (assign,nonatomic) float currentPlaybackRate;
@property (assign,nonatomic) NSTimeInterval currentPlaybackTime;

@property (readonly,strong,nonatomic) RACSignal *enabledSignal;
@property (readonly,strong,nonatomic) RACSignal *loadingSignal;

@property (readonly,strong,nonatomic) RACCommand *playPauseCommand;
@property (readonly,strong,nonatomic) RACCommand *slowForwardCommand;
@property (readonly,strong,nonatomic) RACCommand *fastForwardCommand;
@property (readonly,strong,nonatomic) RACCommand *slowReverseCommand;
@property (readonly,strong,nonatomic) RACCommand *fastReverseCommand;

- (void)play;
- (void)slowForward;
- (void)fastForward;
- (void)slowReverse;
- (void)fastReverse;
- (void)pause;
- (void)stop;

- (RACSignal *)periodicTimeObserverWithIntervalSignal:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
