//
//  BBMediaViewerTheme.m
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerTheme.h"

@interface BBMediaViewerTheme ()
+ (UIColor *)_defaultBackgroundColor;
+ (UIColor *)_defaultForegroundColor;
+ (UIColor *)_defaultTintColor;
+ (UIColor *)_defaultHighlightTintColor;
+ (UIColor *)_defaultMovieProgressForegroundColor;
+ (UIFont *)_defaultMovieTimeElapsedRemainingFont;
+ (UIBarButtonItem *)_defaultDoneBarButtonItem;
+ (UIBarButtonItem *)_defaultActionBarButtonItem;
@end

@implementation BBMediaViewerTheme

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _transitionSnapshotBlurRadius = 0.75;
    _transitionSnapshotTintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    _backgroundColor = [self.class _defaultBackgroundColor];
    _foregroundColor = [self.class _defaultForegroundColor];
    _tintColor = [self.class _defaultTintColor];
    _highlightTintColor = [self.class _defaultHighlightTintColor];
    _movieProgressForegroundColor = [self.class _defaultMovieProgressForegroundColor];
    _movieTimeElapsedRemainingFont = [self.class _defaultMovieTimeElapsedRemainingFont];
    _doneBarButtonItem = [self.class _defaultDoneBarButtonItem];
    _actionBarButtonItem = [self.class _defaultActionBarButtonItem];
    _textEdgeInsets = UIEdgeInsetsMake(0, 8.0, 0, 8.0);
    _showActionBarButtonItem = YES;
    
    return self;
}

+ (instancetype)defaultTheme; {
    static BBMediaViewerTheme *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[self alloc] init];
        
        [kRetval setName:@"com.bionbilateral.bbmediaviewer.theme.default"];
    });
    return kRetval;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor ?: [self.class _defaultBackgroundColor];
}
- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor ?: [self.class _defaultForegroundColor];
}
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor ?: [self.class _defaultTintColor];
}
- (void)setHighlightTintColor:(UIColor *)highlightTintColor {
    _highlightTintColor = highlightTintColor ?: [self.class _defaultHighlightTintColor];
}
- (void)setMovieProgressForegroundColor:(UIColor *)movieProgressForegroundColor {
    _movieProgressForegroundColor = movieProgressForegroundColor ?: [self.class _defaultMovieProgressForegroundColor];
}
- (void)setMovieTimeElapsedRemainingFont:(UIFont *)movieTimeElapsedRemainingFont {
    _movieTimeElapsedRemainingFont = movieTimeElapsedRemainingFont ?: [self.class _defaultMovieTimeElapsedRemainingFont];
}

- (void)setDoneBarButtonItem:(UIBarButtonItem *)doneBarButtonItem {
    _doneBarButtonItem = doneBarButtonItem ?: [self.class _defaultDoneBarButtonItem];
}
- (void)setActionBarButtonItem:(UIBarButtonItem *)actionBarButtonItem {
    _actionBarButtonItem = actionBarButtonItem ?: [self.class _defaultActionBarButtonItem];
}

+ (UIColor *)_defaultBackgroundColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultForegroundColor; {
    return [UIColor blackColor];
}
+ (UIColor *)_defaultTintColor; {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view.tintColor;
}
+ (UIColor *)_defaultHighlightTintColor; {
    return [UIColor colorWithWhite:0.0 alpha:0.5];
}
+ (UIColor *)_defaultMovieProgressForegroundColor; {
    return [UIColor lightGrayColor];
}
+ (UIFont *)_defaultMovieTimeElapsedRemainingFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIBarButtonItem *)_defaultDoneBarButtonItem; {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
}
+ (UIBarButtonItem *)_defaultActionBarButtonItem; {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:NULL];
}

@end
