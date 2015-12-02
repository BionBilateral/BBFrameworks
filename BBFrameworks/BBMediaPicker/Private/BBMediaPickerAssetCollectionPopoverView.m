//
//  BBMediaPickerAssetCollectionPopoverView.m
//  BBFrameworks
//
//  Created by William Towe on 11/20/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionPopoverView.h"
#import "BBMediaPickerTheme.h"
#import "BBFoundationGeometryFunctions.h"

@interface BBMediaPickerAssetCollectionPopoverView ()
@property (strong,nonatomic) UIColor *popoverBackgroundColor;
@property (assign,nonatomic) CGFloat popoverArrowWidth;
@property (assign,nonatomic) CGFloat popoverArrowHeight;
@property (assign,nonatomic) CGFloat popoverCornerRadius;

- (CGRect)_arrowRectForBounds:(CGRect)bounds;
- (CGRect)_backgroundRectForBounds:(CGRect)bounds;
@end

@implementation BBMediaPickerAssetCollectionPopoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect backgroundRect = [self _backgroundRectForBounds:self.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backgroundRect cornerRadius:self.popoverCornerRadius];
    
    [self.popoverBackgroundColor setFill];
    
    [path fill];
    
    CGRect arrowRect = [self _arrowRectForBounds:self.bounds];
    
    path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMinY(arrowRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMaxY(arrowRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
    
    [self.popoverBackgroundColor setFill];
    
    [path fill];
}

- (void)layoutSubviews {
    [self.contentView setFrame:[self _backgroundRectForBounds:self.bounds]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeMake(size.width, 0);
    
    retval.height += self.popoverArrowHeight;
    retval.height += [self.contentView sizeThatFits:CGSizeMake(retval.width, CGFLOAT_MAX)].height;
    
    return retval;
}

- (void)setTheme:(BBMediaPickerTheme *)theme {
    _theme = theme;
    
    [self setPopoverBackgroundColor:_theme.assetCollectionPopoverBackgroundColor];
    [self setPopoverArrowWidth:_theme.assetCollectionPopoverArrowWidth];
    [self setPopoverArrowHeight:_theme.assetCollectionPopoverArrowHeight];
    [self setPopoverCornerRadius:_theme.assetCollectionPopoverCornerRadius];
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    if (_contentView) {
        [self addSubview:_contentView];
    }
}

- (CGRect)_arrowRectForBounds:(CGRect)bounds; {
    return BBCGRectCenterInRectHorizontally(CGRectMake(0, 0, self.popoverArrowWidth, self.popoverArrowHeight), bounds);
}
- (CGRect)_backgroundRectForBounds:(CGRect)bounds; {
    CGRect arrowRect = [self _arrowRectForBounds:bounds];
    
    return CGRectMake(0, CGRectGetMaxY(arrowRect), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(arrowRect));
}

@end
