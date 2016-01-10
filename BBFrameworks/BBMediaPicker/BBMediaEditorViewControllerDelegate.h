//
//  BBMediaEditorViewControllerDelegate.h
//  BBFrameworks
//
//  Created by Jason Anderson on 1/10/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import "BBMediaPickerMedia.h"

NS_ASSUME_NONNULL_BEGIN

@class BBMediaEditorViewController;

/**
 BBMediaEditorViewControllerDelegate is a protocol describing the delegate methods supported by an instance of BBMediaEditorViewController.
 */
@protocol BBMediaEditorViewControllerDelegate <NSObject>
@optional
/**
 Called when the media editor finishes sizing/cropping of the selected media image.
 
 @parameter viewController The media editor that sent the message
 @parameter media The media that was edited
 */
- (void)mediaEditorViewController:(BBMediaEditorViewController *)viewController didFinishEditingMedia:(id<BBMediaPickerMedia>)media;

/**
 Informs the delegate that the asset editing was cancelled. The delegate is responsible for dismissing the media editor view controller.
 
 @parameter viewController The media editor that sent the message
 */
- (void)mediaEditorViewControllerDidCancel:(BBMediaEditorViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
