//
//  BBTooltipViewControllerDelegate.h
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

#import <Foundation/Foundation.h>
#import "BBTooltipView.h"

NS_ASSUME_NONNULL_BEGIN

@class BBTooltipViewController;

/**
 Protocol for BBTooltipViewController delegate.
 */
@protocol BBTooltipViewControllerDelegate <NSObject>
@optional
/**
 Called to determine the tooltip style for the tooltip at the provided index.
 
 @param viewController The tooltip view controller that sent the message
 @param index The index of the tooltip about to be displayed
 @return The arrow style for the tooltip
 */
- (BBTooltipViewArrowStyle)tooltipViewController:(BBTooltipViewController *)viewController arrowStyleForTooltipAtIndex:(NSInteger)index;

/**
 Called to determine whether the client wants an accessory view displayed in the tooltip at the provided index. If the return value of this method is non-nil, the accessory view is displayed below the tooltip text and if it responds to setDisplayNextTooltipBlock: it must provide some way to execute the block (e.g. a button tap).
 
 @param viewController The tooltip view controller that sent the message
 @param index The index of the tooltip about to be displayed
 @return The accessory view for the tooltip
 */
- (nullable UIView<BBTooltipAccessoryView> *)tooltipViewController:(BBTooltipViewController *)viewController accessoryViewForTooltipAtIndex:(NSInteger)index;

/**
 Called immediately before the tooltip view controller is dismissed.
 
 @param viewController The tooltip view controller that sent the message
 */
- (void)tooltipViewControllerWillDismiss:(BBTooltipViewController *)viewController;
/**
 Called immediately after the tooltip view controller is dimissed.
 
 @param viewController The tooltip view controller that sent the message
 */
- (void)tooltipViewControllerDidDismiss:(BBTooltipViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
