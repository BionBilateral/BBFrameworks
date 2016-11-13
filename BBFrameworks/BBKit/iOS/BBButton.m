//
//  BBButton.m
//  BBFrameworks
//
//  Created by William Towe on 9/26/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBButton.h"
#import "BBFoundationGeometryFunctions.h"
#import "UIColor+BBKitExtensions.h"

static CGFloat const kTitleBrightnessAdjustment = 0.5;

@implementation BBButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.style) {
            case BBButtonStyleRounded:
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:ceil(CGRectGetHeight(self.frame) * 0.5)];
            break;
            case BBButtonStyleDefault:
            [self.layer setMasksToBounds:NO];
            [self.layer setCornerRadius:0.0];
            break;
        default:
            break;
    }
    
    if (self.titleAlignment == BBButtonTitleAlignmentDefault &&
        self.imageAlignment == BBButtonImageAlignmentDefault) {
        
        switch (self.alignment) {
            case BBButtonAlignmentRight: {
                CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
                CGSize imageViewSize = [self.imageView sizeThatFits:CGSizeZero];
                CGRect titleLabelRect = BBCGRectCenterInRectVertically(CGRectMake(self.contentEdgeInsets.left + self.titleEdgeInsets.left, 0, titleLabelSize.width, titleLabelSize.height), self.bounds);
                CGRect imageViewRect = BBCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(titleLabelRect) + self.titleEdgeInsets.right + self.imageEdgeInsets.left, 0, imageViewSize.width, imageViewSize.height), self.bounds);
                
                [self.titleLabel setFrame:titleLabelRect];
                [self.imageView setFrame:imageViewRect];
            }
                break;
            case BBButtonAlignmentCenterVertically: {
                CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
                CGSize imageViewSize = [self.imageView sizeThatFits:CGSizeZero];
                CGRect centerRect = BBCGRectCenterInRect(CGRectMake(0, 0, MAX(titleLabelSize.width, imageViewSize.width), imageViewSize.height + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + titleLabelSize.height), self.bounds);
                CGRect imageViewRect = BBCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMinY(centerRect), imageViewSize.width, imageViewSize.height), centerRect);
                CGRect titleLabelRect = BBCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMaxY(imageViewRect) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top, titleLabelSize.width, titleLabelSize.height), centerRect);
                
                [self.titleLabel setFrame:titleLabelRect];
                [self.imageView setFrame:imageViewRect];
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (self.titleAlignment) {
            case BBButtonTitleAlignmentLeft: {
                CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
                CGRect titleLabelRect = BBCGRectCenterInRectVertically(CGRectMake(self.contentEdgeInsets.left + self.titleEdgeInsets.left, 0, titleLabelSize.width, titleLabelSize.height), self.bounds);
                
                [self.titleLabel setFrame:titleLabelRect];
            }
                break;
            case BBButtonTitleAlignmentRight: {
                CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeZero];
                CGRect titleLabelRect = BBCGRectCenterInRectVertically(CGRectMake(CGRectGetWidth(self.bounds) - titleLabelSize.width - self.contentEdgeInsets.right - self.titleEdgeInsets.right, 0, titleLabelSize.width, titleLabelSize.height), self.bounds);
                
                [self.titleLabel setFrame:titleLabelRect];
            }
                break;
            default:
                break;
        }
        
        switch (self.imageAlignment) {
            case BBButtonImageAlignmentLeft: {
                CGSize imageViewSize = [self.imageView sizeThatFits:CGSizeZero];
                CGRect imageViewRect = BBCGRectCenterInRectVertically(CGRectMake(self.contentEdgeInsets.left - self.imageEdgeInsets.left, 0, imageViewSize.width, imageViewSize.height), self.bounds);
                
                [self.imageView setFrame:imageViewRect];
            }
                break;
            case BBButtonImageAlignmentRight: {
                CGSize imageViewSize = [self.imageView sizeThatFits:CGSizeZero];
                CGRect imageViewRect = BBCGRectCenterInRectVertically(CGRectMake(CGRectGetWidth(self.bounds) - imageViewSize.width - self.contentEdgeInsets.right - self.imageEdgeInsets.right, 0, imageViewSize.width, imageViewSize.height), self.bounds);
                
                [self.imageView setFrame:imageViewRect];
            }
                break;
            default:
                break;
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize retval = [super intrinsicContentSize];
    
    if (self.titleAlignment == BBButtonTitleAlignmentDefault &&
        self.imageAlignment == BBButtonImageAlignmentDefault) {
        
        switch (self.alignment) {
            case BBButtonAlignmentCenterVertically:
                retval.width = self.contentEdgeInsets.left;
                retval.width += self.imageEdgeInsets.left;
                retval.width += self.titleEdgeInsets.left;
                retval.width += MAX([self.imageView sizeThatFits:CGSizeZero].width, [self.titleLabel sizeThatFits:CGSizeZero].width);
                retval.width += self.imageEdgeInsets.right;
                retval.width += self.titleEdgeInsets.right;
                retval.width += self.contentEdgeInsets.right;
                
                retval.height = self.contentEdgeInsets.top;
                retval.height += self.imageEdgeInsets.top;
                retval.height += [self.imageView sizeThatFits:CGSizeZero].height;
                retval.height += self.imageEdgeInsets.bottom;
                retval.height += self.titleEdgeInsets.top;
                retval.height += [self.titleLabel sizeThatFits:CGSizeZero].height;
                retval.height += self.titleEdgeInsets.bottom;
                retval.height += self.contentEdgeInsets.bottom;
                break;
            case BBButtonAlignmentRight:
            default:
                retval.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
                retval.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
                retval.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
                retval.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
                break;
        }
    }
    else {
        retval.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        retval.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        retval.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
        retval.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
    }
    
    return retval;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    
    if (state == UIControlStateNormal) {
        [self setTitleColor:[color BB_colorByAdjustingBrightnessBy:kTitleBrightnessAdjustment] forState:UIControlStateHighlighted];
    }
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state {
    [super setAttributedTitle:title forState:state];
    
    if (state == UIControlStateNormal) {
        if (title.length > 0) {
            UIColor *color = [title attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
            NSMutableAttributedString *temp = [title mutableCopy];
            
            [temp addAttribute:NSForegroundColorAttributeName value:[color BB_colorByAdjustingBrightnessBy:kTitleBrightnessAdjustment] range:NSMakeRange(0, title.length)];
            
            [self setAttributedTitle:temp forState:UIControlStateHighlighted];
        }
    }
}

- (void)setStyle:(BBButtonStyle)style {
    _style = style;
    
    switch (self.style) {
            case BBButtonStyleRounded:
            [self.layer setMasksToBounds:YES];
            break;
            case BBButtonStyleDefault:
            [self.layer setCornerRadius:0.0];
            [self.layer setMasksToBounds:NO];
            break;
        default:
            break;
    }
}
- (void)setAlignment:(BBButtonAlignment)alignment {
    if (_alignment == alignment) {
        return;
    }
    
    _alignment = alignment;
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}
- (void)setTitleAlignment:(BBButtonTitleAlignment)titleAlignment {
    if (_titleAlignment == titleAlignment) {
        return;
    }
    
    _titleAlignment = titleAlignment;
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}
- (void)setImageAlignment:(BBButtonImageAlignment)imageAlignment {
    if (_imageAlignment == imageAlignment) {
        return;
    }
    
    _imageAlignment = imageAlignment;
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

@end
