//
//  BBDatePickerButton.m
//  BBFrameworks
//
//  Created by William Towe on 7/11/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBDatePickerButton.h"

static NSString *const kDateKey = @"date";
static NSString *const kDateFormatterKey = @"dateFormatter";

static void *kObservingContext = &kObservingContext;

@interface BBDatePickerButton ()
@property (readwrite,retain) UIView *inputView;

@property (strong,nonatomic) UIDatePicker *datePicker;

- (void)_BBDatePickerButtonInit;

+ (NSDate *)_defaultDate;
+ (NSDateFormatter *)_defaultDateFormatter;
@end

@implementation BBDatePickerButton
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [self removeObserver:self forKeyPath:kDateKey context:kObservingContext];
    [self removeObserver:self forKeyPath:kDateFormatterKey context:kObservingContext];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBDatePickerButtonInit];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBDatePickerButtonInit];
    
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kObservingContext) {
        if ([keyPath isEqualToString:kDateKey] ||
            [keyPath isEqualToString:kDateFormatterKey]) {
            
            [self setTitle:[self.dateFormatter stringFromDate:self.date] forState:UIControlStateNormal];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark *** Public Methods ***
#pragma mark Properties
@dynamic date;
- (NSDate *)date {
    return self.datePicker.date;
}
- (void)setDate:(NSDate *)date {
    [self.datePicker setDate:date ?: [self.class _defaultDate]];
}

@dynamic mode;
- (UIDatePickerMode)mode {
    return self.datePicker.datePickerMode;
}
- (void)setMode:(UIDatePickerMode)mode {
    [self.datePicker setDatePickerMode:mode];
}

@dynamic minimumDate;
- (NSDate *)minimumDate {
    return self.datePicker.minimumDate;
}
- (void)setMinimumDate:(NSDate *)minimumDate {
    [self.datePicker setMinimumDate:minimumDate];
}
@dynamic maximumDate;
- (NSDate *)maximumDate {
    return self.datePicker.maximumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate {
    [self.datePicker setMaximumDate:maximumDate];
}

- (void)setDateFormatter:(NSDateFormatter *)dateFormatter {
    _dateFormatter = dateFormatter ?: [self.class _defaultDateFormatter];
}

- (void)_BBDatePickerButtonInit; {
    _dateFormatter = [self.class _defaultDateFormatter];
    
    [self addTarget:self action:@selector(_toggleFirstResponderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setDatePicker:[[UIDatePicker alloc] init]];
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.datePicker addTarget:self action:@selector(_datePickerAction:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker sizeToFit];
    
    [self setInputView:self.datePicker];
    
    [self addObserver:self forKeyPath:kDateKey options:NSKeyValueObservingOptionInitial context:kObservingContext];
    [self addObserver:self forKeyPath:kDateFormatterKey options:0 context:kObservingContext];
}

+ (NSDate *)_defaultDate; {
    return [NSDate date];
}
+ (NSDateFormatter *)_defaultDateFormatter; {
    static NSDateFormatter *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[NSDateFormatter alloc] init];
        
        [kRetval setDateStyle:NSDateFormatterMediumStyle];
        [kRetval setTimeStyle:NSDateFormatterMediumStyle];
    });
    return kRetval;
}

- (IBAction)_datePickerAction:(id)sender {
    [self willChangeValueForKey:kDateKey];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [self didChangeValueForKey:kDateKey];
}
- (IBAction)_toggleFirstResponderAction:(id)sender {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
    else {
        [self becomeFirstResponder];
    }
}

@end
