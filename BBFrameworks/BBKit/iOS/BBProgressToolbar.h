//
//  BBProgressToolbar.h
//  BBFrameworks
//
//  Created by William Towe on 2/23/16.
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

NS_ASSUME_NONNULL_BEGIN

/**
 BBProgressToolbar is a UIToolbar subclass that manages a UIProgressView to display relevant progress at the top edge of the receiver.
 */
@interface BBProgressToolbar : UIToolbar

/**
 Set and get whether the managed UIProgressView is hidden.
 
 Calls `-[self setProgressHidden:animated:]`, passing _progressHidden_ and NO respectively.
 */
@property (assign,nonatomic,getter=isProgressHidden) BOOL progressHidden;
/**
 Set and get whether the managed UIProgressView is hidden, with optional animation.
 
 @param progressHidden Whether to hide the managed UIProgressView
 @param animated Whether to animate the change
 */
- (void)setProgressHidden:(BOOL)progressHidden animated:(BOOL)animated;

/**
 Set and get the progress of the managed UIProgressView.
 
 Calls `-[self setProgress:animated:]`, passing _progress_ and NO respectively.
 */
@property (assign,nonatomic) CGFloat progress;
/**
 Set and get the progress of the managed UIProgressView, with optional animation.
 
 @param progress The progress percentage, between 0.0 and 1.0
 @param animated Whether to animate the change
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)didAddSubview:(UIView *)subview NS_REQUIRES_SUPER;

@end

@interface UINavigationController (BBProgressToolbarExtensions)

/**
 Returns the managed BBProgressToolbar or nil.
 
 @return The toolbar or nil
 */
- (nullable BBProgressToolbar *)BB_progressToolbar;

@end

NS_ASSUME_NONNULL_END
