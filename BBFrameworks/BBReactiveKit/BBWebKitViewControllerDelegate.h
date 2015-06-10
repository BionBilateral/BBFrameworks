//
//  BBWebKitViewControllerDelegate.h
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

#import <Foundation/Foundation.h>

@class BBWebKitViewController;
@class WKNavigationAction,WKNavigation;

@protocol BBWebKitViewControllerDelegate <NSObject>
@optional
/*
 Asks the delegate whether the _webKitViewController_ should allow the _navigationAction_.
 
 Once the delegate determines whether the _navigationAction_ is allowed, it should invoke the _completionBlock_ with YES or NO.
 
 @param webKitViewController The `WDYRWebKitViewController` sending the message
 @param navigationAction The navigation action being evaluated
 @param completionBlock The completion block that must be invoked by the delegate
 */
- (void)webKitViewController:(BBWebKitViewController *)webKitViewController shouldAllowNavigationAction:(WKNavigationAction *)navigationAction completionBlock:(void(^)(BOOL))completionBlock;
/*
 Informs the delegate that the _webKitViewController_ finished the _navigation_.
 
 @param webKitViewController The `WDYRWebKitViewController` sending the message
 @param navigation The navigation that was finished
 */
- (void)webKitViewController:(BBWebKitViewController *)webKitViewController didFinishNavigation:(WKNavigation *)navigation;
@end
