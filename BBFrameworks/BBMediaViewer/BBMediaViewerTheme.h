//
//  BBMediaViewerTheme.h
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
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
 BBMediaViewerTheme allows the client to customize the appearance of the media viewer without relying on the appearance proxy methods.
 */
@interface BBMediaViewerTheme : NSObject

/**
 Set and get the name of the receiver. Useful for debugging.
 */
@property (copy,nonatomic,nullable) NSString *name;

/**
 Set and get the background color, which is used as the background color for all view controllers and the tint color for the blurred background when the transition delegate methods are implemented.
 
 The default is `[UIColor whiteColor]`.
 */
@property (strong,nonatomic,null_resettable) UIColor *backgroundColor;
/**
 Set and get the foreground color, which is used as the color for all controls (e.g. UILabel, UIButton, etc.).
 
 The default is `[UIColor blackColor]`.
 */
@property (strong,nonatomic,null_resettable) UIColor *foregroundColor;
/**
 Set and get the tint color, which is used as the active color for controls that can be toggled (e.g. play/pause UIButton).
 
 The default is `[UIApplication shareApplication].keyWindow.tintColor`.
 */
@property (strong,nonatomic,null_resettable) UIColor *tintColor;

/**
 Set and get the done bar button item, which is displayed on the left of the navigation bar.
 
 The default is a bar button item with the type `UIBarButtonSystemItemDone`.
 */
@property (strong,nonatomic,null_resettable) UIBarButtonItem *doneBarButtonItem;
/**
 Set and get the action bar button item, which is displayed on the right of the navigation bar.
 
 The default is a bar button item with the type `UIBarButtonSystemItemAction`.
 */
@property (strong,nonatomic,null_resettable) UIBarButtonItem *actionBarButtonItem;
/**
 Set and get whether the action bar button item should be shown. If NO, only the done bar button item is shown on the right hand side of the navigation bar.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL showActionBarButtonItem;

/**
 Set and get the foreground color used to fill the movie progress slider during loading.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (strong,nonatomic,null_resettable) UIColor *movieProgressForegroundColor;

/**
 Set and get the edge insets used when displaying textual content.
 
 The default is `UIEdgeInsetsMake(0, 8.0, 0, 8.0)`.
 */
@property (assign,nonatomic) UIEdgeInsets textEdgeInsets;

/**
 Get the default theme.
 
 @return The default theme
 */
+ (instancetype)defaultTheme;

@end

NS_ASSUME_NONNULL_END
