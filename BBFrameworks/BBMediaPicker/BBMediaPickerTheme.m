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
#import "BBMediaPickerDefaultTitleView.h"
#import "UIImage+BBKitExtensionsPrivate.h"

#define kDefaultTintColor() BBColorRGB(0.0, 122.0/255.0, 1.0)

@interface BBMediaPickerTheme ()
+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleColor;
+ (UIFont *)_defaultSubtitleFont;
+ (UIColor *)_defaultSubtitleColor;
+ (Class)_defaultTitleViewClass;

+ (UIColor *)_defaultAssetCollectionBackgroundColor;
+ (UIColor *)_defaultAssetCollectionCellBackgroundColor;
+ (UIFont *)_defaultAssetCollectionCellTitleFont;
+ (UIColor *)_defaultAssetCollectionCellTitleColor;
+ (UIFont *)_defaultAssetCollectionCellSubtitleFont;
+ (UIColor *)_defaultAssetCollectionCellSubtitleColor;
+ (UIColor *)_defaultAssetCollectionForegroundColor;
+ (UIColor *)_defaultAssetCollectionSeparatorColor;
+ (UIColor *)_defaultAssetCollectionPopoverBackgroundColor;
+ (UIColor *)_defaultAssetCollectionCellCheckmarkColor;

+ (UIColor *)_defaultAssetBackgroundColor;
+ (Class)_defaultAssetSelectedOverlayViewClass;
+ (UIColor *)_defaultAssetSelectedOverlayViewTintColor;
+ (UIFont *)_defaultAssetSelectedOverlayViewSelectedIndexFont;
+ (NSArray<UIColor *> *)_defaultAssetBottomGradientColors;
+ (UIImage *)_defaultAssetTypeVideoImage;
+ (UIColor *)_defaultAssetForegroundColor;
+ (UIFont *)_defaultAssetDurationFont;
@end

@implementation BBMediaPickerTheme

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p name=\"%@\"",NSStringFromClass([self class]),self,self.name];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _titleFont = [self.class _defaultTitleFont];
    _titleColor = [self.class _defaultTitleColor];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _subtitleColor = [self.class _defaultSubtitleColor];
    _titleViewClass = [self.class _defaultTitleViewClass];
    _assetCollectionForegroundColor = [self.class _defaultAssetCollectionForegroundColor];
    _selectionBorderWidth = 3.0;
    
    _assetCollectionBackgroundColor = [self.class _defaultAssetCollectionBackgroundColor];
    _assetCollectionCellBackgroundColor = [self.class _defaultAssetCollectionCellBackgroundColor];
    _assetCollectionCellTitleFont = [self.class _defaultAssetCollectionCellTitleFont];
    _assetCollectionCellTitleColor = [self.class _defaultAssetCollectionCellTitleColor];
    _assetCollectionCellSubtitleFont = [self.class _defaultAssetCollectionCellSubtitleFont];
    _assetCollectionCellSubtitleColor = [self.class _defaultAssetCollectionCellSubtitleColor];
    _assetCollectionSeparatorColor = [self.class _defaultAssetCollectionSeparatorColor];
    _assetCollectionPopoverBackgroundColor = [self.class _defaultAssetCollectionPopoverBackgroundColor];
    _assetCollectionPopoverArrowWidth = 8.0;
    _assetCollectionPopoverArrowHeight = 8.0;
    _assetCollectionPopoverCornerRadius = 5.0;
    _assetCollectionPopoverBackgroundEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 0.0, 8.0);
    _assetCollectionSeparatorEdgeInsets = UIEdgeInsetsMake(0, 8.0, 0, 0);
    _assetCollectionCellCheckmarkColor = [self.class _defaultAssetCollectionCellCheckmarkColor];
    
    _assetBackgroundColor = [self.class _defaultAssetBackgroundColor];
    _assetSelectedOverlayViewClass = [self.class _defaultAssetSelectedOverlayViewClass];
    _assetSelectedOverlayViewTintColor = [self.class _defaultAssetSelectedOverlayViewTintColor];
    _assetSelectedOverlayViewSelectedIndexFont = [self.class _defaultAssetSelectedOverlayViewSelectedIndexFont];
    _assetBottomGradientColors = [self.class _defaultAssetBottomGradientColors];
    _assetTypeVideoImage = [self.class _defaultAssetTypeVideoImage];
    _assetForegroundColor = [self.class _defaultAssetForegroundColor];
    _assetDurationFont = [self.class _defaultAssetDurationFont];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    BBMediaPickerTheme *retval = [[[self class] alloc] init];
    
    [retval setTitleFont:self.titleFont];
    [retval setTitleColor:self.titleColor];
    [retval setSubtitleFont:self.subtitleFont];
    [retval setSubtitleColor:self.subtitleColor];
    [retval setTitleViewClass:self.titleViewClass];
    [retval setCancelBarButtonItem:self.cancelBarButtonItem];
    [retval setCancelBottomAccessoryControlClass:self.cancelBottomAccessoryControlClass];
    [retval setDoneBarButtonItem:self.doneBarButtonItem];
    [retval setDoneBottomAccessoryControlClass:self.doneBottomAccessoryControlClass];
    
    [retval setSelectionBorderWidth:self.selectionBorderWidth];
    
    [retval setAssetCollectionBackgroundColor:self.assetCollectionBackgroundColor];
    [retval setAssetCollectionCellBackgroundColor:self.assetCollectionCellBackgroundColor];
    [retval setAssetCollectionCellTitleFont:self.assetCollectionCellTitleFont];
    [retval setAssetCollectionCellTitleColor:self.assetCollectionCellTitleColor];
    [retval setAssetCollectionCellSubtitleFont:self.assetCollectionCellSubtitleFont];
    [retval setAssetCollectionCellSubtitleColor:self.assetCollectionCellSubtitleColor];
    [retval setAssetCollectionCellCheckmarkColor:self.assetCollectionCellCheckmarkColor];
    [retval setAssetCollectionCellAccessoryImage:self.assetCollectionCellAccessoryImage];
    [retval setAssetCollectionForegroundColor:self.assetCollectionForegroundColor];
    [retval setAssetCollectionSeparatorColor:self.assetCollectionSeparatorColor];
    [retval setAssetCollectionSeparatorEdgeInsets:self.assetCollectionSeparatorEdgeInsets];
    [retval setAssetCollectionPopoverBackgroundColor:self.assetCollectionPopoverBackgroundColor];
    [retval setAssetCollectionPopoverBackgroundEdgeInsets:self.assetCollectionPopoverBackgroundEdgeInsets];
    [retval setAssetCollectionPopoverCornerRadius:self.assetCollectionPopoverCornerRadius];
    [retval setAssetCollectionPopoverArrowHeight:self.assetCollectionPopoverArrowHeight];
    [retval setAssetCollectionPopoverArrowWidth:self.assetCollectionPopoverArrowWidth];
    
    [retval setAssetBackgroundColor:self.assetBackgroundColor];
    [retval setAssetSelectedOverlayViewClass:self.assetSelectedOverlayViewClass];
    [retval setAssetSelectedOverlayViewTintColor:self.assetSelectedOverlayViewTintColor];
    [retval setAssetSelectedOverlayViewSelectedIndexFont:self.assetSelectedOverlayViewSelectedIndexFont];
    [retval setAssetBottomGradientColors:self.assetBottomGradientColors];
    [retval setAssetTypeVideoImage:self.assetTypeVideoImage];
    [retval setAssetForegroundColor:self.assetForegroundColor];
    [retval setAssetDurationFont:self.assetDurationFont];
    
    return retval;
}

+ (instancetype)defaultTheme {
    static id kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[BBMediaPickerTheme alloc] init];
        
        [kRetval setName:@"com.bionbilateral.bbmediapicker.theme.default"];
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
- (void)setTitleViewClass:(Class)titleViewClass {
    _titleViewClass = titleViewClass ?: [self.class _defaultTitleViewClass];
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
- (void)setAssetCollectionForegroundColor:(UIColor *)assetCollectionForegroundColor {
    _assetCollectionForegroundColor = assetCollectionForegroundColor ?: [self.class _defaultAssetCollectionForegroundColor];
}
- (void)setAssetCollectionSeparatorColor:(UIColor *)assetCollectionSeparatorColor {
    _assetCollectionSeparatorColor = assetCollectionSeparatorColor ?: [self.class _defaultAssetCollectionSeparatorColor];
}
- (void)setAssetCollectionPopoverBackgroundColor:(UIColor *)assetCollectionPopoverBackgroundColor {
    _assetCollectionPopoverBackgroundColor = assetCollectionPopoverBackgroundColor ?: [self.class _defaultAssetCollectionPopoverBackgroundColor];
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
- (void)setAssetSelectedOverlayViewSelectedIndexFont:(UIFont *)assetSelectedOverlayViewSelectedIndexFont {
    _assetSelectedOverlayViewSelectedIndexFont = assetSelectedOverlayViewSelectedIndexFont ?: [self.class _defaultAssetSelectedOverlayViewSelectedIndexFont];
}
- (void)setAssetBottomGradientColors:(NSArray<UIColor *> *)assetBottomGradientColors {
    _assetBottomGradientColors = [assetBottomGradientColors copy] ?: [self.class _defaultAssetBottomGradientColors];
}
- (void)setAssetTypeVideoImage:(UIImage *)assetTypeVideoImage {
    _assetTypeVideoImage = assetTypeVideoImage ?: [self.class _defaultAssetTypeVideoImage];
}
- (void)setAssetForegroundColor:(UIColor *)assetForegroundColor {
    _assetForegroundColor = assetForegroundColor ?: [self.class _defaultAssetForegroundColor];
}
- (void)setAssetDurationFont:(UIFont *)assetDurationFont {
    _assetDurationFont = assetDurationFont ?: [self.class _defaultAssetDurationFont];
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
+ (Class)_defaultTitleViewClass; {
    return [BBMediaPickerDefaultTitleView class];
}

+ (UIColor *)_defaultAssetCollectionBackgroundColor; {
    return [[UIColor blackColor] colorWithAlphaComponent:0.5];
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
    return [UIColor darkGrayColor];
}
+ (UIColor *)_defaultAssetCollectionForegroundColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultAssetCollectionSeparatorColor; {
    return [UIColor lightGrayColor];
}
+ (UIColor *)_defaultAssetCollectionPopoverBackgroundColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultAssetCollectionCellCheckmarkColor; {
    return kDefaultTintColor();
}

+ (UIColor *)_defaultAssetBackgroundColor {
    return [UIColor whiteColor];
}
+ (Class)_defaultAssetSelectedOverlayViewClass; {
    return [BBMediaPickerAssetDefaultSelectedOverlayView class];
}
+ (UIColor *)_defaultAssetSelectedOverlayViewTintColor; {
    return kDefaultTintColor();
}
+ (UIFont *)_defaultAssetSelectedOverlayViewSelectedIndexFont {
    return [UIFont boldSystemFontOfSize:12.0];
}
+ (NSArray<UIColor *> *)_defaultAssetBottomGradientColors {
    return @[BBColorWA(0.0, 0.5),BBColorWA(0.0, 0.75)];
}
+ (UIImage *)_defaultAssetTypeVideoImage; {
    return [UIImage BB_imageInResourcesBundleNamed:@"media_picker_type_video"];
}
+ (UIColor *)_defaultAssetForegroundColor; {
    return [UIColor whiteColor];
}
+ (UIFont *)_defaultAssetDurationFont; {
    return [UIFont systemFontOfSize:12.0];
}

@end
