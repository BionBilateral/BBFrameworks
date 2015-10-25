//
//  UIView+BBKitExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 5/29/15.
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

NS_ASSUME_NONNULL_BEGIN

/**
 Category on UIView adding various convenience methods.
 */
@interface UIView (BBKitExtensions)

/**
 Set and get the minimum X member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameMinimumX;
/**
 Set and get the maximum X member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameMaximumX;
/**
 Set and get the minimum Y member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameMinimumY;
/**
 Set and get the maximum Y member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameMaximumY;
/**
 Set and get the width member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameWidth;
/**
 Set and get the height member of the receiver's frame.
 */
@property (assign,nonatomic) CGFloat BB_frameHeight;

/**
 Creates and returns an NSArray containing all the receiver's subviews recursively.
 
 For each subview of the receiver, the subview is adding to the returned array, followed by the array of the subview's recursive subviews.
 
 @return The array of recursive subviews
 */
- (NSArray<__kindof UIView *> *)BB_recursiveSubviews;

/**
 Calls `[self BB_snapshotImageFromRect:afterScreenUpdates:]`, passing self.bounds and afterScreenUpdates respectively.
 
 @param afterScreenUpdates Whether the snapshot should contain recent changes
 @return The snapshot image
 */
- (UIImage *)BB_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates;
/**
 Creates and returns a snapshot image of the receiver using `drawViewHierarchyInRect:afterScreenUpdates`.
 
 @param rect The rect from which to create the snapshot image, should be in the receiver's coordinate system
 @param afterScreenUpdates Whether the snapshot should contain recent changes
 @return The snapshot image
 */
- (UIImage *)BB_snapshotImageFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterScreenUpdates;

@end

NS_ASSUME_NONNULL_END