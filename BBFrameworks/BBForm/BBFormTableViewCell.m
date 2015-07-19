//
//  BBFormTableViewCell.m
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

#import "BBFormTableViewCell.h"
#import "BBFormField.h"

CGFloat const BBFormTableViewCellMargin = 8.0;

@interface BBFormTableViewCell ()
@property (readwrite,strong,nonatomic) UILabel *titleLabel;

+ (UIColor *)_defaultTextColor;
@end

@implementation BBFormTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _textColor = [self.class _defaultTextColor];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextColor:_textColor];
    [self.contentView addSubview:self.titleLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
    
    [self.titleLabel setFrame:CGRectMake(self.layoutMargins.left, 0, titleLabelSize.width, CGRectGetHeight(self.contentView.bounds))];
}

- (void)setFormField:(BBFormField *)formField {
    _formField = formField;
    
    [self.titleLabel setText:formField.title];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor ?: [self.class _defaultTextColor];
    
    [self.titleLabel setTextColor:_textColor];
}

+ (UIColor *)_defaultTextColor; {
    return [UIColor blackColor];
}

@end
