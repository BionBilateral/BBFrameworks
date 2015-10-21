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
static CGFloat const kMarginX = 24.0;

@interface BBMediaViewerMovieSliderContainerView ()
@property (strong,nonatomic) BBProgressSlider *slider;

@property (strong,nonatomic) UILabel *timeElapsedLabel;
@property (strong,nonatomic) UILabel *timeRemainingLabel;

@property (strong,nonatomic) UIButton *playPauseButton;
@property (strong,nonatomic) UIButton *fastForwardButton;
@property (strong,nonatomic) UIButton *slowForwardButton;
@property (strong,nonatomic) UIButton *fastReverseButton;
@property (strong,nonatomic) UIButton *slowReverseButton;

@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;
@property (strong,nonatomic) id timeObserver;

@property (strong,nonatomic) NSDateFormatter *timeElapsedDateFormatter;
@property (strong,nonatomic) NSDateFormatter *timeRemainingDateFormatter;

@property (readonly,nonatomic) UIColor *renderColor;
@property (readonly,nonatomic) UIColor *highlightTintColor;

- (void)_updateButtonImages;
@end

@implementation BBMediaViewerMovieSliderContainerView

- (void)dealloc {
    [self.viewModel.player removeTimeObserver:self.timeObserver];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [self _updateButtonImages];
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
    
    CGSize slowForwardButtonSize = [self.slowForwardButton sizeThatFits:CGSizeZero];
    
    [self.slowForwardButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(self.playPauseButton.frame) + kMarginX, 0, slowForwardButtonSize.width, slowForwardButtonSize.height), self.playPauseButton.frame)];
    
    CGSize fastForwardButtonSize = [self.fastForwardButton sizeThatFits:CGSizeZero];
    
    [self.fastForwardButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(self.slowForwardButton.frame) + kMarginX, 0, fastForwardButtonSize.width, fastForwardButtonSize.height), self.playPauseButton.frame)];
    
    CGSize slowReverseButtonSize = [self.slowReverseButton sizeThatFits:CGSizeZero];
    
    [self.slowReverseButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(self.playPauseButton.frame) - slowReverseButtonSize.width - kMarginX, 0, slowReverseButtonSize.width, slowReverseButtonSize.height), self.playPauseButton.frame)];
    
    CGSize fastReverseButtonSize = [self.fastReverseButton sizeThatFits:CGSizeZero];
    
    [self.fastReverseButton setFrame:BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(self.slowReverseButton.frame) - fastReverseButtonSize.width - kMarginX, 0, fastReverseButtonSize.width, fastReverseButtonSize.height), self.playPauseButton.frame)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, kMarginXY + [self.slider sizeThatFits:size].height + kMarginXY + [self.playPauseButton sizeThatFits:CGSizeZero].height + kMarginXY + kMarginXY);
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
    
    [self setSlowForwardButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.slowForwardButton setAdjustsImageWhenHighlighted:NO];
    [self.slowForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_forward"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.slowForwardButton setImage:[[self.slowForwardButton imageForState:UIControlStateNormal] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.slowForwardButton setRac_command:self.viewModel.slowForwardCommand];
    [self.slowForwardButton sizeToFit];
    [self addSubview:self.slowForwardButton];
    
    [self setSlowReverseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.slowReverseButton setAdjustsImageWhenHighlighted:NO];
    [self.slowReverseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_reverse"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.slowReverseButton setImage:[[self.slowReverseButton imageForState:UIControlStateNormal] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.slowReverseButton setRac_command:self.viewModel.slowReverseCommand];
    [self.slowReverseButton sizeToFit];
    [self addSubview:self.slowReverseButton];
    
    [self setFastReverseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.fastReverseButton setAdjustsImageWhenHighlighted:NO];
    [self.fastReverseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_fast_reverse"] BB_imageByRenderingWithColor:self.renderColor] forState:UIControlStateNormal];
    [self.fastReverseButton setImage:[[self.fastReverseButton imageForState:UIControlStateNormal] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.fastReverseButton setRac_command:self.viewModel.fastReverseCommand];
    [self.fastReverseButton sizeToFit];
    [self addSubview:self.fastReverseButton];
    
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
    
    RACSignal *rateSignal = RACObserve(self.viewModel.player, rate);
    
    RAC(self.playPauseButton,selected) = [rateSignal
                                          map:^id(NSNumber *value) {
                                              return @(value.floatValue != BBMediaViewerDetailViewModelMoviePausePlaybackRate);
                                          }];
    
    RAC(self.fastForwardButton,selected) = [rateSignal
                                            map:^id(NSNumber *value) {
                                                return @(value.floatValue == BBMediaViewerDetailViewModelMovieFastForwardPlaybackRate);
                                            }];
    
    RAC(self.slowForwardButton,selected) = [rateSignal
                                            map:^id(NSNumber *value) {
                                                return @(value.floatValue == BBMediaViewerDetailViewModelMovieSlowForwardPlaybackRate);
                                            }];
    
    RAC(self.fastReverseButton,selected) = [rateSignal
                                            map:^id(NSNumber *value) {
                                                return @(value.floatValue == BBMediaViewerDetailViewModelMovieFastReversePlaybackRate);
                                            }];
    
    RAC(self.slowReverseButton,selected) = [rateSignal
                                            map:^id(NSNumber *value) {
                                                return @(value.floatValue == BBMediaViewerDetailViewModelMovieSlowReversePlaybackRate);
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
    
    [self setTimeObserver:[self.viewModel.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.2, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        timeObserverBlock(time);
    }]];
    
    timeObserverBlock(kCMTimeZero);
    
    return self;
}

- (void)_updateButtonImages; {
    [self.fastForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_fast_forward"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.fastForwardButton setImage:[[self.fastForwardButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.slowForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_forward"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.slowForwardButton setImage:[[self.slowForwardButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.slowReverseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_reverse"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.slowReverseButton setImage:[[self.slowReverseButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.fastReverseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_fast_reverse"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.fastReverseButton setImage:[[self.fastReverseButton imageForState:UIControlStateSelected] BB_imageByTintingWithColor:self.highlightTintColor] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (UIColor *)renderColor {
    return [UIColor whiteColor];
}
- (UIColor *)highlightTintColor {
    return BBColorWA(0.0, 0.33);
}

@end
