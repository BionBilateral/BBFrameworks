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

#import <Archimedes/Archimedes.h>

CGFloat const BBFormTableViewCellMargin = 8.0;

@interface BBFormTableViewCell ()
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subtitleLabel;

+ (UIColor *)_defaultTitleTextColor;
+ (UIColor *)_defaultSubtitleTextColor;
@end

@interface _BBFormTableViewCellLayoutGuide : NSObject <UILayoutSupport>
@property (weak,nonatomic) BBFormTableViewCell *tableViewCell;

- (instancetype)initWithTableViewCell:(BBFormTableViewCell *)tableViewCell;
@end

@implementation _BBFormTableViewCellLayoutGuide

- (CGFloat)length {
    return MAX(CGRectGetMaxX(self.tableViewCell.titleLabel.frame), CGRectGetMaxX(self.tableViewCell.subtitleLabel.frame));
}

- (instancetype)initWithTableViewCell:(BBFormTableViewCell *)tableViewCell; {
    if (!(self = [super init]))
        return nil;
    
    [self setTableViewCell:tableViewCell];
    
    return self;
}

@end

@implementation BBFormTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _titleTextColor = [self.class _defaultTitleTextColor];
    _subtitleTextColor = [self.class _defaultSubtitleTextColor];
    
    [self setIconImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.iconImageView];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextColor:_titleTextColor];
    [self.contentView addSubview:self.titleLabel];
    
    [self setSubtitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.subtitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.subtitleLabel setTextColor:_subtitleTextColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
    
    if (self.subtitleLabel.text.length > 0) {
        CGSize subtitleLabelSize = [self.subtitleLabel sizeThatFits:CGSizeZero];
        CGRect rect = MEDRectCenterInRect(CGRectMake(0, 0, MAX(titleLabelSize.width, subtitleLabelSize.width), titleLabelSize.height + subtitleLabelSize.height), self.contentView.bounds);
        
        if (self.iconImageView.image) {
            CGRect iconRect = MEDRectCenterInRect(CGRectMake(0, 0, self.iconImageView.image.size.width, self.iconImageView.image.size.height), self.contentView.bounds);
            
            iconRect.origin.x = self.layoutMargins.left;
            
            [self.iconImageView setFrame:iconRect];
            
            rect.origin.x = CGRectGetMaxX(self.iconImageView.frame) + BBFormTableViewCellMargin;
        }
        else {
            rect.origin.x = self.layoutMargins.left;
        }
        
        [self.titleLabel setFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), titleLabelSize.height)];
        [self.subtitleLabel setFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(rect), subtitleLabelSize.height)];
    }
    else {
        CGRect rect = CGRectMake(self.layoutMargins.left, 0, titleLabelSize.width, CGRectGetHeight(self.contentView.bounds));
        
        if (self.iconImageView.image) {
            CGRect iconRect = MEDRectCenterInRect(CGRectMake(0, 0, self.iconImageView.image.size.width, self.iconImageView.image.size.height), self.contentView.bounds);
            
            iconRect.origin.x = self.layoutMargins.left;
            
            [self.iconImageView setFrame:iconRect];
            
            rect.origin.x = CGRectGetMaxX(self.iconImageView.frame) + BBFormTableViewCellMargin;
        }
        
        [self.titleLabel setFrame:rect];
    }
}

- (void)setFormField:(BBFormField *)formField {
    _formField = formField;
    
    [self.iconImageView setImage:formField.image];
    [self.titleLabel setText:formField.title];
    [self.subtitleLabel setText:formField.subtitle];
    
    [self setNeedsLayout];
}

- (id<UILayoutSupport>)rightLayoutGuide {
    return [[_BBFormTableViewCellLayoutGuide alloc] initWithTableViewCell:self];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor ?: [self.class _defaultTitleTextColor];
    
    [self.titleLabel setTextColor:_titleTextColor];
}
- (void)setSubtitleTextColor:(UIColor *)subtitleTextColor {
    _subtitleTextColor = subtitleTextColor ?: [self.class _defaultSubtitleTextColor];
    
    [self.subtitleLabel setTextColor:_subtitleTextColor];
}

+ (UIColor *)_defaultTitleTextColor; {
    return [UIColor blackColor];
}
+ (UIColor *)_defaultSubtitleTextColor; {
    return [UIColor darkGrayColor];
}

@end
