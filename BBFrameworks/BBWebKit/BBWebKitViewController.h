//
//  BBWebKitViewController.h
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
#import "BBWebKitViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class BBWebKitTheme;

/**
 BBWebKitViewController is a UIViewController subclass that manages a WKWebView to display web content.
 */
@interface BBWebKitViewController : UIViewController

/*
 Get and set the receiver's delegate.
 
 @see BBWebKitViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<BBWebKitViewControllerDelegate> delegate;

/**
 Set and get the theme used by the receiver.
 
 The default is `[BBWebKitTheme defaultTheme]`.
 
 @see BBWebKitTheme
 */
@property (strong,nonatomic,null_resettable) BBWebKitTheme *theme;

/**
 Set and get the custom title of the receiver. If this is non-nil, the receiver's title will be set to this value. Otherwise the receiver's title tracks the title of the managed WKWebView.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *customTitle;

/**
 Set and get whether the receiver should show the standard system share bar button item.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL showShareBarButtonItem;

/*
 Get and set whether the navigation toolbar should be shown.
 
 Calls `-[self setShowNavigationToolbar:animated:]`, passing _showNavigationToolbar_ and NO respectively.
 */
@property (assign,nonatomic) BOOL showNavigationToolbar;
/*
 Set whether the navigation toolbar should be shown, with optional animation.
 
 The navigation toolbar includes back, forward, stop, refresh, and share items.
 
 @param showNavigationToolbar Whether or not to show the navigation toolbar
 @param animated Whether or not to animated the change
 */
- (void)setShowNavigationToolbar:(BOOL)showNavigationToolbar animated:(BOOL)animated;

/*
 Instructs the managed `WKWebView` instance to load _URLString_.
 
 Calls `loadURL:` passing `[NSURL URLWithString:_URLString_]`.
 
 @param URLString The url string to load
 */
- (void)loadURLString:(NSString *)URLString;
/*
 Instructs the managed `WKWebView` instance to load _URL_.
 
 Calls `loadURLRequest:` passing `[NSURLRequest requestWithURL:_URL_]`.
 
 @param URL The url to load
 */
- (void)loadURL:(NSURL *)URL;
/*
 Instructs the managed `WKWebView` instance to load _URLRequest_.
 
 Calls `loadRequest` on the managed `WKWebView` instance.
 
 @param URLRequest The url request to load
 */
- (void)loadURLRequest:(NSURLRequest *)URLRequest;

@end

@interface UIViewController (BBWebKitViewControllerExtensions)

/*
 Calls `BB_presentWebKitViewControllerForURL:` passing `[NSURL URLWithString:_URLString_]`.
 
 @param URLString The url string to load in the presented `BBWebKitViewController`
 */
- (void)BB_presentWebKitViewControllerForURLString:(NSString *)URLString;
/*
 Calls `BB_presentedWebKitViewControllerForURLRequest:` passing `[NSURLRequest requestWithURL:_URL_]`.
 
 @param URL The url to load in the presented `BBWebKitViewController`
 */
- (void)BB_presentWebKitViewControllerForURL:(NSURL *)URL;
/*
 Calls `BB_presentWebKitViewControllerForURLRequest:navigationControllerClass:`, passing _URLRequest_ and `[UINavigationController class]` respectively.
 
 @param URLRequest The request to load in the presented `BBWebKitViewController`
 */
- (void)BB_presentWebKitViewControllerForURLRequest:(NSURLRequest *)URLRequest;

/*
 Calls `BB_presentWebKitViewControllerForURL:navigationControllerClass:`, passing `[NSURL URLWithString:_URLString_]` and _navigationControllerClass_ respectively.
 
 @param URLString The url string to load in the presented `BBWebKitViewController`
 @param navigationControllerClass The custom `UINavigationController` subclass to use when presenting the `BBWebKitViewController`
 */
- (void)BB_presentWebKitViewControllerForURLString:(NSString *)URLString navigationControllerClass:(Class)navigationControllerClass;
/*
 Calls `BB_presentWebKitViewControllerForURLRequest:navigationControllerClass:`, passing `[NSURLRequest requestWithURL:_URL_]` and _navigationControllerClass_ respectively.
 
 @param URL The url to load in the presented `BBWebKitViewController`
 @param navigationControllerClass The custom `UINavigationController` subclass to use when presenting the `BBWebKitViewController`
 */
- (void)BB_presentWebKitViewControllerForURL:(NSURL *)URL navigationControllerClass:(Class)navigationControllerClass;
/*
 Convenience method to present a modal `WDYRWebKitViewController` embedded in a `UINavigationController`.
 
 This method will create a `UINavigationController` with a `WDYRProgressNavigationBar` for the presented `WDYRWebKitViewController` to access.
 
 @param URLRequest The url request to load in the presented `BBWebKitViewController`
 @param navigationControllerClass The custom `UINavigationController` subclass to use when presenting the `BBWebKitViewController`
 @exception NSException Thrown if _URLRequest_ or _navigationControllerClass_ are nil
 */
- (void)BB_presentWebKitViewControllerForURLRequest:(NSURLRequest *)URLRequest navigationControllerClass:(Class)navigationControllerClass;

@end

NS_ASSUME_NONNULL_END
