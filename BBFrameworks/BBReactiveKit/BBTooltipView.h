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

typedef NS_ENUM(NSInteger, BBTooltipViewArrowDirection) {
    BBTooltipViewArrowDirectionUp,
    BBTooltipViewArrowDirectionLeft,
    BBTooltipViewArrowDirectionDown,
    BBTooltipViewArrowDirectionRight
};

/**
 BBTooltipView is a UIView subclass that is responsible for displaying a tooltip with BBTooltipViewController.
 */
@interface BBTooltipView : UIView

@property (assign,nonatomic) BBTooltipViewArrowDirection arrowDirection;

@property (copy,nonatomic) NSString *text;
@property (copy,nonatomic) NSAttributedString *attributedText;

@property (weak,nonatomic) UIView *attachmentView;

@property (strong,nonatomic) UIFont *tooltipFont UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *tooltipTextColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *tooltipBackgroundColor UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) UIEdgeInsets tooltipEdgeInsets UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) CGFloat tooltipArrowHeight UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) CGFloat tooltipCornerRadius UI_APPEARANCE_SELECTOR;

- (CGRect)backgroundRectForBounds:(CGRect)bounds;
- (CGRect)arrowRectForBounds:(CGRect)bounds attachmentView:(UIView *)attachmentView;

@end
