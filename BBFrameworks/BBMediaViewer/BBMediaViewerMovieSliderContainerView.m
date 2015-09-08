//
//  BBMediaViewerMovieSliderContainerView.m
//  BBFrameworks
//
//  Created by William Towe on 8/11/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerMovieSliderContainerView.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBBlocks.h"
#import "BBKitColorMacros.h"
#import "UIImage+BBKitExtensions.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBFoundationGeometryFunctions.h"
#import "BBProgressSlider.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

static CGFloat const kMarginXY = 8.0;
static CGFloat const kMarginX = 16.0;

@interface BBMediaViewerMovieSliderContainerView ()
@property (strong,nonatomic) BBProgressSlider *slider;

@property (strong,nonatomic) UILabel *timeElapsedLabel;
@property (strong,nonatomic) UILabel *timeRemainingLabel;

@property (strong,nonatomic) UIButton *playPauseButton;
@property (strong,nonatomic) UIButton *fastForwardButton;

@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;
@property (strong,nonatomic) id timeObserver;

@property (strong,nonatomic) NSDateFormatter *timeElapsedDateFormatter;
@property (strong,nonatomic) NSDateFormatter *timeRemainingDateFormatter;

@property (readonly,nonatomic) UIColor *renderColor;
@property (readonly,nonatomic) UIColor *highlightTintColor;

- (void)_updateFastForwardButtonImages;
@end

@implementation BBMediaViewerMovieSliderContainerView

- (void)dealloc {
    [self.viewModel.player removeTimeObserver:self.timeObserver];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [self _updateFastForwardButtonImages];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize timeElapsedLabelSize = [self.timeElapsedLabel sizeThatFits:CGSizeZero];
    CGSize timeRemainingLabelSize = [self.timeRemainingLabel sizeThatFits:CGSizeZero];
    CGFloat sliderHeight = [self.slider sizeThatFits:CGSizeZero].height;
    
    [self.timeElapsedLabel setFrame:CGRectMake(kMarginXY, kMarginXY, timeElapsedLabelSize.width, sliderHeight)];
    [self.timeRemainingLabel setFrame:CGRectMake(CGRectGetWidth(self.bounds) - timeRemainingLabelSize.width - kMarginXY, kMarginXY, timeRemainingLabelSize.width, sliderHeight)];
    [self.slider setFrame:CGRectMake(CGRectGetMaxX(self.timeElapsedLabel.frame) + kMarginXY, kMarginXY, CGRectGetMinX(self.timeRemainingLabel.frame) - CGRectGetMaxX(self.timeElapsedLabel.frame) - kMarginXY - kMarginXY, sliderHeight)];
    
    CGSize playPauseButtonSize = [self.playPauseButton sizeThatFits:CGSizeZero];
    
    [self.playPauseButton setFrame:BBCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMaxY(self.slider.frame) + kMarginXY, playPauseButtonSize.width, playPauseButtonSize.height), self.bounds)];
    
    CGSize fastForwardButtonSize = [self.fastForwardButton sizeThatFits:CGSizeZero];
    
    [self.fastForwardButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(self.playPauseButton.frame) + kMarginX, 0, fastForwardButtonSize.width, fastForwardButtonSize.height), self.playPauseButton.frame)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, kMarginXY + [self.slider sizeThatFits:size].height + kMarginXY + [self.playPauseButton sizeThatFits:CGSizeZero].height + kMarginXY);
}

- (instancetype)initWithViewModel:(BBMediaViewerDetailViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setViewModel:viewModel];
    
    [self setPlayPauseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.playPauseButton setAdjustsImageWhenHighlighted:NO];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_play"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[[self.playPauseButton imageForState:UIControlStateNormal] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_pause"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateSelected];
    [self.playPauseButton setImage:[[self.playPauseButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.playPauseButton setRac_command:self.viewModel.playPauseCommand];
    [self.playPauseButton sizeToFit];
    [self addSubview:self.playPauseButton];
    
    [self setFastForwardButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.fastForwardButton setAdjustsImageWhenHighlighted:NO];
    [self.fastForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_fast_forward"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.fastForwardButton setImage:[[self.fastForwardButton imageForState:UIControlStateNormal] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.fastForwardButton setRac_command:self.viewModel.fastForwardCommand];
    [self.fastForwardButton sizeToFit];
    [self addSubview:self.fastForwardButton];
    
    [self setSlider:[[BBProgressSlider alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.slider];
    
    UIColor *textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    [self setTimeElapsedLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeElapsedLabel setTextColor:textColor];
    [self.timeElapsedLabel setFont:font];
    [self addSubview:self.timeElapsedLabel];
    
    [self setTimeRemainingLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeRemainingLabel setTextColor:textColor];
    [self.timeRemainingLabel setFont:font];
    [self addSubview:self.timeRemainingLabel];
    
    [self setTimeElapsedDateFormatter:[[NSDateFormatter alloc] init]];
    
    [self setTimeRemainingDateFormatter:[[NSDateFormatter alloc] init]];
    
    @weakify(self);
    
    RAC(self.playPauseButton,selected) = [RACObserve(self.viewModel.player, rate)
                                          map:^id(NSNumber *value) {
                                              return @(value.floatValue != BBMediaViewerDetailViewModelMoviePausePlaybackRate);
                                          }];
    
    RAC(self.fastForwardButton,selected) = [RACObserve(self.viewModel.player, rate)
                                            map:^id(NSNumber *value) {
                                                return @(value.floatValue == BBMediaViewerDetailViewModelMovieFastForwardPlaybackRate);
                                            }];
    
    [[RACObserve(self.viewModel.player.currentItem, loadedTimeRanges)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *value) {
         if (value.count > 0) {
             NSValue *timeRange = [value BB_reduceWithStart:[NSValue valueWithCMTimeRange:kCMTimeRangeZero] block:^id(NSValue *sum, NSValue *object, NSInteger index) {
                 return [NSValue valueWithCMTimeRange:CMTimeRangeGetUnion(sum.CMTimeRangeValue, object.CMTimeRangeValue)];
             }];
             
             [self.slider setProgress:CMTimeGetSeconds(CMTimeRangeGetEnd(timeRange.CMTimeRangeValue)) / self.viewModel.duration];
         }
         else {
             [self.slider setProgress:0.0];
         }
     }];
    
    [[self.slider
     rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.viewModel seekToTimeInterval:self.viewModel.duration * self.slider.value];
     }];
    
    void(^timeObserverBlock)(CMTime) = ^(CMTime time){
        @strongify(self);
        NSDateComponents *elapsedTimeDateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:CMTimeGetSeconds(time)] options:0];
        NSDate *elapsedTimeDate = [[NSCalendar currentCalendar] dateFromComponents:elapsedTimeDateComps];
        NSDateComponents *remainingTimeDateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate dateWithTimeIntervalSinceNow:CMTimeGetSeconds(time)] toDate:[NSDate dateWithTimeIntervalSinceNow:self.viewModel.duration] options:0];
        NSDate *remainingTimeDate = [[NSCalendar currentCalendar] dateFromComponents:remainingTimeDateComps];
        
        if (elapsedTimeDateComps.hour > 0) {
            [self.timeElapsedDateFormatter setDateFormat:@"H:mm:ss"];
        }
        else {
            [self.timeElapsedDateFormatter setDateFormat:@"m:ss"];
        }
        
        if (remainingTimeDateComps.hour > 0) {
            [self.timeRemainingDateFormatter setDateFormat:@"-H:mm:ss"];
        }
        else {
            [self.timeRemainingDateFormatter setDateFormat:@"-m:ss"];
        }
        
        [self.timeElapsedLabel setText:[self.timeElapsedDateFormatter stringFromDate:elapsedTimeDate]];
        [self.timeRemainingLabel setText:[self.timeRemainingDateFormatter stringFromDate:remainingTimeDate]];
        
        if (!self.slider.isTracking) {
            [self.slider setValue:CMTimeGetSeconds(time) / self.viewModel.duration];
        }
        
        [self setNeedsLayout];
    };
    
    [[RACObserve(self.viewModel.player.currentItem, duration)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSValue *value) {
         @strongify(self);
         timeObserverBlock(self.viewModel.player.currentTime);
     }];
    
    [self setTimeObserver:[self.viewModel.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, 1) queue:NULL usingBlock:^(CMTime time) {
        timeObserverBlock(time);
    }]];
    
    timeObserverBlock(kCMTimeZero);
    
    return self;
}

- (void)_updateFastForwardButtonImages; {
    [self.fastForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_fast_forward"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.fastForwardButton setImage:[[self.fastForwardButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (UIColor *)renderColor {
    return [UIColor whiteColor];
}
- (UIColor *)highlightTintColor {
    return BBColorWA(0.0, 0.33);
}

@end
