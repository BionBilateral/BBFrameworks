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
@property (strong,nonatomic) UILabel *timeElapsedLabel;
@property (strong,nonatomic) UILabel *timeRemainingLabel;
@property (strong,nonatomic) BBProgressSlider *slider;
@property (strong,nonatomic) UIButton *playPauseButton;
@property (strong,nonatomic) UIButton *slowForwardButton;
@property (strong,nonatomic) UIButton *fastForwardButton;

@property (strong,nonatomic) NSDateComponentsFormatter *timeElapsedDateFormatter;
@property (strong,nonatomic) NSDateComponentsFormatter *timeRemainingDateFormatter;
@property (strong,nonatomic) NSNumberFormatter *numberFormatter;

@property (strong,nonatomic) BBMediaViewerPageMovieModel *model;
@end

@implementation BBMediaViewerPageMovieToolbarContentView

- (instancetype)initWithModel:(BBMediaViewerPageMovieModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setTimeElapsedDateFormatter:[[NSDateComponentsFormatter alloc] init]];
    [self.timeElapsedDateFormatter setZeroFormattingBehavior:NSDateComponentsFormatterZeroFormattingBehaviorPad];
    
    [self setTimeRemainingDateFormatter:[[NSDateComponentsFormatter alloc] init]];
    [self.timeRemainingDateFormatter setZeroFormattingBehavior:NSDateComponentsFormatterZeroFormattingBehaviorPad];
    
    [self setNumberFormatter:[[NSNumberFormatter alloc] init]];
    
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    [self setTimeElapsedLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeElapsedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.timeElapsedLabel setFont:font];
    [self.timeElapsedLabel setText:self.numberFormatter.positiveInfinitySymbol];
    [self addSubview:self.timeElapsedLabel];
    
    [self setTimeRemainingLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.timeRemainingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.timeRemainingLabel setFont:font];
    [self.timeRemainingLabel setText:self.numberFormatter.negativeInfinitySymbol];
    [self addSubview:self.timeRemainingLabel];
    
    [self setSlider:[[BBProgressSlider alloc] initWithFrame:CGRectZero]];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.slider];
    
    [self setPlayPauseButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.playPauseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_play"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_pause"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.playPauseButton setRac_command:self.model.playPauseCommand];
    [self addSubview:self.playPauseButton];
    
    [self setSlowForwardButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.slowForwardButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slowForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_forward"] BB_imageByRenderingWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.slowForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_slow_forward"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateSelected];
    [self.slowForwardButton setRac_command:self.model.slowForwardCommand];
    [self addSubview:self.slowForwardButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.timeElapsedLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeElapsedLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.slider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-|" options:0 metrics:nil views:@{@"view": self.timeRemainingLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeRemainingLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.slider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[left]-[view]-[right]" options:0 metrics:nil views:@{@"view": self.slider, @"left": self.timeElapsedLabel, @"right": self.timeRemainingLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": self.slider}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[slider]-[view]-|" options:0 metrics:nil views:@{@"slider": self.slider, @"view": self.playPauseButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playPauseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-[view]" options:0 metrics:nil views:@{@"view": self.slowForwardButton, @"button": self.playPauseButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slowForwardButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.playPauseButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    RAC(self.slider,enabled) =
    [self.model.enabledSignal
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.playPauseButton,selected) =
    [[RACObserve(self.model, currentPlaybackRate)
      map:^id(NSNumber *value) {
          return @(value.floatValue != BBMediaViewerPageMovieModelRatePause);
      }]
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.slowForwardButton,selected) =
    [[RACObserve(self.model, currentPlaybackRate)
      map:^id(NSNumber *value) {
          return @(value.floatValue == BBMediaViewerPageMovieModelRateSlowForward);
      }]
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.slider,progressRanges) =
    [[[self.model.enabledSignal
       ignore:@NO]
       flattenMap:^RACStream *(id value) {
           return [[RACSignal combineLatest:@[RACObserve(self.model.player.currentItem, duration),
                                              RACObserve(self.model.player.currentItem, loadedTimeRanges)]]
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
                   }];
       }]
     deliverOn:[RACScheduler mainThreadScheduler]];
    
    BBWeakify(self);
    [[[[self.model.enabledSignal
       ignore:@NO]
       flattenMap:^RACStream *(id _) {
           BBStrongify(self);
           return [self.model periodicTimeObserverWithIntervalSignal:0.2];
       }]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         if (value.doubleValue > 3600) {
             [self.timeElapsedDateFormatter setAllowedUnits:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond];
         }
         else {
             [self.timeElapsedDateFormatter setAllowedUnits:NSCalendarUnitMinute|NSCalendarUnitSecond];
         }
         
         if (self.model.duration - value.doubleValue > 3600) {
             [self.timeRemainingDateFormatter setAllowedUnits:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond];
         }
         else {
             [self.timeRemainingDateFormatter setAllowedUnits:NSCalendarUnitMinute|NSCalendarUnitSecond];
         }
         
         [self.timeElapsedLabel setText:[self.timeElapsedDateFormatter stringFromTimeInterval:value.doubleValue]];
         [self.timeRemainingLabel setText:[self.numberFormatter.minusSign stringByAppendingString:[self.timeRemainingDateFormatter stringFromTimeInterval:self.model.duration - value.doubleValue]]];
         
         if (!self.slider.isTracking) {
             [self.slider setValue:value.doubleValue / self.model.duration];
         }
     }];
    
    __block float currentPlaybackRate = 0.0;
    
    [[[[[self.slider
         rac_signalForControlEvents:UIControlEventTouchDown]
        map:^id(id _) {
            BBStrongify(self);
            return @(self.model.currentPlaybackRate);
        }]
       flattenMap:^RACStream *(NSNumber *rate) {
           BBStrongify(self);
           return [[[[[[self.slider
                        rac_signalForControlEvents:UIControlEventValueChanged]
                       deliverOn:[RACScheduler mainThreadScheduler]]
                      map:^id(UISlider *slider) {
                          return @(slider.value);
                      }]
                     takeUntil:[[self.slider
                                 rac_signalForControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel]
                                take:1]]
                    initially:^{
                        currentPlaybackRate = rate.floatValue;
                        
                        if (currentPlaybackRate != BBMediaViewerPageMovieModelRatePause) {
                            [self.model pause];
                        }
                    }]
                   finally:^{
                       [self.model setCurrentPlaybackRate:currentPlaybackRate];
                   }];
       }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         [self.model setCurrentPlaybackTime:value.floatValue * self.model.duration];
     }];
    
    return self;
}

@end
