//
//  BBFormDatePickerTableViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 7/18/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBFormDatePickerTableViewCell.h"
#import "BBDatePickerButton.h"
#import "BBFormField.h"

@interface BBFormDatePickerTableViewCell ()
@property (strong,nonatomic) BBDatePickerButton *datePickerButton;

+ (UIColor *)_defaultDatePickerTextColor;
@end

@implementation BBFormDatePickerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _datePickerTextColor = [self.class _defaultDatePickerTextColor];
    
    [self setDatePickerButton:[[BBDatePickerButton alloc] initWithFrame:CGRectZero]];
    [self.datePickerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.datePickerButton setTitleColor:_datePickerTextColor forState:UIControlStateNormal];
    [self.datePickerButton addTarget:self action:@selector(_datePickerButtonAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.datePickerButton];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.datePickerButton setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + BBFormTableViewCellMargin, 0, CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(self.titleLabel.frame) - BBFormTableViewCellMargin - self.layoutMargins.right, CGRectGetHeight(self.contentView.bounds))];
}

- (void)setFormField:(BBFormField *)formField {
    [super setFormField:formField];
    
    [self.datePickerButton setMode:formField.datePickerMode];
    if (formField.dateFormatter) {
        [self.datePickerButton setDateFormatter:formField.dateFormatter];
    }
    [self.datePickerButton setDate:formField.value];
}

- (void)setDatePickerTextColor:(UIColor *)datePickerTextColor {
    _datePickerTextColor = datePickerTextColor ?: [self.class _defaultDatePickerTextColor];
    
    [self.datePickerButton setTitleColor:_datePickerTextColor forState:UIControlStateNormal];
}

+ (UIColor *)_defaultDatePickerTextColor {
    return [UIColor blueColor];
}

- (IBAction)_datePickerButtonAction:(id)sender {
    [self.formField setValue:self.datePickerButton.date];
}

@end
