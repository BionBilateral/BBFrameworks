//
//  BBFormTableViewCell.h
//  BBFrameworks
//
//  Created by William Towe on 7/16/15.
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
#import "BBFormFieldTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const BBFormTableViewCellMargin;

@class BBFormField;

/**
 BBFormTableViewCell is the base class from which all other default table view cells inherit from. Each cell represents a single BBFormField object within a BBFormTableViewController.
 */
@interface BBFormTableViewCell : UITableViewCell <BBFormFieldTableViewCell>

/**
 Get the right layout guide of the receiver, which can be used when laying out subviews.
 */
@property (readonly,nonatomic) id<UILayoutSupport> rightLayoutGuide;

/**
 Set and get the title font used by the receiver.
 
 The default is [UIFont systemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *titleFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the title text color used by the receiver.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the subtitle font used by the receiver.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *subtitleFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the subtitle text color used by the receiver.
 
 The default is [UIColor darkGrayColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *subtitleTextColor UI_APPEARANCE_SELECTOR;

- (void)layoutSubviews NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
