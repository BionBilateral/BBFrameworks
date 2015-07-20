//
//  FormTableViewHeaderView.m
//  BBFrameworks
//
//  Created by William Towe on 7/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "FormTableViewHeaderView.h"
#import "BBFormField.h"

@interface FormTableViewHeaderView ()
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *titleLabel;
@end

@implementation FormTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithReuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithImage:({
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
        
        [[UIColor darkGrayColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 22, 22)] fill];
        
        UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        retval;
    })]];
    [self.contentView addSubview:self.imageView];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.titleLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(self.layoutMargins.left, self.layoutMargins.top, self.imageView.image.size.width, self.imageView.image.size.height)];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 8.0, 0, CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(self.imageView.frame) - 16.0, CGRectGetHeight(self.contentView.bounds))];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeMake(size.width, 0);
    
    retval.height += self.layoutMargins.top;
    retval.height += self.imageView.image.size.height;
    retval.height += self.layoutMargins.bottom;
    
    return retval;
}

- (void)setFormField:(BBFormField *)formField {
    _formField = formField;
    
    [self.titleLabel setText:formField.titleHeader];
}

@end
