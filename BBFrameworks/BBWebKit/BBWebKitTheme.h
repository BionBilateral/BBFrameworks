//
//  BBWebKitTheme.h
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
 BBWebKitTheme allows the client to customize the appearance of the BBWebKit classes without relying on the availability of the appearance proxy methods.
 */
@interface BBWebKitTheme : NSObject <NSCopying>

/**
 Set and get the name of the receiver. Useful for debugging.
 */
@property (copy,nonatomic,nullable) NSString *name;

@property (strong,nonatomic,null_resettable) UIFont *titleFont;
@property (strong,nonatomic,null_resettable) UIColor *titleTextColor;
@property (strong,nonatomic,null_resettable) UIFont *URLFont;
@property (strong,nonatomic,null_resettable) UIColor *URLTextColor;

@property (strong,nonatomic,null_resettable) UIImage *hasOnlySecureContentImage;

/**
 Set and get the done bar button item which dismisses the owning BBWebKitViewController when presented modally. The bar button item is displayed on the left hand side if the receiver does not have access to an instance of BBProgressNavigationBar, otherwise the bar button item is displayed on the right hand side.
 */
@property (strong,nonatomic,null_resettable) UIBarButtonItem *doneBarButtonItem;

/**
 Set and get the go back image, which is used as the image for the go back bar button item in the toolbar.
 
 The default is @"web_kit_go_back" in the resources bundle.
 */
@property (strong,nonatomic,null_resettable) UIImage *goBackImage;
/**
 Set and get the go forward image, which is used as the image for the go forward bar button item in the toolbar.
 
 The default is @"web_kit_go_forward" in the resources bundle.
 */
@property (strong,nonatomic,null_resettable) UIImage *goForwardImage;

/**
 Get the default theme. BBWebKitViewController uses this theme by default.
 
 @return The default theme
 */
+ (instancetype)defaultTheme;

@end

NS_ASSUME_NONNULL_END
