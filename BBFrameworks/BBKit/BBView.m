//
//  BBView.m
//  BBFrameworks
//
//  Created by William Towe on 6/27/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBView.h"

@interface BBView ()
+ (CGFloat)_defaultBorderWidth;
#if (TARGET_OS_IPHONE)
@property (strong,nonatomic) UIView *topBorderView, *leftBorderView, *bottomBorderView, *rightBorderView;

+ (UIColor *)_defaultBorderColor;
#else
+ (NSColor *)_defaultBorderColor;
#endif

- (void)_BBViewInit;
@end

@implementation BBView

#if (TARGET_OS_IPHONE)
- (instancetype)initWithFrame:(CGRect)frame {
#else
- (instancetype)initWithFrame:(NSRect)frame {
#endif
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBViewInit];
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (!(self = [super initWithCoder:coder]))
        return nil;
    
    [self _BBViewInit];
    
    return self;
}

#if (TARGET_OS_IPHONE)
- (void)didAddSubview:(UIView *)subview {
    if (subview == self.topBorderView ||
        subview == self.leftBorderView ||
        subview == self.bottomBorderView ||
        subview == self.rightBorderView) {
        
        [subview setBackgroundColor:self.borderColor];
    }
    
    [self bringSubviewToFront:self.topBorderView];
    [self bringSubviewToFront:self.leftBorderView];
    [self bringSubviewToFront:self.bottomBorderView];
    [self bringSubviewToFront:self.rightBorderView];
}
    
- (void)layoutSubviews {
    [self.topBorderView setFrame:CGRectMake(self.borderEdgeInsets.left, self.borderEdgeInsets.top, CGRectGetWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth)];
    [self.leftBorderView setFrame:CGRectMake(self.borderEdgeInsets.left, self.borderEdgeInsets.top, self.borderWidth, CGRectGetHeight(self.bounds) - self.borderEdgeInsets.top - self.borderEdgeInsets.bottom)];
    [self.bottomBorderView setFrame:CGRectMake(self.borderEdgeInsets.left, CGRectGetHeight(self.bounds) - self.borderWidth - self.borderEdgeInsets.bottom, CGRectGetWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth)];
    [self.rightBorderView setFrame:CGRectMake(CGRectGetWidth(self.bounds) - self.borderWidth - self.borderEdgeInsets.right, self.borderEdgeInsets.top, self.borderWidth, CGRectGetHeight(self.bounds) - self.borderEdgeInsets.top - self.borderEdgeInsets.bottom)];
}
#else
- (BOOL)isOpaque {
    return NO;
}
- (void)drawRect:(NSRect)dirtyRect {
    if (self.backgroundColor) {
        [self.backgroundColor setFill];
        NSRectFill(self.bounds);
    }
    
    if (self.borderOptions & BBViewBorderOptionsTop) {
        [self.borderColor setFill];
        if (self.isFlipped) {
            NSRectFill(NSMakeRect(self.borderEdgeInsets.left, self.borderEdgeInsets.top, NSWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth));
        }
        else {
            NSRectFill(NSMakeRect(self.borderEdgeInsets.left, NSMaxY(self.bounds) - self.borderWidth, NSWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth));
        }
    }
    
    if (self.borderOptions & BBViewBorderOptionsLeft) {
        [self.borderColor setFill];
        NSRectFill(NSMakeRect(self.borderEdgeInsets.left, self.borderEdgeInsets.top, self.borderWidth, NSHeight(self.bounds) - self.borderEdgeInsets.top - self.borderEdgeInsets.bottom));
    }
    
    if (self.borderOptions & BBViewBorderOptionsBottom) {
        [self.borderColor setFill];
        if (self.isFlipped) {
            NSRectFill(NSMakeRect(self.borderEdgeInsets.left, NSMaxY(self.bounds) - self.borderWidth - self.borderEdgeInsets.bottom, NSWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth));
        }
        else {
            NSRectFill(NSMakeRect(self.borderEdgeInsets.left, self.borderEdgeInsets.bottom, NSWidth(self.bounds) - self.borderEdgeInsets.left - self.borderEdgeInsets.right, self.borderWidth));
        }
    }
    
    if (self.borderOptions & BBViewBorderOptionsRight) {
        [self.borderColor setFill];
        NSRectFill(NSMakeRect(NSMaxX(self.bounds) - self.borderWidth - self.borderEdgeInsets.right, self.borderEdgeInsets.top, self.borderWidth, NSHeight(self.bounds) - self.borderEdgeInsets.top - self.borderEdgeInsets.bottom));
    }
}
#endif

- (void)setBorderOptions:(BBViewBorderOptions)borderOptions {
    _borderOptions = borderOptions;
    
#if (TARGET_OS_IPHONE)
    if (_borderOptions & BBViewBorderOptionsTop) {
        if (!self.topBorderView) {
            [self setTopBorderView:[[UIView alloc] initWithFrame:CGRectZero]];
            [self addSubview:self.topBorderView];
        }
    }
    else {
        [self.topBorderView removeFromSuperview];
        [self setTopBorderView:nil];
    }
    
    if (_borderOptions & BBViewBorderOptionsLeft) {
        if (!self.leftBorderView) {
            [self setLeftBorderView:[[UIView alloc] initWithFrame:CGRectZero]];
            [self addSubview:self.leftBorderView];
        }
    }
    else {
        [self.leftBorderView removeFromSuperview];
        [self setLeftBorderView:nil];
    }
    
    if (_borderOptions & BBViewBorderOptionsBottom) {
        if (!self.bottomBorderView) {
            [self setBottomBorderView:[[UIView alloc] initWithFrame:CGRectZero]];
            [self addSubview:self.bottomBorderView];
        }
    }
    else {
        [self.bottomBorderView removeFromSuperview];
        [self setBottomBorderView:nil];
    }
    
    if (_borderOptions & BBViewBorderOptionsRight) {
        if (!self.rightBorderView) {
            [self setRightBorderView:[[UIView alloc] initWithFrame:CGRectZero]];
            [self addSubview:self.rightBorderView];
        }
    }
    else {
        [self.rightBorderView removeFromSuperview];
        [self setRightBorderView:nil];
    }
#else
    [self setNeedsDisplay:YES];
#endif
}
    
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsLayout];
#else
    [self setNeedsDisplay:YES];
#endif
}
    
#if (TARGET_OS_IPHONE)
- (void)setBorderEdgeInsets:(UIEdgeInsets)borderEdgeInsets {
#else
- (void)setBorderEdgeInsets:(NSEdgeInsets)borderEdgeInsets {
#endif
    _borderEdgeInsets = borderEdgeInsets;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsLayout];
#else
    [self setNeedsDisplay:YES];
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setBorderColor:(UIColor *)borderColor {
#else
- (void)setBorderColor:(NSColor *)borderColor {
#endif
_borderColor = borderColor ?: [self.class _defaultBorderColor];
        
#if (TARGET_OS_IPHONE)
    [self.topBorderView setBackgroundColor:_borderColor];
    [self.leftBorderView setBackgroundColor:_borderColor];
    [self.bottomBorderView setBackgroundColor:_borderColor];
    [self.rightBorderView setBackgroundColor:_borderColor];
#else
    [self setNeedsDisplay:YES];
#endif
}

#if (!TARGET_OS_IPHONE)
- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    
    [self setNeedsDisplay:YES];
}
#endif

+ (CGFloat)_defaultBorderWidth; {
    return 1.0;
}
#if (TARGET_OS_IPHONE)
+ (UIColor *)_defaultBorderColor; {
    return [UIColor blackColor];
}
#else
+ (NSColor *)_defaultBorderColor; {
    return [NSColor blackColor];
}
#endif

- (void)_BBViewInit; {
    _borderWidth = [self.class _defaultBorderWidth];
    _borderColor = [self.class _defaultBorderColor];
}
    
@end
