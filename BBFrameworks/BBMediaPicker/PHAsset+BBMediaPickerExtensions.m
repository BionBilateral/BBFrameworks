//
//  PHAsset+BBMediaPickerExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 11/20/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "PHAsset+BBMediaPickerExtensions.h"

#import <Photos/Photos.h>

@implementation PHAsset (BBMediaPickerExtensions)

- (NSData *)BB_imageData; {
    __block NSData *retval = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setSynchronous:YES];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        retval = imageData;
    }];
    
    return retval;
}
- (void)BB_requestImageDataWithCompletion:(void(^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation))completion; {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        completion(imageData,dataUTI,orientation);
    }];
}

- (AVAsset *)BB_videoAsset; {
    __block AVAsset *retval = nil;
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        retval = asset;
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return retval;
}
- (void)BB_requestVideoAssetWithCompletion:(void(^)(AVAsset *videoAsset))completion; {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        completion(asset);
    }];
}

@end
