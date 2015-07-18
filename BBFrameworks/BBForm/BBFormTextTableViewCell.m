//
//  BBFormTextTableViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 7/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBFormTextTableViewCell.h"
#import "BBFormField.h"

@interface BBFormTextTableViewCell ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UITextField *textField;

+ (UIColor *)_defaultTextColor;
+ (UIColor *)_defaultCaretColor;
@end

@implementation BBFormTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _textColor = [self.class _defaultTextColor];
    _caretColor = [self.class _defaultCaretColor];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.titleLabel];
    
    [self setTextField:[[UITextField alloc] initWithFrame:CGRectZero]];
    [self.textField setTintColor:_caretColor];
    [self.textField setTextColor:_textColor];
    [self.textField setTextAlignment:NSTextAlignmentRight];
    [self.textField addTarget:self action:@selector(_textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textField];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
    
    [self.titleLabel setFrame:CGRectMake(BBFormTableViewCellPadding, 0, titleLabelSize.width, CGRectGetHeight(self.contentView.bounds))];
    [self.textField setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + BBFormTableViewCellMargin, 0, CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(self.titleLabel.frame) - BBFormTableViewCellMargin - BBFormTableViewCellPadding, CGRectGetHeight(self.contentView.bounds))];
}

- (void)setFormField:(BBFormField *)formField {
    [super setFormField:formField];
    
    [self.titleLabel setText:formField.title];
    
    [self.textField setText:formField.value];
    [self.textField setPlaceholder:formField.placeholder];
    [self.textField setKeyboardType:formField.keyboardType];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor ?: [self.class _defaultTextColor];
    
    [self.textField setTextColor:_textColor];
}
- (void)setCaretColor:(UIColor *)caretColor {
    _caretColor = caretColor ?: [self.class _defaultCaretColor];
    
    BOOL isFirstResponder = self.textField.isFirstResponder;
    
    if (isFirstResponder) {
        [self.textField resignFirstResponder];
    }
    
    [self.textField setTintColor:_caretColor];
    
    if (isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (IBAction)_textFieldAction:(id)sender {
    [self.formField setValue:self.textField.text];
}

+ (UIColor *)_defaultTextColor; {
    return [UIColor blueColor];
}
+ (UIColor *)_defaultCaretColor; {
    return [UIColor blackColor];
}

@end
