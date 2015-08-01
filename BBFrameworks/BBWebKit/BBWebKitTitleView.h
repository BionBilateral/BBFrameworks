//
//  BBWebKitTitleView.h
//  BBFrameworks
//
//  Created by William Towe on 6/9/15.
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

@class WKWebView;

/**
 BBWebKitTitleView is a UIView subclass that displays the document title and URL of its associated WKWebView. If the hasOnlySecureContent flag on the WKWebView is YES, the hasOnlySecureContentImage will be displayed to the left of the URL.
 
 The feature set of this class was modeled after the in app browser used in the Twitter app.
 */
@interface BBWebKitTitleView : UIView

/**
 Set and get the font used to display the title.
 
 The default is [UIFont boldSystemFontOfSize:15.0].
 */
@property (strong,nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the color used to display the title.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;

/**
 Set and get the font used to display the URL.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic) UIFont *URLFont UI_APPEARANCE_SELECTOR;
/**
 Set and get the color used to display the URL.
 
 The default is [UIColor darkGrayColor].
 */
@property (strong,nonatomic) UIColor *URLTextColor UI_APPEARANCE_SELECTOR;

/**
 Set and get the secure content image of the receiver.
 */
@property (strong,nonatomic) UIImage *hasOnlySecureContentImage UI_APPEARANCE_SELECTOR;

/**
 Designated Initializer.
 
 @param webKitView The web view associated with the receiver
 @return An initialized instance of the receiver
 */
- (instancetype)initWithWebKitView:(WKWebView *)webKitView NS_DESIGNATED_INITIALIZER;

@end
