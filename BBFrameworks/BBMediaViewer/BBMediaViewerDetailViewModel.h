//
//  BBMediaViewerModel.h
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

#import <ReactiveViewModel/RVMViewModel.h>
#import <UIKit/UIImage.h>
#import <AVFoundation/AVPlayer.h>
#import "BBMediaViewerMedia.h"

typedef NS_ENUM(NSInteger, BBMediaViewerDetailViewModelType) {
    BBMediaViewerDetailViewModelTypeNone,
    BBMediaViewerDetailViewModelTypeImage,
    BBMediaViewerDetailViewModelTypeMovie,
    BBMediaViewerDetailViewModelTypePlainText
};

@class RACCommand;

@interface BBMediaViewerDetailViewModel : RVMViewModel

@property (readonly,strong,nonatomic) id<BBMediaViewerMedia> media;
@property (readonly,assign,nonatomic) NSInteger index;

@property (readonly,nonatomic) BBMediaViewerDetailViewModelType type;
@property (readonly,nonatomic) NSString *UTI;

@property (readonly,nonatomic) NSURL *URL;
@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) id activityItem;

@property (readonly,nonatomic) UIImage *image;
@property (readonly,nonatomic) UIImage *placeholderImage;

@property (readonly,copy,nonatomic) NSString *text;

@property (readonly,strong,nonatomic) AVPlayer *player;
@property (readonly,nonatomic) NSTimeInterval duration;

@property (readonly,strong,nonatomic) RACCommand *playPauseCommand;

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media index:(NSInteger)index NS_DESIGNATED_INITIALIZER;

- (void)play;
- (void)pause;
- (void)stop;

- (void)seekToTimeInterval:(NSTimeInterval)timeInterval;

@end
