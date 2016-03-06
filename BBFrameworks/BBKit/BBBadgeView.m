//
//  BBBadgeView.m
//  BBFrameworks
//
//  Created by William Towe on 5/26/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBBadgeView.h"
#import "BBFoundationGeometryFunctions.h"

@interface BBBadgeView ()

- (void)_BBBadgeViewInit;

#if (TARGET_OS_IPHONE)
+ (UIColor *)_defaultBadgeForegroundColor;
+ (UIColor *)_defaultBadgeBackgroundColor;
+ (UIColor *)_defaultBadgeHighlightedForegroundColor;
+ (UIColor *)_defaultBadgeHighlightedBackgroundColor;
+ (UIFont *)_defaultBadgeFont;
+ (UIEdgeInsets)_defaultBadgeEdgeInsets;
#else
+ (NSColor *)_defaultBadgeForegroundColor;
+ (NSColor *)_defaultBadgeBackgroundColor;
+ (NSColor *)_defaultBadgeHighlightedForegroundColor;
+ (NSColor *)_defaultBadgeHighlightedBackgroundColor;
+ (NSFont *)_defaultBadgeFont;
+ (NSEdgeInsets)_defaultBadgeEdgeInsets;
#endif
+ (CGFloat)_defaultBadgeCornerRadius;
@end

@implementation BBBadgeView

#pragma mark ** Subclass Overrides **
#if (TARGET_OS_IPHONE)
- (instancetype)initWithFrame:(CGRect)frame {
#else
- (instancetype)initWithFrame:(NSRect)frame {
#endif
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBBadgeViewInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBBadgeViewInit];
    
    return self;
}
#pragma mark UIView
#if (TARGET_OS_IPHONE)
- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.badge.length == 0) {
        return CGSizeZero;
    }
    
    CGSize retval = [self.badge sizeWithAttributes:@{NSFontAttributeName: self.badgeFont}];
    
    retval.width += self.badgeEdgeInsets.left + self.badgeEdgeInsets.right;
    retval.height += self.badgeEdgeInsets.top + self.badgeEdgeInsets.bottom;
    
    if (retval.height > retval.width) {
        retval.width = retval.height;
    }
    
    return retval;
}
#else
- (NSSize)intrinsicContentSize {
    return [self sizeThatFits:NSZeroSize];
}

- (NSSize)sizeThatFits:(NSSize)size {
    if (self.badge.length == 0) {
        return NSZeroSize;
    }
    
    NSSize retval = [self.badge sizeWithAttributes:@{NSFontAttributeName: self.badgeFont}];
    
    retval.width += self.badgeEdgeInsets.left + self.badgeEdgeInsets.right;
    retval.height += self.badgeEdgeInsets.top + self.badgeEdgeInsets.bottom;
    
    if (retval.height > retval.width) {
        retval.width = retval.height;
    }
    
    return retval;
}
#endif

- (BOOL)isOpaque {
    return NO;
}

#if (TARGET_OS_IPHONE)
- (void)drawRect:(CGRect)rect {
#else
- (void)drawRect:(NSRect)rect {
#endif
    if (self.isHighlighted) {
        [self.badgeHighlightedBackgroundColor setFill];
    }
    else {
        [self.badgeBackgroundColor setFill];
    }
    
#if (TARGET_OS_IPHONE)
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.badgeCornerRadius] fill];
#else
    [[NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.badgeCornerRadius yRadius:self.badgeCornerRadius] fill];
#endif
    
#if (TARGET_OS_IPHONE)
    CGSize size = [self.badge sizeWithAttributes:@{NSFontAttributeName: self.badgeFont}];
#else
    NSSize size = [self.badge sizeWithAttributes:@{NSFontAttributeName: self.badgeFont}];
#endif
    
    [self.badge drawInRect:BBCGRectCenterInRect(CGRectMake(0, 0, size.width, size.height), self.bounds) withAttributes:@{NSFontAttributeName: self.badgeFont, NSForegroundColorAttributeName: self.isHighlighted ? self.badgeHighlightedForegroundColor : self.badgeForegroundColor}];
}
#pragma mark ** Public Methods **
#pragma mark Properties
- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}

- (void)setBadge:(NSString *)badge {
    _badge = badge;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
    [self invalidateIntrinsicContentSize];
}

#if (TARGET_OS_IPHONE)
- (void)setBadgeForegroundColor:(UIColor *)badgeForegroundColor {
#else
- (void)setBadgeForegroundColor:(NSColor *)badgeForegroundColor {
#endif
    _badgeForegroundColor = badgeForegroundColor ?: [self.class _defaultBadgeForegroundColor];
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
#else
- (void)setBadgeBackgroundColor:(NSColor *)badgeBackgroundColor {
#endif
    _badgeBackgroundColor = badgeBackgroundColor ?: [self.class _defaultBadgeBackgroundColor];
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setBadgeHighlightedForegroundColor:(UIColor *)badgeHighlightedForegroundColor {
#else
- (void)setBadgeHighlightedForegroundColor:(NSColor *)badgeHighlightedForegroundColor {
#endif
    _badgeHighlightedForegroundColor = badgeHighlightedForegroundColor ?: [self.class _defaultBadgeHighlightedForegroundColor];
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}
#if (TARGET_OS_IPHONE)
- (void)setBadgeHighlightedBackgroundColor:(UIColor *)badgeHighlightedBackgroundColor {
#else
- (void)setBadgeHighlightedBackgroundColor:(NSColor *)badgeHighlightedBackgroundColor {
#endif
    _badgeHighlightedBackgroundColor = badgeHighlightedBackgroundColor ?: [self.class _defaultBadgeHighlightedBackgroundColor];
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setBadgeFont:(UIFont *)badgeFont {
#else
- (void)setBadgeFont:(NSFont *)badgeFont {
#endif
    _badgeFont = badgeFont ?: [self.class _defaultBadgeFont];
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
    [self invalidateIntrinsicContentSize];
}
- (void)setBadgeCornerRadius:(CGFloat)badgeCornerRadius {
    _badgeCornerRadius = (badgeCornerRadius < 0.0) ? [self.class _defaultBadgeCornerRadius] : badgeCornerRadius;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
}
#if (TARGET_OS_IPHONE)
- (void)setBadgeEdgeInsets:(UIEdgeInsets)badgeEdgeInsets {
#else
- (void)setBadgeEdgeInsets:(NSEdgeInsets)badgeEdgeInsets {
#endif
    _badgeEdgeInsets = badgeEdgeInsets;
    
#if (TARGET_OS_IPHONE)
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
    [self invalidateIntrinsicContentSize];
}
#pragma mark ** Private Methods **
- (void)_BBBadgeViewInit; {
    _badgeForegroundColor = [self.class _defaultBadgeForegroundColor];
    _badgeBackgroundColor = [self.class _defaultBadgeBackgroundColor];
    _badgeHighlightedForegroundColor = [self.class _defaultBadgeHighlightedForegroundColor];
    _badgeHighlightedBackgroundColor = [self.class _defaultBadgeHighlightedBackgroundColor];
    _badgeFont = [self.class _defaultBadgeFont];
    _badgeCornerRadius = [self.class _defaultBadgeCornerRadius];
    _badgeEdgeInsets = [self.class _defaultBadgeEdgeInsets];
}

#if (TARGET_OS_IPHONE)
+ (UIColor *)_defaultBadgeForegroundColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultBadgeBackgroundColor; {
    return [UIColor blackColor];
}
+ (UIColor *)_defaultBadgeHighlightedForegroundColor; {
    return [UIColor lightGrayColor];
}
+ (UIColor *)_defaultBadgeHighlightedBackgroundColor; {
    return [UIColor whiteColor];
}
+ (UIFont *)_defaultBadgeFont; {
    return [UIFont boldSystemFontOfSize:17.0];
}
+ (UIEdgeInsets)_defaultBadgeEdgeInsets; {
    return UIEdgeInsetsMake(4.0, 8.0, 4.0, 8.0);
}
#else
+ (NSColor *)_defaultBadgeForegroundColor; {
    return [NSColor whiteColor];
}
+ (NSColor *)_defaultBadgeBackgroundColor; {
    return [NSColor blackColor];
}
+ (NSColor *)_defaultBadgeHighlightedForegroundColor; {
    return [NSColor lightGrayColor];
}
+ (NSColor *)_defaultBadgeHighlightedBackgroundColor; {
    return [NSColor whiteColor];
}
+ (NSFont *)_defaultBadgeFont; {
    return [NSFont boldSystemFontOfSize:17.0];
}
+ (NSEdgeInsets)_defaultBadgeEdgeInsets; {
    return NSEdgeInsetsMake(4.0, 8.0, 4.0, 8.0);
}
#endif
+ (CGFloat)_defaultBadgeCornerRadius; {
    return 8.0;
}

@end
