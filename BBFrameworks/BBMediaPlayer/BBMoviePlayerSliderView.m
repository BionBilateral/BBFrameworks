//
//  BBMoviePlayerSliderView.m
//  BBFrameworks
//
//  Created by William Towe on 6/25/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerSliderView.h"
#import "BBMoviePlayerController.h"
#import "BBMediaPlayerDefines.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static NSTimeInterval const kObserverInterval = 1.0;

@interface BBMoviePlayerSliderView ()
@property (strong,nonatomic) UILabel *elapsedTimeLabel;
@property (strong,nonatomic) UILabel *remainingTimeLabel;
@property (strong,nonatomic) UISlider *slider;

@property (strong,nonatomic) NSDateFormatter *elapsedTimeDateFormatter;
@property (strong,nonatomic) NSDateFormatter *remainingTimeDateFormatter;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerSliderView

- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setMoviePlayerController:moviePlayerController];
    
    NSString *fontTextStyle = UIFontTextStyleFootnote;
    
    [self setElapsedTimeLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.elapsedTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.elapsedTimeLabel setFont:[UIFont preferredFontForTextStyle:fontTextStyle]];
    [self.elapsedTimeLabel setTextColor:[UIColor blackColor]];
    [self.elapsedTimeLabel setText:@"00:00:00"];
    [self addSubview:self.elapsedTimeLabel];
    
    [self setRemainingTimeLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.remainingTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.remainingTimeLabel setFont:[UIFont preferredFontForTextStyle:fontTextStyle]];
    [self.remainingTimeLabel setTextColor:[UIColor blackColor]];
    [self.remainingTimeLabel setText:@"-00:00:00"];
    [self addSubview:self.remainingTimeLabel];
    
    [self setSlider:[[UISlider alloc] initWithFrame:CGRectZero]];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [self.slider setMaximumTrackTintColor:[UIColor blackColor]];
    [self addSubview:self.slider];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics:nil views:@{@"view": self.elapsedTimeLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.elapsedTimeLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|" options:0 metrics:nil views:@{@"view": self.remainingTimeLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.remainingTimeLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label1]-[view]-[label2]" options:0 metrics:@{@"margin": @(BBMediaPlayerSubviewMargin)} views:@{@"label1": self.elapsedTimeLabel, @"view": self.slider, @"label2": self.remainingTimeLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.slider}]];
    
    [self setElapsedTimeDateFormatter:[[NSDateFormatter alloc] init]];
    [self.elapsedTimeDateFormatter setDateFormat:@"H:mm:ss"];
    
    [self setRemainingTimeDateFormatter:[[NSDateFormatter alloc] init]];
    [self.remainingTimeDateFormatter setDateFormat:@"-H:mm:ss"];
    
    @weakify(self);
    [[[[[NSNotificationCenter defaultCenter]
     rac_addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.elapsedTimeLabel setFont:[UIFont preferredFontForTextStyle:fontTextStyle]];
         [self.remainingTimeLabel setFont:[UIFont preferredFontForTextStyle:fontTextStyle]];
     }];
    
    [[[self.moviePlayerController
     periodicTimeObserverWithInterval:kObserverInterval]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *value) {
         @strongify(self);
         
         RACTupleUnpack(BBMoviePlayerController *moviePlayerController, NSNumber *time) = value;
         
         NSCalendarUnit units = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
         NSDate *currentPlaybackTimeDate = [NSDate dateWithTimeIntervalSinceNow:time.doubleValue];
         NSDateComponents *elapsedTimeDateComps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date] toDate:currentPlaybackTimeDate options:0];
         NSDate *elapsedTimeDate = [[NSCalendar currentCalendar] dateFromComponents:elapsedTimeDateComps];
         
         [self.elapsedTimeLabel setText:[self.elapsedTimeDateFormatter stringFromDate:elapsedTimeDate]];
         
         NSDateComponents *remainingTimeDateComps = [[NSCalendar currentCalendar] components:units fromDate:currentPlaybackTimeDate toDate:[NSDate dateWithTimeIntervalSinceNow:moviePlayerController.duration] options:0];
         NSDate *remainingTimeDate = [[NSCalendar currentCalendar] dateFromComponents:remainingTimeDateComps];
         
         [self.remainingTimeLabel setText:[self.remainingTimeDateFormatter stringFromDate:remainingTimeDate]];
         
         if (!self.slider.isTracking) {
             [self.slider setValue:time.doubleValue / moviePlayerController.duration];
         }
     }];
    
    return self;
}

@end
