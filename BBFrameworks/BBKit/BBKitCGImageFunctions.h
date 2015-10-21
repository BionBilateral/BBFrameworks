//
//  BBKitCGImageFunctions.h
//  BBFrameworks
//
//  Created by William Towe on 5/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_KIT_CGIMAGE_FUNCTIONS__
#define __BB_FRAMEWORKS_KIT_CGIMAGE_FUNCTIONS__

#import <CoreGraphics/CGImage.h>

/**
 Returns whether _imageRef_ has an alpha component.
 
 @param imageRef The CGImage to inspect
 @return YES if _imageRef_ has alpha, otherwise NO
 */
extern bool BBKitCGImageHasAlpha(CGImageRef imageRef);

/**
 Calls `BBKitCGImageCreateThumbnailWithSizeMaintainingAspectRatio()`, passing _imageRef_, _size_, and true respectively. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage to resize
 @param size The desired size of the resulting thumbnail image
 @return The thumbnail image
 @exception NSException Thrown if _imageRef_ is NULL or _size_ is equal to CGSizeZero
 */
extern CGImageRef BBKitCGImageCreateThumbnailWithSize(CGImageRef imageRef, CGSize size);
/**
 Creates a new CGImage by resizing _imageRef_ to _size_ and optionally maintaining the aspect ratio of imageRef. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage to use in thumbnail creation
 @param size That target size of the thumbnail
 @param maintainAspectRatio Whether to maintain the aspect ratio of the resulting thumbnail image
 @return The CGImage thumbnail
 @exception NSException Thrown if _imageRef_ is NULL or _size_ is equal to CGSizeZero
 */
extern CGImageRef BBKitCGImageCreateThumbnailWithSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio);

/**
 Creates a new CGImage by blurring the provided imageRef using a box filter with radius. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage to blur
 @param radius The radius of the box filter to produce the blur
 @return The blurred CGImage
 @exception NSException Thrown if _imageRef_ is NULL
 */
extern CGImageRef BBKitCGImageCreateImageByBlurringImageWithRadius(CGImageRef imageRef, CGFloat radius);
/**
 Creates a new CGImage by adjusting the brightness of the provided imageRef by delta. The delta parameter should be between -1.0 and 1.0. Larger values are clamped. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage whose brightness to adjust
 @param delta The amount to adjust brightness by
 @return The image with its brightness adjusted
 @exception NSException Thrown if _imageRef_ is NULL
 */
extern CGImageRef BBKitCGImageCreateImageByAdjustingBrightnessOfImageByDelta(CGImageRef imageRef, CGFloat delta);
/**
 Creates a new CGImage by adjusting the contrast of the provided imageRef by delta. The delta parameter should be between -1.0 and 1.0. Larger values are clamped. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage whose contrast to adjust
 @param delta The amount to adjust contrast by
 @return The image with its contrast adjusted
 @exception NSException Thrown if _imageRef_ is NULL
 */
extern CGImageRef BBKitCGImageCreateImageByAdjustingContrastOfImageByDelta(CGImageRef imageRef, CGFloat delta);
/**
 Creates a new CGImage by adjusting the saturation of the provided imageRef by delta. The delta parameter should be greater than or less than 1.0. The caller is responsible for releasing the returned CGImage.
 
 @param imageRef The CGImage whose saturation to adjust
 @param delta The amount to adjust saturation by
 @return The image with its saturation adjusted
 @exception NSException Thrown if _imageRef_ is NULL
 */
extern CGImageRef BBKitCGImageCreateImageByAdjustingSaturationOfImageByDelta(CGImageRef imageRef, CGFloat delta);

#endif
