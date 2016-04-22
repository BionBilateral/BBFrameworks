//
//  BBMediaViewerDefines.h
//  BBFrameworks
//
//  Created by William Towe on 2/29/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_MEDIA_VIEWER_DEFINES__
#define __BB_MEDIA_VIEWER_DEFINES__

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Typedef for a block that is invoked after a remote resource has been downloaded.
 
 @param success YES if the file was downloaded successfully, otherwise NO
 @param error Optionally, an error describing the reason the download failed
 */
typedef void(^BBMediaViewerDownloadCompletionBlock)(BOOL success, NSError * _Nullable error);
/**
 Typedef for a block that is invoked after an AVAsset for a piece of media has been created.
 
 @param asset The asset or nil
 @param error The error or nil
 */
typedef void(^BBMediaViewerCreateAssetCompletionBlock)(AVAsset * _Nullable asset, NSError * _Nullable error);

NS_ASSUME_NONNULL_END

#endif
