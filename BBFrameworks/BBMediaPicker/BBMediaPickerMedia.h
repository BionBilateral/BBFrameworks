//
//  BBMediaPickerMedia.h
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
#import "BBMediaPickerDefines.h"

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/PHAsset.h>
#else
#import <AssetsLibrary/ALAsset.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 BBMediaPickerMedia is a protocol describing model items vended by the media picker classes. Depending on the version of the library used, the model objects either wrap a PHAsset or ALAsset.
 */
@protocol BBMediaPickerMedia <NSObject>
@required
/**
 The underlying asset wrapped by the model object.
 
 @return The underlying asset
 */
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (PHAsset *)mediaAsset;
#else
- (ALAsset *)mediaAsset;
#endif
/**
 Type media type of the underlying asset (e.g. image, video).
 
 @return The asset media type
 */
- (BBMediaPickerAssetMediaType)mediaAssetType;
@end

NS_ASSUME_NONNULL_END
