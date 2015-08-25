//
//  BBTooltipView.h
//  BBFrameworks
//
//  Created by Willam Towe on 6/17/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import "BBTooltipViewDefines.h"
#import "BBTooltipAccessoryView.h"

/**
 Enum describing the arrow direction of the receiver.
 */
typedef NS_ENUM(NSInteger, BBTooltipViewArrowDirection) {
    /**
     The arrow is pointing up.
     */
    BBTooltipViewArrowDirectionUp,
    /**
     The arrow is pointing left.
     */
    BBTooltipViewArrowDirectionLeft,
    /**
     The arrow is pointing down.
     */
    BBTooltipViewArrowDirectionDown,
    /**
     The arrow is pointing right.
     */
    BBTooltipViewArrowDirectionRight
};

/**
 BBTooltipView is a UIView subclass that is responsible for displaying a tooltip with BBTooltipViewController.
 */
@interface BBTooltipView : UIView

/**
 Set and get the arrow direction of the receiver.
 
 @see BBTooltipViewArrowDirection
 */
@property (assign,nonatomic) BBTooltipViewArrowDirection arrowDirection;
/**
 Set and get the arrow style of the receiver.
 
 The default is BBTooltipViewArrowStyleDefault.
 
 @see BBTooltipViewArrowStyle
 */
@property (assign,nonatomic) BBTooltipViewArrowStyle arrowStyle UI_APPEARANCE_SELECTOR;

/**
 Set and get the text of the receiver.
 
 Calls `-[self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.tooltipFont, NSForegroundColorAttributeName: self.tooltipTextColor}]]`.
 */
@property (copy,nonatomic) NSString *text;
/**
 Set and get the attributed text of the receiver.
 */
@property (copy,nonatomic) NSAttributedString *attributedText;

/**
 Set and get the attachment view of the receiver.
 */
@property (weak,nonatomic) UIView *attachmentView;

/**
 Set and get the tooltip font of the receiver.
 
 The default is [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].
 */
@property (strong,nonatomic) UIFont *tooltipFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip text color of the receiver.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic) UIColor *tooltipTextColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip background color.
 
 The default is [UIColor darkGrayColor].
 */
@property (strong,nonatomic) UIColor *tooltipBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip edge insets.
 
 The default is UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0).
 */
@property (assign,nonatomic) UIEdgeInsets tooltipEdgeInsets UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip arrow width.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat tooltipArrowWidth UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip arrow height.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat tooltipArrowHeight UI_APPEARANCE_SELECTOR;
/**
 Set and get the tooltip corner radius.
 
 The default is 5.0.
 */
@property (assign,nonatomic) CGFloat tooltipCornerRadius UI_APPEARANCE_SELECTOR;

/**
 Set and get the accessory view of the receiver. If non-nil, is displayed underneath the text of the tooltip with insets according to accessoryViewEdgeInsets. The view should implement `sizeThatFits:` so the receiver can determine the appropriate height for the accessory view frame.
 
 The default is nil.
 */
@property (strong,nonatomic) UIView<BBTooltipAccessoryView> *accessoryView;
/**
 Set and get the edge insets for the accessory view. These are used when laying out the accessory view with respect to the left, right, and bottom edges of the receiver, as well as the bottom edge of the text.
 
 The default is UIEdgeInsetsZero.
 */
@property (assign,nonatomic) UIEdgeInsets accessoryViewEdgeInsets UI_APPEARANCE_SELECTOR;

/**
 Returns the background rect for the provided bounds.
 
 @param bounds The bounds of the receiver
 @return The background rect
 */
- (CGRect)backgroundRectForBounds:(CGRect)bounds;
/**
 Returns the arrow rect for the provided bounds and attachment view.
 
 @param The bounds of the receiver
 @param attachmentView The attachment view for the receiver
 @return The arrow rect
 */
- (CGRect)arrowRectForBounds:(CGRect)bounds attachmentView:(UIView *)attachmentView;
/**
 Returns the accessory view rect for provided bounds.
 
 @param The bounds of the receiver
 @return The accessory 
 */
- (CGRect)accessoryViewRectForBounds:(CGRect)bounds;

@end
