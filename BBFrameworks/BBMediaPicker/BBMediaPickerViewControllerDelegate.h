//
//  BBMediaPickerViewControllerDelegate.h
//  BBFrameworks
//
//  Created by William Towe on 11/14/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
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
 BBMediaPickerViewControllerDelegate is a protocol describing the delegate methods supported by an instance of BBMediaPickerViewController.
 */
@protocol BBMediaPickerViewControllerDelegate <NSObject>
@optional
/**
 Returns whether the media should be selected.
 
 @param viewController The media picker that sent the message
 @param media The media that is about to be selected
 @return YES if the media should be selected, otherwise NO
 */
- (BOOL)mediaPickerViewController:(BBMediaPickerViewController *)viewController shouldSelectMedia:(id<BBMediaPickerMedia>)media;
/**
 Returns whether the media should be deselected.
 
 @param viewController The media picker that sent the message
 @param media The media that is about to be deselected
 @return YES if the media should be deselected, otherwise NO
 */
- (BOOL)mediaPickerViewController:(BBMediaPickerViewController *)viewController shouldDeselectMedia:(id<BBMediaPickerMedia>)media;

/**
 Informs the delegate that a single media was selected.
 
 @param viewController The media picker that sent the message
 @param media The media that was selected
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didSelectMedia:(id<BBMediaPickerMedia>)media;
/**
 Informs the delegate that a single media was deselected.
 
 @param viewController The media picker that sent the message
 @param media The media that was deselected
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didDeselectMedia:(id<BBMediaPickerMedia>)media;

/**
 Informs the delegate that the user either selected a single media in the single selection mode, or selected multiple media in multiple selection mode and tapped the done bar button item. The delegate is responsible for dismissing the media picker.
 
 @param viewController The media picker that sent the message
 @param media The array of media objects
 */
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didFinishPickingMedia:(NSArray<id<BBMediaPickerMedia> > *)media;
/**
 Informs the delegate that the user cancelled interaction with the media picker by tapping the cancel bar button item. The delegate is responsible for dismissing the media picker.
 
 @param viewController The media picker that sent the message
 */
- (void)mediaPickerViewControllerDidCancel:(BBMediaPickerViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
