//
//  PHAsset+BBMediaPickerExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 1/4/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Photos/PHAsset.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Category adding convenience methods to PHAsset for fetching full size assets.
 */
@interface PHAsset (BBMediaPickerExtensions)

/**
 Requests the full size image represented by the asset and invokes the completion handler when the operation completes. The completion block is always invoked on the main thread. If the asset is not an image asset, the completion block is invoked immediately with nil for both parameters.
 
 @param completion The completion block to invoke on completion
 @exception NSException Thrown if completion is nil
 */
- (void)BB_requestImageWithCompletion:(void(^)(UIImage *_Nullable image, NSError *_Nullable info))completion;

@end

NS_ASSUME_NONNULL_END
