//
//  BBButton.h
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

#import <UIKit/UIKit.h>

/**
 Enum describing the style of the button.
 */
typedef NS_ENUM(NSInteger, BBButtonStyle) {
    /**
     Use the default UIButton style.
     */
    BBButtonStyleDefault = 0,
    /**
     Round the corners of the button to match the height.
     */
    BBButtonStyleRounded
};

/**
 Enum describing the alignment of the button.
 */
typedef NS_ENUM(NSInteger, BBButtonAlignment) {
    /**
     Use the default UIButton alignment.
     */
    BBButtonAlignmentDefault = 0,
    /**
     Swap the positions of the image and title, image on the right and title on the left.
     */
    BBButtonAlignmentRight,
    /**
     Center both the image and title horizontally with the image above the title.
     */
    BBButtonAlignmentCenterVertically
};

/**
 Enum describing the alignment of the title.
 */
typedef NS_ENUM(NSInteger, BBButtonTitleAlignment) {
    /**
     Use the default UIButton title alignment.
     */
    BBButtonTitleAlignmentDefault = 0,
    /**
     Align the title to the left edge of the button.
     */
    BBButtonTitleAlignmentLeft,
    /**
     Align the title to the right edge of the button.
     */
    BBButtonTitleAlignmentRight
};

/**
 Enum describing the alignment of the image.
 */
typedef NS_ENUM(NSInteger, BBButtonImageAlignment) {
    /**
     Use the default UIButton image alignment.
     */
    BBButtonImageAlignmentDefault = 0,
    /**
     Align the image to the left edge of the button.
     */
    BBButtonImageAlignmentLeft,
    /**
     Align the image to the right edge of the button.
     */
    BBButtonImageAlignmentRight
};

/**
 BBButton is a subclass of UIButton that provides custom style and alignment options.
 */
@interface BBButton : UIButton

/**
 Set and get the style of the button.
 
 @see BBButtonStyle
 */
@property (assign,nonatomic) BBButtonStyle style;
/**
 Set and get the alignment of the button.
 
 @see BBButtonAlignment
 */
@property (assign,nonatomic) BBButtonAlignment alignment;
/**
 Set and get the alignment of the title.
 
 @see BBButtonTitleAlignment
 */
@property (assign,nonatomic) BBButtonTitleAlignment titleAlignment;
/**
 Set and get the alignment of the image.
 
 @see BBButtonImageAlignment
 */
@property (assign,nonatomic) BBButtonImageAlignment imageAlignment;

@end
