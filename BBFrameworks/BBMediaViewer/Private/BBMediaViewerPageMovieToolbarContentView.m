//
//  BBMediaViewerPageMovieToolbarContentView.m
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

#import "BBMediaViewerPageMovieToolbarContentView.h"
#import "BBMediaViewerPageMovieModel.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"
#import "BBProgressSlider.h"
#import "BBFrameworksMacros.h"
#import "BBFoundationDebugging.h"
#import "BBBlocks.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

@interface BBMediaViewerPageMovieToolbarContentView ()
@property (strong,nonatomic) BBProgressSlider *slider;
@property (strong,nonatomic) UIButton *playPauseButton;

@property (strong,nonatomic) BBMediaViewerPageMovieModel *model;
@end

@implementation BBMediaViewerPageMovieToolbarContentView

- (instancetype)initWithModel:(BBMediaViewerPageMovieModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setSlider:[[BBProgressSlider alloc] initWithFrame:CGRectZero]];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.slider];
    
    [self setPlayPauseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.playPauseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_play"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_player_pause"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self addSubview:self.playPauseButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.slider}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": self.slider}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[slider]-[view]-|" options:0 metrics:nil views:@{@"slider": self.slider, @"view": self.playPauseButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playPauseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    RACSignal *enabledSignal =
    [RACObserve(self.model.player, status)
     map:^id(NSNumber *value) {
         return @(value.integerValue == AVPlayerStatusReadyToPlay);
     }];
    
    RAC(self.slider,enabled) =
    [enabledSignal
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.playPauseButton,enabled) =
    [enabledSignal
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.slider,progressRanges) =
    [[[[RACSignal combineLatest:@[RACObserve(self.model.player.currentItem, duration),
                                  RACObserve(self.model.player.currentItem, loadedTimeRanges)]]
       filter:^BOOL(RACTuple *value) {
           CMTime duration = [value.first CMTimeValue];
           
           return CMTIME_IS_VALID(duration);
       }]
      map:^id(RACTuple *value) {
          RACTupleUnpack(NSValue *durationValue, NSArray<NSValue *> *loadedTimeRanges) = value;
          NSTimeInterval duration = CMTimeGetSeconds(durationValue.CMTimeValue);
          
          return [[loadedTimeRanges BB_map:^id _Nullable(NSValue * _Nonnull object, NSInteger index) {
              CMTimeRange range = object.CMTimeRangeValue;
              NSTimeInterval start = CMTimeGetSeconds(range.start);
              NSTimeInterval end = start + CMTimeGetSeconds(range.duration);
              
              return @[@(start),@(end)];
          }] BB_map:^id _Nullable(NSArray<NSNumber *> * _Nonnull object, NSInteger index) {
              NSTimeInterval start = object.firstObject.floatValue / duration;
              NSTimeInterval end = object.lastObject.floatValue / duration;
              
              return @[@(start),@(end)];
          }];
      }]
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}

@end
