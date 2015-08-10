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

@interface BBMediaViewerDetailViewModel ()
@property (readwrite,strong,nonatomic) id<BBMediaViewerMedia> media;
@property (readwrite,assign,nonatomic) NSInteger index;

@property (readwrite,strong,nonatomic) AVPlayer *player;

@property (readwrite,strong,nonatomic) RACCommand *playPauseCommand;
@end

@implementation BBMediaViewerDetailViewModel

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media index:(NSInteger)index {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(media);
    
    [self setMedia:media];
    [self setIndex:index];
    
    return self;
}

- (void)play; {
    [self.player setRate:1.0];
}
- (void)pause; {
    [self.player setRate:0.0];
}
- (void)stop; {
    [self pause];
    [self.player seekToTime:kCMTimeZero];
}

- (BBMediaViewerDetailViewModelType)type {
    NSString *UTI = self.UTI;
    
    if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage)) {
        return BBMediaViewerDetailViewModelTypeImage;
    }
    else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie)) {
        return BBMediaViewerDetailViewModelTypeMovie;
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

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithURL:self.URL];
    }
    return _player;
}

@end
