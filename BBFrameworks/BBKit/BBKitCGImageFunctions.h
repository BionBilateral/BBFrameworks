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
 Creates a new CGImage by resizing _imageRef_ to _size_ while maintaining the aspect ratio of _imageRef_.
 
 The returned CGImage follows the create rule and must be released by the caller. See https://developer.apple.com/library/ios/documentation/CoreFoundation/Conceptual/CFMemoryMgmt/Concepts/Ownership.html for more information.
 
 @param imageRef The CGImage to use in thumbnail creation
 @param size That target size of the thumbnail
 @return The CGImage thumbnail
 @exception NSException Thrown if _imageRef_ is NULL or _size_ is equal to CGSizeZero
 */
extern CGImageRef BBKitCGImageCreateThumbnailWithSize(CGImageRef imageRef, CGSize size);

#endif
