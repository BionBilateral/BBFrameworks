//
//  BBMoviePlayerController.m
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

#import "BBMoviePlayerController+BBMediaPlayerPrivate.h"
#import "BBMoviePlayerView.h"
#import "BBMoviePlayerContentView.h"
#import "BBMoviePlayerViewController+BBMediaPlayerPrivate.h"
#import "UIViewController+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BlocksKit/BlocksKit.h>

#import <AVFoundation/AVFoundation.h>

static int32_t const kPreferredTimeScale = 1;

@interface BBMoviePlayerController ()
@property (strong,nonatomic) BBMoviePlayerView *moviePlayerView;

@property (readwrite,strong,nonatomic) AVPlayer *player;
@end

@implementation BBMoviePlayerController
#pragma mark *** Subclass Overrides ***
- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setPlayer:[[AVPlayer alloc] init]];
    
    [self setMoviePlayerView:[[BBMoviePlayerView alloc] initWithMoviePlayerController:self]];
    
    @weakify(self);
    
    RACSignal *contentURLSignal = RACObserve(self, contentURL);
    
    [[[contentURLSignal
     distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSURL *value) {
         @strongify(self);
         AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:value];
         
         [self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
         [self.player replaceCurrentItemWithPlayerItem:playerItem];
         
         [[[[RACSignal merge:@[[[NSNotificationCenter defaultCenter]
                             rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:playerItem],
                             [[NSNotificationCenter defaultCenter]
                              rac_addObserverForName:AVPlayerItemFailedToPlayToEndTimeNotification object:playerItem]]]
          takeUntil:[[contentURLSignal skip:1] take:1]]
          deliverOn:[RACScheduler mainThreadScheduler]]
          subscribeNext:^(NSNotification *value) {
              @strongify(self);
              [self willChangeValueForKey:@keypath(self,currentPlaybackRate)];
              [self didChangeValueForKey:@keypath(self,currentPlaybackRate)];
          }];
         
         if (self.shouldAutoplay) {
             [self play];
         }
     }];
    
    return self;
}
#pragma mark *** Public Methods ***
- (void)play {
    // match the behavior of MPMoviePlayerController in that if the movie has finished playing, play first skips to the beginning of the movie before starting playback
    if (CMTIME_IS_VALID(self.player.currentItem.duration) &&
        CMTimeCompare(self.player.currentTime, self.player.currentItem.duration) >= 0) {
        [self setCurrentPlaybackTime:0.0];
    }
    [self setCurrentPlaybackRate:1.0];
}
- (void)pause {
    [self setCurrentPlaybackRate:0.0];
}
- (void)stop {
    [self pause];
    [self setCurrentPlaybackTime:0.0];
}

- (RACSignal *)requestThumbnailImageAtInterval:(NSTimeInterval)interval; {
    return [self requestThumbnailImagesAtIntervals:@[@(interval)]];
}
- (RACSignal *)requestThumbnailImagesAtIntervals:(NSArray *)intervals; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.player.currentItem.asset];
        
        [imageGenerator setAppliesPreferredTrackTransform:YES];
        
        __block NSInteger total = intervals.count;
        
        [imageGenerator generateCGImagesAsynchronouslyForTimes:[intervals bk_map:^id(NSNumber *obj) {
            return [NSValue valueWithCMTime:CMTimeMakeWithSeconds(obj.doubleValue, kPreferredTimeScale)];
        }] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
            if (result == AVAssetImageGeneratorFailed) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:image ? [UIImage imageWithCGImage:image] : nil];
                
                if ((--total) == 0) {
                    [subscriber sendCompleted];
                }
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [imageGenerator cancelAllCGImageGeneration];
        }];
    }];
}

- (RACSignal *)periodicTimeObserverWithInterval:(NSTimeInterval)interval; {
    @weakify(self);
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        id retval = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, kPreferredTimeScale) queue:NULL usingBlock:^(CMTime time) {
            @strongify(self);
            [subscriber sendNext:RACTuplePack(self,@(CMTimeGetSeconds(time)))];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.player removeTimeObserver:retval];
        }];
    }] takeUntil:[self rac_willDeallocSignal]] startWith:RACTuplePack(self,@0.0)];
}

- (RACSignal *)boundaryTimeObserverForIntervals:(NSArray *)intervals; {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        id retval = [self.player addBoundaryTimeObserverForTimes:[intervals bk_map:^id(NSNumber *obj) {
            return [NSValue valueWithCMTime:CMTimeMakeWithSeconds(obj.doubleValue, kPreferredTimeScale)];
        }] queue:NULL usingBlock:^{
            @strongify(self);
            [subscriber sendNext:self];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.player removeTimeObserver:retval];
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
}
#pragma mark Properties
- (UIView *)view {
    return self.moviePlayerView;
}
- (UIView *)backgroundView {
    return self.moviePlayerView.backgroundView;
}

- (void)setFullscreen:(BOOL)fullscreen {
    [self setFullscreen:fullscreen animated:NO completion:nil];
}
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated; {
    [self setFullscreen:fullscreen animated:animated completion:nil];
}
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated completion:(void(^)(void))completion; {
    if (_fullscreen == fullscreen) {
        return;
    }
    
    [self willChangeValueForKey:@keypath(self,fullscreen)];
    _fullscreen = fullscreen;
    [self didChangeValueForKey:@keypath(self,fullscreen)];
    
    if (_fullscreen) {
        [[UIViewController BB_viewControllerForPresenting] presentViewController:[[BBMoviePlayerViewController alloc] initWithMoviePlayerController:self] animated:animated completion:^{
            if (completion) {
                completion();
            }
        }];
    }
    else {
        [[UIViewController BB_viewControllerForPresenting] dismissViewControllerAnimated:animated completion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

@dynamic currentPlaybackTime;
- (NSTimeInterval)currentPlaybackTime {
    return CMTimeGetSeconds(self.player.currentTime);
}
- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    [self willChangeValueForKey:@keypath(self,currentPlaybackTime)];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(currentPlaybackTime, kPreferredTimeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimePositiveInfinity];
    
    [self didChangeValueForKey:@keypath(self,currentPlaybackTime)];
}

@dynamic currentPlaybackRate;
- (CGFloat)currentPlaybackRate {
    return self.player.rate;
}
- (void)setCurrentPlaybackRate:(CGFloat)currentPlaybackRate {
    [self willChangeValueForKey:@keypath(self,currentPlaybackRate)];
    
    [self.player setRate:currentPlaybackRate];
    
    [self didChangeValueForKey:@keypath(self,currentPlaybackRate)];
}

- (NSTimeInterval)duration {
    NSTimeInterval retval = CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (isnan(retval)) {
        retval = 0.0;
    }
    
    return retval;
}

@dynamic scalingMode;
- (BBMoviePlayerControllerScalingMode)scalingMode {
    return self.moviePlayerView.contentView.scalingMode;
}
- (void)setScalingMode:(BBMoviePlayerControllerScalingMode)scalingMode {
    [self willChangeValueForKey:@keypath(self,scalingMode)];
    
    [self.moviePlayerView.contentView setScalingMode:scalingMode];
    
    [self didChangeValueForKey:@keypath(self,scalingMode)];
}

@end
