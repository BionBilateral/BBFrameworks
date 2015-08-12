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
#import "BBMediaViewerMovieSlider.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBBlocks.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

@interface BBMediaViewerMovieSliderContainerView ()
@property (strong,nonatomic) BBMediaViewerMovieSlider *slider;

@property (strong,nonatomic) UILabel *timeElapsedLabel;
@property (strong,nonatomic) UILabel *timeRemainingLabel;

@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;
@property (strong,nonatomic) id timeObserver;

@property (strong,nonatomic) NSDateFormatter *timeElapsedDateFormatter;
@property (strong,nonatomic) NSDateFormatter *timeRemainingDateFormatter;
@end

@implementation BBMediaViewerMovieSliderContainerView

- (void)dealloc {
    [self.viewModel.player removeTimeObserver:self.timeObserver];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize timeElapsedLabelSize = [self.timeElapsedLabel sizeThatFits:CGSizeZero];
    CGSize timeRemainingLabelSize = [self.timeRemainingLabel sizeThatFits:CGSizeZero];
    
    [self.timeElapsedLabel setFrame:CGRectMake(8.0, 0, timeElapsedLabelSize.width, CGRectGetHeight(self.bounds))];
    [self.timeRemainingLabel setFrame:CGRectMake(CGRectGetWidth(self.bounds) - timeRemainingLabelSize.width - 8.0, 0, timeRemainingLabelSize.width, CGRectGetHeight(self.bounds))];
    [self.slider setFrame:CGRectMake(CGRectGetMaxX(self.timeElapsedLabel.frame) + 8.0, 0, CGRectGetMinX(self.timeRemainingLabel.frame) - CGRectGetMaxX(self.timeElapsedLabel.frame) - 16.0, CGRectGetHeight(self.bounds))];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(225, [self.slider sizeThatFits:size].height);
}

- (instancetype)initWithViewModel:(BBMediaViewerDetailViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self setViewModel:viewModel];
    
    [self setSlider:[[BBMediaViewerMovieSlider alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.slider];
    
    UIColor *textColor = [UIColor blackColor];
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
    [[RACObserve(self.viewModel.player.currentItem, loadedTimeRanges)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *value) {
         NSValue *timeRange = [value BB_reduceWithStart:[NSValue valueWithCMTimeRange:kCMTimeRangeZero] block:^id(NSValue *sum, NSValue *object, NSInteger index) {
             return [NSValue valueWithCMTimeRange:CMTimeRangeGetUnion(sum.CMTimeRangeValue, object.CMTimeRangeValue)];
         }];
         
         [self.slider.progressView setProgress:CMTimeGetSeconds(CMTimeRangeGetEnd(timeRange.CMTimeRangeValue)) / self.viewModel.duration];
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
            [self.timeElapsedDateFormatter setDateFormat:@"HH:mm:ss"];
        }
        else {
            [self.timeElapsedDateFormatter setDateFormat:@"mm:ss"];
        }
        
        if (remainingTimeDateComps.hour > 0) {
            [self.timeRemainingDateFormatter setDateFormat:@"-HH:mm:ss"];
        }
        else {
            [self.timeRemainingDateFormatter setDateFormat:@"-mm:ss"];
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

@end
