//
//  BBMediaViewerViewController.h
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
#import "BBMediaViewerViewControllerDataSource.h"
#import "BBMediaViewerViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class BBMediaViewerTheme;

/**
 BBMediaViewerViewController is similar to `QLPreviewController`, displaying a collection of media objects. The following UTIs are supported:
 
 - `kUTTypeImage`
 - `kUTTypeGIF`, support provided by [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
 - `kUTTypeMovie`
 - `kUTTypePDF`
 - `kUTTypePlainText`
 - `kUTTypeRTFD`
 - `kUTTypeRTF`
 - `kUTTypeHTML`
 - `kUTTypeURL`
 
 As a fallback, any document type that `UIWebView` can display is also supported.
 */
@interface BBMediaViewerViewController : UIViewController

/**
 Set and get the data source of the receiver.
 
 @see BBMediaViewerViewControllerDataSource
 */
@property (weak,nonatomic,nullable) id<BBMediaViewerViewControllerDataSource> dataSource;
/**
 Set and get the delegate of the receiver.
 
 @see BBMediaViewerViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<BBMediaViewerViewControllerDelegate> delegate;

/**
 Set and get the theme of the receiver.
 
 The default is `[BBMediaViewerTheme defaultTheme]`.
 */
@property (strong,nonatomic,null_resettable) BBMediaViewerTheme *theme;

@end

NS_ASSUME_NONNULL_END
