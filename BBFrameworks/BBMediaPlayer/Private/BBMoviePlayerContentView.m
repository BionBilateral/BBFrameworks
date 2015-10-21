//
//  BBMoviePlayerContentView.m
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

#import "BBMoviePlayerContentView.h"
#import "BBMoviePlayerController+BBMediaPlayerPrivate.h"

#import <AVFoundation/AVFoundation.h>

@interface BBMoviePlayerContentView ()
@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;

@property (readonly,nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation BBMoviePlayerContentView
#pragma mark *** Subclass Overrides ***
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
#pragma mark *** Public Methods ***
- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setMoviePlayerController:moviePlayerController];
    [self setScalingMode:self.moviePlayerController.scalingMode];
    
    [self.playerLayer setPlayer:self.moviePlayerController.player];
    
    return self;
}
#pragma mark Properties
- (void)setScalingMode:(BBMoviePlayerControllerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    
    switch (_scalingMode) {
        case BBMoviePlayerControllerScalingModeAspectFill:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            break;
        case BBMoviePlayerControllerScalingModeAspectFit:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
            break;
        case BBMoviePlayerControllerScalingModeFill:
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResize];
            break;
    }
}
#pragma mark *** Private Methods ***
#pragma mark Properties
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
