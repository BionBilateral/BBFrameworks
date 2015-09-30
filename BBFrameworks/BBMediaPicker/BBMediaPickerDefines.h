//
//  BBMediaPickerDefines.h
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

#ifndef __BB_FRAMEWORKS_MEDIA_PICKER_DEFINES__
#define __BB_FRAMEWORKS_MEDIA_PICKER_DEFINES__

#import "BBMediaPickerMedia.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the authorization status.
 */
typedef NS_ENUM(NSInteger, BBMediaPickerAuthorizationStatus) {
    /**
     The authorization status has not been determined. The appropriate alert will be presented to the user to ask for access.
     */
    BBMediaPickerAuthorizationStatusNotDetermined = ALAuthorizationStatusNotDetermined,
    /**
     The authorization status has been restricted.
     */
    BBMediaPickerAuthorizationStatusRestricted = ALAuthorizationStatusRestricted,
    /**
     The authorization status has been denied by the user.
     */
    BBMediaPickerAuthorizationStatusDenied = ALAuthorizationStatusDenied,
    /**
     The authorization status has been authorized.
     */
    BBMediaPickerAuthorizationStatusAuthorized = ALAuthorizationStatusAuthorized
};

/**
 Options mask describing the allowed media types of the media picker.
 */
typedef NS_OPTIONS(NSInteger, BBMediaPickerMediaTypes) {
    /**
     Photo media is allowed.
     */
    BBMediaPickerMediaTypesPhoto = 1 << 0,
    /**
     Video media is allowed.
     */
    BBMediaPickerMediaTypesVideo = 1 << 1,
    /**
     Unknown media is allowed. For example, sound files.
     */
    BBMediaPickerMediaTypesUnknown = 1 << 2,
    /**
     All media is allowed.
     */
    BBMediaPickerMediaTypesAll = BBMediaPickerMediaTypesPhoto | BBMediaPickerMediaTypesVideo | BBMediaPickerMediaTypesUnknown
};

@class BBMediaPickerViewController;

/**
 Block used to filter media that will be displayed by the media picker. The block will be invoked once for each media object.
 
 @param media The media object to display
 @return YES to display the media object, NO to hide it
 */
typedef BOOL(^BBMediaPickerMediaFilterBlock)(id<BBMediaPickerMedia> media);

/**
 Block used to complete the invocation of a BBMediaPickerCancelConfirmBlock and inform the media picker if it should dismiss itself.
 
 @param confirm YES if the media should dismiss, NO otherwise
 */
typedef void(^BBMediaPickerCancelConfirmCompletionBlock)(BOOL confirm);
/**
 Block used to confirm whether the media picker should dismiss itself. Once the desired behavior is determined, the block should invoke the passed in completion block with YES or NO.
 
 @param viewController The media picker view controller that invoked the block
 @param completion The completion block that should be invoked with the desired behavior
 */
typedef void(^BBMediaPickerCancelConfirmBlock)(BBMediaPickerViewController *viewController, BBMediaPickerCancelConfirmCompletionBlock completion);

NS_ASSUME_NONNULL_END

#endif
