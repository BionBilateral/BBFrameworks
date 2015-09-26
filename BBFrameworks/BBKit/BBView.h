//
//  BBView.h
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Options mask describing the border options of the receiver.
 */
typedef NS_OPTIONS(NSInteger, BBViewBorderOptions) {
    /**
     No borders are drawn.
     */
    BBViewBorderOptionsNone = 0,
    /**
     The top border is drawn.
     */
    BBViewBorderOptionsTop = 1 << 0,
    /**
     The left border is drawn.
     */
    BBViewBorderOptionsLeft = 1 << 1,
    /**
     The bottom border is drawn.
     */
    BBViewBorderOptionsBottom = 1 << 2,
    /**
     The right border is drawn.
     */
    BBViewBorderOptionsRight = 1 << 3,
    /**
     Top and bottom borders are drawn.
     */
    BBViewBorderOptionsTopAndBottom = BBViewBorderOptionsTop | BBViewBorderOptionsBottom,
    /**
     Left and right borders are drawn.
     */
    BBViewBorderOptionsLeftAndRight = BBViewBorderOptionsLeft | BBViewBorderOptionsRight,
    /**
     Top, left, bottom, and right borders are drawn.
     */
    BBViewBorderOptionsAll = BBViewBorderOptionsTop | BBViewBorderOptionsLeft | BBViewBorderOptionsBottom | BBViewBorderOptionsRight
};

/**
 BBView is a UIView/NSView subclass that provides a number of convenience methods.
 */
#if (TARGET_OS_IPHONE)
@interface BBView : UIView
#else
@interface BBView : NSView
#endif

/**
 Set and get the border options of the receiver.
 
 @see BBViewBorderOptions
 */
@property (assign,nonatomic) BBViewBorderOptions borderOptions;

/**
 Set and get the border width of the receiver. This affects the height of the top and bottom borders as well as the width of the left and right borders.
 
 The default is 1.0.
 */
#if (TARGET_OS_IPHONE)
@property (assign,nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
#else
@property (assign,nonatomic) CGFloat borderWidth;
#endif

/**
 Set and get the border edge insets of the receiver.
 
 The default is UIEdgeInsetsZero/NSEdgeInsetsZero.
 */
#if (TARGET_OS_IPHONE)
@property (assign,nonatomic) UIEdgeInsets borderEdgeInsets UI_APPEARANCE_SELECTOR;
#else
@property (assign,nonatomic) NSEdgeInsets borderEdgeInsets;
#endif

/**
 Set and get the border color of the receiver.
 
 The default is [UIColor blackColor]/[NSColor blackColor].
 */
#if (TARGET_OS_IPHONE)
@property (strong,nonatomic,nullable) UIColor *borderColor UI_APPEARANCE_SELECTOR;
#else
@property (strong,nonatomic,nullable) NSColor *borderColor;
#endif

/**
 Set and get the background color of the receiver.
 
 Equivalent to backgroundColor on UIView.
 */
#if (!TARGET_OS_IPHONE)
@property (strong,nonatomic,nullable) NSColor *backgroundColor;
#endif

#if (TARGET_OS_IPHONE)
- (void)didAddSubview:(UIView *)subview NS_REQUIRES_SUPER;
- (void)layoutSubviews NS_REQUIRES_SUPER;
#else
- (void)drawRect:(NSRect)dirtyRect NS_REQUIRES_SUPER;
#endif

@end

NS_ASSUME_NONNULL_END
