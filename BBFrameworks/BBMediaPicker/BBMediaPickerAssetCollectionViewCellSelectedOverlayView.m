//
//  BBMediaPickerAssetCollectionViewCellSelectedOverlayView.m
//  BBFrameworks
//
//  Created by William Towe on 8/7/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionViewCellSelectedOverlayView.h"
#import "BBFoundationGeometryFunctions.h"
#import "BBKitColorMacros.h"

@interface BBMediaPickerAssetCollectionViewCellSelectedOverlayView ()
@property (strong,nonatomic) UIImageView *checkmarkImageView;

+ (UIColor *)_defaultSelectedOverlayForegroundColor;
+ (UIColor *)_defaultSelectedOverlayBackgroundColor;

- (UIImage *)_selectedCheckmarkImage;
@end

@implementation BBMediaPickerAssetCollectionViewCellSelectedOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _selectedOverlayForegroundColor = [self.class _defaultSelectedOverlayForegroundColor];
    _selectedOverlayBackgroundColor = [self.class _defaultSelectedOverlayBackgroundColor];
    
    [self setBackgroundColor:_selectedOverlayBackgroundColor];
    
    [self setCheckmarkImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.checkmarkImageView];
    
    return self;
}

- (void)layoutSubviews {
    [self.checkmarkImageView setFrame:CGRectMake(CGRectGetWidth(self.bounds) - self.checkmarkImageView.image.size.width - 4.0, 4.0, self.checkmarkImageView.image.size.width, self.checkmarkImageView.image.size.height)];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
    [self.checkmarkImageView setImage:highlighted ? [self _selectedCheckmarkImage] : nil];
    
    if (_highlighted) {
        [self setNeedsLayout];
    }
}

- (void)setSelectedOverlayForegroundColor:(UIColor *)selectedOverlayForegroundColor {
    _selectedOverlayForegroundColor = selectedOverlayForegroundColor ?: [self.class _defaultSelectedOverlayForegroundColor];
    
    if (self.isHighlighted) {
        [self.checkmarkImageView setImage:[self _selectedCheckmarkImage]];
    }
}
- (void)setSelectedOverlayTintColor:(UIColor *)selectedOverlayTintColor {
    _selectedOverlayTintColor = selectedOverlayTintColor;
    
    if (self.isHighlighted) {
        [self.checkmarkImageView setImage:[self _selectedCheckmarkImage]];
    }
}
- (void)setSelectedOverlayBackgroundColor:(UIColor *)selectedOverlayBackgroundColor {
    _selectedOverlayBackgroundColor = selectedOverlayBackgroundColor ?: [self.class _defaultSelectedOverlayBackgroundColor];
    
    [self setBackgroundColor:_selectedOverlayBackgroundColor];
}

+ (UIColor *)_defaultSelectedOverlayForegroundColor {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultSelectedOverlayBackgroundColor; {
    return BBColorWA(1.0, 0.33);
}

- (UIImage *)_selectedCheckmarkImage; {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
    
    CGRect rect = CGRectMake(0, 0, 22, 22);
    
    [self.selectedOverlayForegroundColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
    
    [self.selectedOverlayTintColor ?: self.tintColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, 1, 1)] fill];
    
    NSString *string = @"✓";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName: self.selectedOverlayForegroundColor};
    CGSize size = [string sizeWithAttributes:attributes];
    
    [string drawInRect:BBCGRectCenterInRect(CGRectMake(0, 0, size.width, size.height), rect) withAttributes:attributes];
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}

@end
