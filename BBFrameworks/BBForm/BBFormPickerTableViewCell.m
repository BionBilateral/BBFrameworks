//
//  BBFormPickerTableViewCell.m
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

#import "BBFormPickerTableViewCell.h"
#import "BBPickerButton.h"
#import "BBFormField.h"

@interface BBFormPickerTableViewCell () <BBPickerButtonDataSource,BBPickerButtonDelegate>
@property (strong,nonatomic) BBPickerButton *pickerButton;

+ (UIColor *)_pickerTextColor;
@end

@implementation BBFormPickerTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _pickerTextColor = [self.class _pickerTextColor];
    
    [self setPickerButton:[[BBPickerButton alloc] initWithFrame:CGRectZero]];
    [self.pickerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.pickerButton setTitleColor:_pickerTextColor forState:UIControlStateNormal];
    [self.pickerButton setDataSource:self];
    [self.pickerButton setDelegate:self];
    [self.contentView addSubview:self.pickerButton];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    id<UILayoutSupport> guide = self.rightLayoutGuide;
    
    [self.pickerButton setFrame:CGRectMake([guide length] + BBFormTableViewCellMargin, 0, CGRectGetWidth(self.contentView.bounds) - [guide length] - BBFormTableViewCellMargin - self.layoutMargins.right, CGRectGetHeight(self.contentView.bounds))];
}
#pragma mark BBPickerButtonDataSource
- (NSInteger)numberOfComponentsInPickerButton:(BBPickerButton *)pickerButton {
    return self.formField.pickerColumnsAndRows ? self.formField.pickerColumnsAndRows.count : 1;
}
- (NSInteger)pickerButton:(BBPickerButton *)pickerButton numberOfRowsInComponent:(NSInteger)component {
    return self.formField.pickerColumnsAndRows ? [self.formField.pickerColumnsAndRows[component] count] : self.formField.pickerRows.count;
}
- (NSString *)pickerButton:(BBPickerButton *)pickerButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id retval = self.formField.pickerColumnsAndRows ? self.formField.pickerColumnsAndRows[component][row] : self.formField.pickerRows[row];
    
    return [retval description];
}
#pragma mark BBPickerButtonDelegate
- (void)pickerButton:(BBPickerButton *)pickerButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.formField setValue:self.formField.pickerColumnsAndRows ? self.formField.pickerColumnsAndRows[component][row] : self.formField.pickerRows[row]];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setFormField:(BBFormField *)formField {
    [super setFormField:formField];
    
    [self.pickerButton reloadData];
    
    if (formField.pickerColumnsAndRows) {
        // formField.value is expected to be an indexed collection with currently selected values
        for (NSInteger i=0; i<formField.pickerColumnsAndRows.count; i++) {
            [self.pickerButton selectRow:[formField.pickerColumnsAndRows[i] indexOfObject:formField.value[i]] inComponent:i];
        }
    }
    else {
        [self.pickerButton selectRow:[formField.pickerRows indexOfObject:formField.value] inComponent:0];
    }
}

- (void)setPickerTextColor:(UIColor *)pickerTextColor {
    _pickerTextColor = pickerTextColor ?: [self.class _pickerTextColor];
    
    [self.pickerButton setTitleColor:_pickerTextColor forState:UIControlStateNormal];
}
#pragma mark *** Private Methods ***
+ (UIColor *)_pickerTextColor; {
    return [UIColor blueColor];
}

@end
