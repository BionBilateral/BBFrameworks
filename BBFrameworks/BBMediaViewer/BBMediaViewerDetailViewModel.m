//
//  BBMediaViewerModel.m
//  BBFrameworks
//
//  Created by William Towe on 8/8/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerDetailViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

float const BBMediaViewerDetailViewModelMovieFastForwardPlaybackRate = 2.0;
float const BBMediaViewerDetailViewModelMovieSlowForwardPlaybackRate = 0.5;
float const BBMediaViewerDetailViewModelMoviePlaybackRate = 1.0;
float const BBMediaViewerDetailViewModelMoviePausePlaybackRate = 0.0;

@interface BBMediaViewerDetailViewModel ()
@property (readwrite,strong,nonatomic) id<BBMediaViewerMedia> media;
@property (readwrite,assign,nonatomic) NSInteger index;

@property (readwrite,copy,nonatomic) NSString *text;

@property (readwrite,strong,nonatomic) AVPlayer *player;

@property (readwrite,strong,nonatomic) RACCommand *playPauseCommand;
@property (readwrite,strong,nonatomic) RACCommand *fastForwardCommand;
@property (readwrite,strong,nonatomic) RACCommand *slowForwardCommand;

- (void)_seekToBeginningOfMovieIfNecessary;
@end

@implementation BBMediaViewerDetailViewModel

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media index:(NSInteger)index {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(media);
    
    [self setMedia:media];
    [self setIndex:index];
    
    if (self.type == BBMediaViewerDetailViewModelTypeMovie) {
        @weakify(self);
        [self setPlayPauseCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
            @strongify(self);
            return [RACSignal return:self];
        }]];
        
        [[[self.playPauseCommand.executionSignals
         concat]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);
             if (self.player.rate == BBMediaViewerDetailViewModelMoviePausePlaybackRate) {
                 [self play];
             }
             else {
                 [self pause];
             }
         }];
        
        [self setFastForwardCommand:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.player.currentItem, canPlayFastForward)] reduce:^id(NSNumber *value){
            return @(value.boolValue);
        }] signalBlock:^RACSignal *(UIButton *input) {
            @strongify(self);
            return [RACSignal return:self];
        }]];
        
        __block NSNumber *playerRate = nil;
        
        [[[self.fastForwardCommand.executionSignals
         concat]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);
             [self _seekToBeginningOfMovieIfNecessary];
             
             if (playerRate) {
                 [self.player setRate:playerRate.floatValue];
                 
                 playerRate = nil;
             }
             else {
                 playerRate = @(self.player.rate);
                 
                 [self.player setRate:BBMediaViewerDetailViewModelMovieFastForwardPlaybackRate];
             }
         }];
        
        [self setSlowForwardCommand:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.player.currentItem, canPlaySlowForward)] reduce:^id(NSNumber *value){
            return @(value.boolValue);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal return:self];
        }]];
        
        [[[self.slowForwardCommand.executionSignals
         concat]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);
             [self _seekToBeginningOfMovieIfNecessary];
             
             if (playerRate) {
                 [self.player setRate:playerRate.floatValue];
                 
                 playerRate = nil;
             }
             else {
                 playerRate = @(self.player.rate);
                 
                 [self.player setRate:BBMediaViewerDetailViewModelMovieSlowForwardPlaybackRate];
             }
         }];
    }
    
    return self;
}

- (void)play; {
    [self _seekToBeginningOfMovieIfNecessary];
    
    [self.player setRate:BBMediaViewerDetailViewModelMoviePlaybackRate];
}
- (void)pause; {
    [self.player setRate:BBMediaViewerDetailViewModelMoviePausePlaybackRate];
}
- (void)stop; {
    [self pause];
    [self seekToTimeInterval:BBMediaViewerDetailViewModelMoviePausePlaybackRate];
}

- (void)seekToTimeInterval:(NSTimeInterval)timeInterval; {
    [self.player seekToTime:CMTimeMakeWithSeconds(timeInterval, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimePositiveInfinity];
}

- (BBMediaViewerDetailViewModelType)type {
    NSString *UTI = self.UTI;
    
    if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage)) {
        return BBMediaViewerDetailViewModelTypeImage;
    }
    else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie)) {
        return BBMediaViewerDetailViewModelTypeMovie;
    }
    else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypePlainText)) {
        return BBMediaViewerDetailViewModelTypePlainText;
    }
    return BBMediaViewerDetailViewModelTypeNone;
}
- (NSString *)UTI {
    return (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)self.URL.lastPathComponent.pathExtension, NULL);
}

- (NSURL *)URL {
    return [self.media mediaURL];
}
- (NSString *)title {
    return [self.media respondsToSelector:@selector(mediaTitle)] ? [self.media mediaTitle] : [self.media mediaURL].lastPathComponent;
}
- (id)activityItem {
    switch (self.type) {
        case BBMediaViewerDetailViewModelTypeImage:
            return self.image;
        case BBMediaViewerDetailViewModelTypeMovie:
            return self.URL;
        case BBMediaViewerDetailViewModelTypePlainText:
            return self.text;
        default:
            return nil;
    }
}

- (UIImage *)image {
    if ([self.media respondsToSelector:@selector(mediaImage)]) {
        return [self.media mediaImage];
    }
    return nil;
}
- (UIImage *)placeholderImage {
    if ([self.media respondsToSelector:@selector(mediaPlaceholderImage)]) {
        return [self.media mediaPlaceholderImage];
    }
    return nil;
}

- (NSString *)text {
    if (!_text) {
        _text = [NSString stringWithContentsOfURL:self.URL encoding:NSUTF8StringEncoding error:NULL];
    }
    return _text;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithURL:self.URL];
        
        [_player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
    }
    return _player;
}
- (NSTimeInterval)duration {
    NSTimeInterval retval = CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (isnan(retval)) {
        retval = 0.0;
    }
    
    return retval;
}

- (void)_seekToBeginningOfMovieIfNecessary; {
    if (CMTIME_IS_VALID(self.player.currentItem.duration) &&
        CMTimeCompare(self.player.currentTime, self.player.currentItem.duration) >= 0) {
        [self seekToTimeInterval:0.0];
    }
}

@end
