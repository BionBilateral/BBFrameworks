//
//  BBMediaPickerAssetsGroupTableViewCell.h
//  BBFrameworks
//
//  Created by William Towe on 7/29/15.
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

@class BBMediaPickerAssetsGroupViewModel;

/**
 BBMediaPickerAssetsGroupTableViewCell is a UITableViewCell that displays a single media group.
 */
@interface BBMediaPickerAssetsGroupTableViewCell : UITableViewCell

/**
 Set and get the view model represented by the receiver.
 */
@property (strong,nonatomic) BBMediaPickerAssetsGroupViewModel *viewModel;

/**
 Set and get the content background color of the receiver. This is tied to the backgroundColor of the receiver.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic) UIColor *contentBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the selected content background color of the receiver. This is tied to the selectedBackgroundView of the receiver.
 
 The default is [UIColor lightGrayColor].
 */
@property (strong,nonatomic) UIColor *selectedContentBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the font used to display the name of the receiver.
 
 The default is [UIFont systemFontOfSize:17.0].
 */
@property (strong,nonatomic) UIFont *nameFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the color used to display the name of the receiver.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic) UIColor *nameTextColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the font used to display the count of the receiver.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic) UIFont *countFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the color used to display the count of the receiver.
 
 The default is [UIColor lightGrayColor].
 */
@property (strong,nonatomic) UIColor *countTextColor UI_APPEARANCE_SELECTOR;

/**
 Get the row height of the receiver.
 
 The default is 90.0.
 */
+ (CGFloat)rowHeight;

@end
