//
//  PHAsset+BBMediaPickerExtensions.m
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

#import "PHAsset+BBMediaPickerExtensions.h"
#import "BBFoundationFunctions.h"
#import "BBFoundationDebugging.h"

#import <Photos/Photos.h>

@implementation PHAsset (BBMediaPickerExtensions)

- (void)BB_requestImageWithCompletion:(void(^)(UIImage *_Nullable image, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    if (self.mediaType != PHAssetMediaTypeImage) {
        BBLog(@"called %@ with asset of type %@, returning early",NSStringFromSelector(_cmd),@(self.mediaType));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil);
        });
        return;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setVersion:PHImageRequestOptionsVersionCurrent];
    [options setResizeMode:PHImageRequestOptionsResizeModeNone];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(result,info[PHImageErrorKey]);
        });
    }];
}
- (void)BB_requestImageDataWithCompletion:(void(^)(NSData *_Nullable data, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    if (self.mediaType != PHAssetMediaTypeImage) {
        BBLog(@"called %@ with asset of type %@, returning early",NSStringFromSelector(_cmd),@(self.mediaType));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil,0,nil);
        });
        return;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setVersion:PHImageRequestOptionsVersionCurrent];
    [options setResizeMode:PHImageRequestOptionsResizeModeNone];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(imageData,dataUTI,orientation,info[PHImageErrorKey]);
        });
    }];
}

- (void)BB_requestLivePhotoWithCompletion:(void(^)(PHLivePhoto *_Nullable livePhoto, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    if ((self.mediaSubtypes & PHAssetMediaSubtypePhotoLive) == 0) {
        BBLog(@"called %@ with asset of subtype %@, returning early",NSStringFromSelector(_cmd),@(self.mediaSubtypes));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil);
        });
        return;
    }
    
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestLivePhotoForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(livePhoto,info[PHImageErrorKey]);
        });
    }];
}

- (void)BB_requestPlayerItemWithCompletion:(void(^)(AVPlayerItem *_Nullable playerItem, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    if (self.mediaType != PHAssetMediaTypeVideo) {
        BBLog(@"called %@ with asset of type %@, returning early",NSStringFromSelector(_cmd),@(self.mediaType));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil);
        });
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setVersion:PHVideoRequestOptionsVersionCurrent];
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeMediumQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(playerItem,info[PHImageErrorKey]);
        });
    }];
}
- (void)BB_requestAssetExportSessionWithExportPreset:(NSString *)exportPreset completion:(void(^)(AVAssetExportSession *_Nullable assetExportSession, NSError *_Nullable error))completion; {
    NSParameterAssert(exportPreset);
    NSParameterAssert(completion);
    
    if (self.mediaType != PHAssetMediaTypeVideo) {
        BBLog(@"called %@ with asset of type %@, returning early",NSStringFromSelector(_cmd),@(self.mediaType));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil);
        });
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setVersion:PHVideoRequestOptionsVersionCurrent];
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:self options:options exportPreset:exportPreset resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(exportSession,info[PHImageErrorKey]);
        });
    }];
}
- (void)BB_requestAVAssetAndAudioMixWithCompletion:(void(^)(AVAsset *_Nullable asset, AVAudioMix *_Nullable audioMix, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    if (self.mediaType != PHAssetMediaTypeVideo) {
        BBLog(@"called %@ with asset of type %@, returning early",NSStringFromSelector(_cmd),@(self.mediaType));
        BBDispatchMainSyncSafe(^{
            completion(nil,nil,nil);
        });
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setVersion:PHVideoRequestOptionsVersionCurrent];
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    [options setNetworkAccessAllowed:YES];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BBDispatchMainSyncSafe(^{
            completion(asset,audioMix,info[PHImageErrorKey]);
        });
    }];
}

@end
