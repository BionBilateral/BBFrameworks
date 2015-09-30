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

NS_ASSUME_NONNULL_BEGIN

@class RACSignal;

/**
 BBMoviePlayerController is a NSObject subclass similar to MPMoviePlayerController.
 */
@interface BBMoviePlayerController : NSObject

/**
 Set and get the content URL of the receiver. This can be a local or remote URL.
 */
@property (copy,nonatomic,nullable) NSURL *contentURL;

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
 Set and get the fullscreen status of the receiver.
 */
@property (assign,nonatomic,getter=isFullscreen) BOOL fullscreen;
/**
 Set and get whether the receiver is fullscreen, with optional animation.
 
 @param fullscreen Whether the receiver should enter or exit fullscreen mode
 @param animated Whether the change should be animated
 */
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;
/**
 Set and get whether the receiver is fullscreen, animated with a completion block.
 
 @param fullscreen Whether the receiver should enter or exit fullscreen mode
 @param animated Whether the change should be animated
 @param completion The completion block to invoke when the transition completes
 */
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated completion:(nullable void(^)(void))completion;

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

/**
 Calls `-[self requestThumbnailImagesAtIntervals:]`, passing `@[@(interval)]`.
 
 @param The interval for which to generate a thumbnail
 @return The signal
 */
- (RACSignal *)requestThumbnailImageAtInterval:(NSTimeInterval)interval;
/**
 Returns a signal that sends next once for each interval in _intervals_ and then completes. Sends error if thumbnail generation fails for any of the intervals in _intervals_.
 
 @param intervals An array of NSValue instances wrapping NSTimeInterval values
 @return The signal
 */
- (RACSignal *)requestThumbnailImagesAtIntervals:(NSArray *)intervals;

/**
 Returns a signal that sends next with a tuple containing the receiver and the time in seconds that the message was sent.
 
 @param interval The interval at which to send next
 @return The signal
 */
- (RACSignal *)periodicTimeObserverWithInterval:(NSTimeInterval)interval;
/**
 Returns a signal that sends next with the receiver when playback reaches one of the times included in the provided array.
 
 @param intervals An array of NSNumber objects wrapping NSTimeInterval values representing when to send next
 @return The signal
 */
- (RACSignal *)boundaryTimeObserverForIntervals:(NSArray *)intervals;

@end

NS_ASSUME_NONNULL_END
