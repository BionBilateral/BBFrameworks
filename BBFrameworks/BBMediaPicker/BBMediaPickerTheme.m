//
//  BBMediaPickerTheme.m
//  BBFrameworks
//
//  Created by William Towe on 11/16/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerTheme.h"
#import "BBMediaPickerAssetDefaultSelectedOverlayView.h"
#import "BBKitColorMacros.h"

@interface BBMediaPickerTheme ()
+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleColor;
+ (UIFont *)_defaultSubtitleFont;
+ (UIColor *)_defaultSubtitleColor;

+ (UIColor *)_defaultAssetCollectionBackgroundColor;
+ (UIColor *)_defaultAssetCollectionCellBackgroundColor;
+ (UIFont *)_defaultAssetCollectionCellTitleFont;
+ (UIColor *)_defaultAssetCollectionCellTitleColor;
+ (UIFont *)_defaultAssetCollectionCellSubtitleFont;
+ (UIColor *)_defaultAssetCollectionCellSubtitleColor;

+ (UIColor *)_defaultAssetBackgroundColor;
+ (Class)_defaultAssetSelectedOverlayViewClass;
+ (UIColor *)_defaultAssetSelectedOverlayViewTintColor;
@end

@implementation BBMediaPickerTheme

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _titleFont = [self.class _defaultTitleFont];
    _titleColor = [self.class _defaultTitleColor];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _subtitleColor = [self.class _defaultSubtitleColor];
    
    _assetCollectionBackgroundColor = [self.class _defaultAssetCollectionBackgroundColor];
    _assetCollectionCellBackgroundColor = [self.class _defaultAssetCollectionCellBackgroundColor];
    _assetCollectionCellTitleFont = [self.class _defaultAssetCollectionCellTitleFont];
    _assetCollectionCellTitleColor = [self.class _defaultAssetCollectionCellTitleColor];
    _assetCollectionCellSubtitleFont = [self.class _defaultAssetCollectionCellSubtitleFont];
    _assetCollectionCellSubtitleColor = [self.class _defaultAssetCollectionCellSubtitleColor];
    
    _assetBackgroundColor = [self.class _defaultAssetBackgroundColor];
    _assetSelectedOverlayViewClass = [self.class _defaultAssetSelectedOverlayViewClass];
    _assetSelectedOverlayViewTintColor = [self.class _defaultAssetSelectedOverlayViewTintColor];
    
    return self;
}

+ (instancetype)defaultTheme {
    static id kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[BBMediaPickerTheme alloc] init];
    });
    return kRetval;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor ?: [self.class _defaultTitleColor];
}
- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subtitleFont = subtitleFont ?: [self.class _defaultSubtitleFont];
}
- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor ?: [self.class _defaultSubtitleColor];
}

- (void)setAssetCollectionBackgroundColor:(UIColor *)assetCollectionBackgroundColor {
    _assetCollectionBackgroundColor = assetCollectionBackgroundColor ?: [self.class _defaultAssetCollectionBackgroundColor];
}
- (void)setAssetCollectionCellBackgroundColor:(UIColor *)assetCollectionCellBackgroundColor {
    _assetCollectionCellBackgroundColor = assetCollectionCellBackgroundColor ?: [self.class _defaultAssetCollectionCellBackgroundColor];
}
- (void)setAssetCollectionCellTitleFont:(UIFont *)assetCollectionCellTitleFont {
    _assetCollectionCellTitleFont = assetCollectionCellTitleFont ?: [self.class _defaultAssetCollectionCellTitleFont];
}
- (void)setAssetCollectionCellTitleColor:(UIColor *)assetCollectionCellTitleColor {
    _assetCollectionCellTitleColor = assetCollectionCellTitleColor ?: [self.class _defaultAssetCollectionCellTitleColor];
}
- (void)setAssetCollectionCellSubtitleFont:(UIFont *)assetCollectionCellSubtitleFont {
    _assetCollectionCellSubtitleFont = assetCollectionCellSubtitleFont ?: [self.class _defaultAssetCollectionCellSubtitleFont];
}
- (void)setAssetCollectionCellSubtitleColor:(UIColor *)assetCollectionCellSubtitleColor {
    _assetCollectionCellSubtitleColor = assetCollectionCellSubtitleColor ?: [self.class _defaultAssetCollectionCellSubtitleColor];
}

- (void)setAssetBackgroundColor:(UIColor *)assetBackgroundColor {
    _assetBackgroundColor = assetBackgroundColor ?: [self.class _defaultAssetBackgroundColor];
}
- (void)setAssetSelectedOverlayViewClass:(Class)assetSelectedOverlayViewClass {
    _assetSelectedOverlayViewClass = assetSelectedOverlayViewClass ?: [self.class _defaultAssetSelectedOverlayViewClass];
}
- (void)setAssetSelectedOverlayViewTintColor:(UIColor *)assetSelectedOverlayViewTintColor {
    _assetSelectedOverlayViewTintColor = assetSelectedOverlayViewTintColor ?: [self.class _defaultAssetSelectedOverlayViewTintColor];
}

+ (UIFont *)_defaultTitleFont; {
    return [UIFont boldSystemFontOfSize:17.0];
}
+ (UIColor *)_defaultTitleColor; {
    return [UIColor blackColor];
}
+ (UIFont *)_defaultSubtitleFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultSubtitleColor; {
    return [UIColor darkGrayColor];
}

+ (UIColor *)_defaultAssetCollectionBackgroundColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultAssetCollectionCellBackgroundColor {
    return [UIColor whiteColor];
}
+ (UIFont *)_defaultAssetCollectionCellTitleFont {
    return [UIFont systemFontOfSize:17.0];
}
+ (UIColor *)_defaultAssetCollectionCellTitleColor {
    return [UIColor blackColor];
}
+ (UIFont *)_defaultAssetCollectionCellSubtitleFont {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultAssetCollectionCellSubtitleColor {
    return [UIColor blackColor];
}

+ (UIColor *)_defaultAssetBackgroundColor {
    return [UIColor whiteColor];
}
+ (Class)_defaultAssetSelectedOverlayViewClass; {
    return [BBMediaPickerAssetDefaultSelectedOverlayView class];
}
+ (UIColor *)_defaultAssetSelectedOverlayViewTintColor; {
    return BBColorRGB(0.0, 122.0/255.0, 1.0);
}

@end
