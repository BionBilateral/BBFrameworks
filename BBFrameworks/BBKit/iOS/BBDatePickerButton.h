//
//  BBDatePickerButton.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 BBDatePickerButton is a UIButton subclass that can become first responder and uses a UIDatePickerView as its input view. Tapping on a BBDatePickerButton will toggle its first responder status.
 */
@interface BBDatePickerButton : UIButton

/**
 Set and get the date of the receiver.
 
 The default is [NSDate date].
 */
@property (copy,nonatomic,nullable) NSDate *date;

/**
 Set and get the mode used by the managed date picker view.
 
 The default is UIDatePickerModeDateAndTime.
 */
@property (assign,nonatomic) UIDatePickerMode mode;

/**
 Set and get the minimum date of the managed date picker view.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSDate *minimumDate;
/**
 Set and get the maximum date of the managed date picker view.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSDate *maximumDate;

/**
 Set and get the date formatter used to format the date of the receiver for display.
 
 The default is a NSDateFormatter with date style and time style set to NSDateFormatterMediumStyle.
 */
@property (strong,nonatomic,nullable) NSDateFormatter *dateFormatter UI_APPEARANCE_SELECTOR;

/**
 Redefine input accessory view as readwrite.
 */
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputAccessoryView;

@end

NS_ASSUME_NONNULL_END
