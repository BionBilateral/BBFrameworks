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

@interface BBMediaPickerTheme ()
+ (UIColor *)_defaultAssetCollectionBackgroundColor;
+ (UIColor *)_defaultAssetCollectionCellBackgroundColor;
+ (UIFont *)_defaultAssetCollectionCellTitleFont;
+ (UIColor *)_defaultAssetCollectionCellTitleColor;
+ (UIFont *)_defaultAssetCollectionCellSubtitleFont;
+ (UIColor *)_defaultAssetCollectionCellSubtitleColor;
@end

@implementation BBMediaPickerTheme

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _assetCollectionBackgroundColor = [self.class _defaultAssetCollectionBackgroundColor];
    _assetCollectionCellBackgroundColor = [self.class _defaultAssetCollectionCellBackgroundColor];
    _assetCollectionCellTitleFont = [self.class _defaultAssetCollectionCellTitleFont];
    _assetCollectionCellTitleColor = [self.class _defaultAssetCollectionCellTitleColor];
    _assetCollectionCellSubtitleFont = [self.class _defaultAssetCollectionCellSubtitleFont];
    _assetCollectionCellSubtitleColor = [self.class _defaultAssetCollectionCellSubtitleColor];
    
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

@end
