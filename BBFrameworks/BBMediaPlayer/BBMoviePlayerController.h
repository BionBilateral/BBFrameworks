//
//  BBMoviePlayerController.h
//  BBFrameworks
//
//  Created by William Towe on 6/22/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import "BBMoviePlayerControllerDefines.h"

/**
 BBMoviePlayerController is a NSObject subclass similar to MPMoviePlayerController.
 */
@interface BBMoviePlayerController : NSObject

/**
 Set and get the content URL of the receiver. This can be a local or remote URL.
 */
@property (copy,nonatomic) NSURL *contentURL;

/**
 Get the view used to display the movie content. This should be added to your view hiearchy.
 */
@property (readonly,nonatomic) UIView *view;

/**
 Get the background view that is displayed behind movie content. You can add custom views to the background view if you want to display custom content.
 */
@property (readonly,nonatomic) UIView *backgroundView;

/**
 Set and get whether the receiver should automatically play content when its contentURL changes.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL shouldAutoplay;

/**
 Set and get the current playback time of the current movie in seconds.
 */
@property (assign,nonatomic) NSTimeInterval currentPlaybackTime;

/**
 Set and get the current playback rate of the current movie between 0.0 and 1.0. A non-zero rate implies playing.
 
 The default is 1.0.
 */
@property (assign,nonatomic) CGFloat currentPlaybackRate;

/**
 Get the duration of the current movie. Returns 0.0 if the duration is not known.
 */
@property (readonly,nonatomic) NSTimeInterval duration;

/**
 Set and get the movie scaling mode used when displaying movie content.
 
 The default is BBMoviePlayerScalingModeAspectFit.
 */
@property (assign,nonatomic) BBMoviePlayerControllerScalingMode scalingMode;

/**
 Sets the currentPlaybackRate to 1.0.
 */
- (void)play;
/**
 Sets the currentPlaybackRate to 0.0.
 */
- (void)pause;
/**
 Sets the currentPlaybackRate to 0.0 and the currentPlaybackTime to 0.0.
 */
- (void)stop;

@end
