//
//  BBMediaPickerViewController.h
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
#import "BBMediaPickerDefines.h"
#import "BBMediaPickerViewControllerDelegate.h"

/**
 BBMediaPickerViewController is a UIViewController subclass that mirrors the media browsing functionality provided by UIImagePickerController.
 */
@interface BBMediaPickerViewController : UIViewController

/**
 The authorization status of the app to access the user's media.
 
 @see BBMediaPickerAuthorizationStatus
 */
+ (BBMediaPickerAuthorizationStatus)authorizationStatus;

/**
 Set and get the delegate of the receiver.
 
 @see BBMediaPickerViewControllerDelegate
 */
@property (weak,nonatomic) id<BBMediaPickerViewControllerDelegate> delegate;

/**
 Set and get whether the receiver allows multiple selection.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL allowsMultipleSelection;
/**
 Set and get whether the receiver hides empty media groups.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL hidesEmptyMediaGroups;
/**
 Set and get whether the receiver should automatically dismiss itself when the user selects media in single selection mode.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL automaticallyDismissForSingleSelection;
/**
 Set and get the cancel bar button item title. If nil, uses the UIBarButtonSystemItemCancel item, otherwise creates a bar button item with the provided title.
 
 The default is nil.
 */
@property (copy,nonatomic) NSString *cancelBarButtonItemTitle;

/**
 Set and get the allowed media types of the receiver.
 
 The default is BBMediaPickerMediaTypesAll.
 
 @see BBMediaPickerMediaTypes
 */
@property (assign,nonatomic) BBMediaPickerMediaTypes mediaTypes;

/**
 Set and get the media filter block of the receiver. The allows the client fine grained control over the media that is displayed. The block will be invoked once for each media object after the media has been filtered according to the mediaTypes value of the receiver.
 
 The default is nil.
 
 @see BBMediaPickerMediaFilterBlock
 */
@property (copy,nonatomic) BBMediaPickerMediaFilterBlock mediaFilterBlock;

/**
 Set and get the cancel confirm block of the receiver. If non-nil, this will be invoked and the completion block value consulted before dismissing the receiver. This can be used to provide confirmation to the user before ending interaction with the receiver.
 
 The default is nil.
 
 @see BBMediaPickerCancelConfirmBlock
 */
@property (copy,nonatomic) BBMediaPickerCancelConfirmBlock cancelConfirmBlock;

@end
