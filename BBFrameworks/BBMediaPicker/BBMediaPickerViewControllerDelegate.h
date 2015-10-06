//
//  BBMediaPickerViewControllerDelegate.h
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

#import <Foundation/Foundation.h>
#import "BBMediaPickerMedia.h"

NS_ASSUME_NONNULL_BEGIN

@class BBMediaPickerViewController;

/**
 Protocol for BBMediaPickerViewController delegate.
 */
@protocol BBMediaPickerViewControllerDelegate <NSObject>
@optional
/**
 Called when the user taps on a grid image to select it.
 
 @param viewController The media picker view controller that sent the message
 @param media The media object that was selected
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didSelectMedia:(id<BBMediaPickerMedia>)media;
/**
 Called when the user taps on a previously selected grid image to deselect it.
 
 @param viewController The media picker view controller that sent the message
 @param media The media object that was deselected
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didDeselectMedia:(id<BBMediaPickerMedia>)media;
/**
 Called when the user taps the Done bar button item in multiple selection mode or selects a single image in single selection mode.
 
 @param viewController The media picker view controller that sent the message
 @param media The array of media objects that were selected
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didFinishPickingMedia:(NSArray<id<BBMediaPickerMedia> > *)media;
/**
 Called when the user taps the Cancel bar button item.
 
 @param viewController The media picker view controller that sent the message
 */
- (void)mediaPickerViewControllerDidCancel:(BBMediaPickerViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
