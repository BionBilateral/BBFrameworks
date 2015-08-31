//
//  BBTooltipViewController.h
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
#import "BBTooltipViewControllerDataSource.h"
#import "BBTooltipViewControllerDelegate.h"
#import "BBTooltipViewDefines.h"

/**
 BBTooltipViewController is a subclass of UIViewController that manages the display of tooltips, views with text (or attributed text) and an arrow attached to a particular view.
 */
@interface BBTooltipViewController : UIViewController

/**
 Set and get the data source of the receiver.
 
 @see BBTooltipViewControllerDataSource
 */
@property (weak,nonatomic) id<BBTooltipViewControllerDataSource> dataSource;
/**
 Set and get the delegate of the receiver.
 
 @see BBTooltipViewControllerDelegate
 */
@property (weak,nonatomic) id<BBTooltipViewControllerDelegate> delegate;

/**
 Set and get the animation duration for showing and hiding tooltips.
 
 The default is 0.5.
 */
@property (assign,nonatomic) NSTimeInterval tooltipAnimationDuration;
/**
 Set and get the minimum edge insets for tooltips.
 
 These affect how close to edge of the view a tooltip can be before it is repositioned.
 
 The default is UIEdgeInsets(8.0, 8.0, 8.0, 8.0).
 */
@property (assign,nonatomic) UIEdgeInsets tooltipMinimumEdgeInsets;

/**
 Set and get the overlay background color of the receiver.
 
 The default is [UIColor colorWithWhite:0.0 alpha:0.33].
 */
@property (strong,nonatomic) UIColor *tooltipOverlayBackgroundColor;

@end

/**
 Typedef for tooltip present completion block. This will be invoked once the tooltip view controller has finished its present animation.
 */
typedef void(^BBTooltipPresentCompletionBlock)(void);
/**
 Typedef for tooltip dismiss completion block. This will be invoked once the tooltip view controller has finished its dismiss animation.
 */
typedef void(^BBTooltipDismissCompletionBlock)(void);

/**
 Tooltip attribute for displaying using a custom tooltip view controller class.
 */
extern NSString *const BBTooltipAttributeViewControllerClass;
/**
 Tooltip attribute for displaying using a custom attachment view bounds. The bounds should be relative to the attachment view bounds.
 */
extern NSString *const BBTooltipAttributeAttachmentViewBounds;
/**
 Tooltip attribute for displaying using a custom arrow style.
 */
extern NSString *const BBTooltipAttributeArrowStyle;
/**
 Tooltip attribute for displaying using a accessory view. The accessory view should conform to BBTooltipAccessoryView.
 */
extern NSString *const BBTooltipAttributeAccessoryView;
/**
 Tooltip attribute for providing a present completion block.
 
 @see BBTooltipPresentCompletionBlock
 */
extern NSString *const BBTooltipAttributePresentCompletionBlock;
/**
 Tooltip attribute for providing a dismiss completion block.
 
 @see BBTooltipDismissCompletionBlock
 */
extern NSString *const BBTooltipAttributeDismissCompletionBlock;

/**
 Category on UIViewController adding convenience methods to present a single tooltip with text or attributed text.
 */
@interface UIViewController (BBTooltipViewControllerExtensions)

/**
 Present a tooltip view controller with the provided text, attached to attachmentView, configured with attributes.
 
 @param text The text of the tooltip
 @param attachmentView The attachment view of the tooltip
 @param attributes Additional attributes used to configure the tooltip
 */
- (void)BB_presentTooltipViewControllerWithText:(NSString *)text attachmentView:(UIView *)attachmentView attributes:(NSDictionary *)attributes;
/**
 Present a tooltip view controller with the provided attributedText, attached to attachmentView, configured with attributes.
 
 @param attributedText The attributed text of the tooltip
 @param attachmentView The attachment view of the tooltip
 @param attributes Additional attributes used to configure the tooltip
 */
- (void)BB_presentTooltipViewControllerWithAttributedText:(NSAttributedString *)attributedText attachmentView:(UIView *)attachmentView attributes:(NSDictionary *)attributes;

@end
