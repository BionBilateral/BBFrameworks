//
//  BBTooltipViewControllerDataSource.h
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

NS_ASSUME_NONNULL_BEGIN

@class BBTooltipViewController;

/**
 Protocol for the BBTooltipViewController data source.
 */
@protocol BBTooltipViewControllerDataSource <NSObject>
@required
/**
 Return the number of tooltips that will be displayed by the provided tooltip view controller.
 
 @param viewController The tooltip view controller that sent the message
 @return The number of tooltips to display
 */
- (NSInteger)numberOfTooltipsForTooltipViewController:(BBTooltipViewController *)viewController;
/**
 Return the view the tooltip at the provided index should be attached to.
 
 @param viewController The tooltip view controller that sent the message
 @param index The index of the tooltip
 @return The attachment view for the tooltip
 */
- (UIView *)tooltipViewController:(BBTooltipViewController *)viewController attachmentViewForTooltipAtIndex:(NSInteger)index;
@optional
/**
 Return the text for the tooltip at the provided index.
 
 @param viewController The tooltip view controller that sent the message
 @param index The index of the tooltip
 @return The text for the tooltip
 */
- (nullable NSString *)tooltipViewController:(BBTooltipViewController *)viewController textForTooltipAtIndex:(NSInteger)index;
/**
 Return the attributed text for the tooltip at the provided index.
 
 If this method is implemented and returns a non-zero length attributed string, it is preferred over `-[self tooltipViewController:textForTooltipAtIndex:]`.
 
 @param viewController The tooltip view controller that sent the message
 @param index The index of the tooltip
 @return The attributed text for the tooltip
 */
- (nullable NSAttributedString *)tooltipViewController:(BBTooltipViewController *)viewController attributedTextForTooltipAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
