//
//  BBMediaPickerDefines.h
//  BBFrameworks
//
//  Created by William Towe on 11/13/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_MEDIA_PICKER_DEFINES__
#define __BB_MEDIA_PICKER_DEFINES__

#import <Foundation/Foundation.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PhotosTypes.h>

typedef NS_ENUM(NSInteger, BBMediaPickerAuthorizationStatus) {
    BBMediaPickerAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    BBMediaPickerAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    BBMediaPickerAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    BBMediaPickerAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};

typedef NS_OPTIONS(NSInteger, BBMediaPickerMediaTypes) {
    BBMediaPickerMediaTypesUnknown = 1 << 0,
    BBMediaPickerMediaTypesImage = 1 << 1,
    BBMediaPickerMediaTypesVideo = 1 << 2,
    BBMediaPickerMediaTypesAudio = 1 << 3,
    BBMediaPickerMediaTypesAll = BBMediaPickerMediaTypesUnknown | BBMediaPickerMediaTypesImage | BBMediaPickerMediaTypesVideo | BBMediaPickerMediaTypesAudio
};

typedef NS_ENUM(NSInteger, BBMediaPickerAssetCollectionSubtype) {
    BBMediaPickerAssetCollectionSubtypeAlbumRegular = PHAssetCollectionSubtypeAlbumRegular,
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedEvent = PHAssetCollectionSubtypeAlbumSyncedEvent,
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedFaces = PHAssetCollectionSubtypeAlbumSyncedFaces,
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedAlbum = PHAssetCollectionSubtypeAlbumSyncedAlbum,
    BBMediaPickerAssetCollectionSubtypeAlbumImported = PHAssetCollectionSubtypeAlbumImported,
    
    BBMediaPickerAssetCollectionSubtypeAlbumMyPhotoStream = PHAssetCollectionSubtypeAlbumMyPhotoStream,
    BBMediaPickerAssetCollectionSubtypeAlbumCloudShared = PHAssetCollectionSubtypeAlbumCloudShared,
    
    BBMediaPickerAssetCollectionSubtypeSmartAlbumGeneric = PHAssetCollectionSubtypeSmartAlbumGeneric,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumPanorama = PHAssetCollectionSubtypeSmartAlbumPanoramas,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumVideos = PHAssetCollectionSubtypeSmartAlbumVideos,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumFavorites = PHAssetCollectionSubtypeSmartAlbumFavorites,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumTimelapses = PHAssetCollectionSubtypeSmartAlbumTimelapses,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumAllHidden = PHAssetCollectionSubtypeSmartAlbumAllHidden,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumRecentlyAdded = PHAssetCollectionSubtypeSmartAlbumRecentlyAdded,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumBursts = PHAssetCollectionSubtypeSmartAlbumBursts,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumSlomoVideos = PHAssetCollectionSubtypeSmartAlbumSlomoVideos,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary = PHAssetCollectionSubtypeSmartAlbumUserLibrary,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = PHAssetCollectionSubtypeSmartAlbumSelfPortraits,
    BBMediaPickerAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = PHAssetCollectionSubtypeSmartAlbumScreenshots
};

typedef NS_ENUM(NSInteger, BBMediaPickerAssetMediaType) {
    BBMediaPickerAssetMediaTypeUnknown = PHAssetMediaTypeUnknown,
    BBMediaPickerAssetMediaTypeImage = PHAssetMediaTypeImage,
    BBMediaPickerAssetMediaTypeVideo = PHAssetMediaTypeVideo,
    BBMediaPickerAssetMediaTypeAudio = PHAssetMediaTypeAudio
};

#endif /* BBMediaPickerDefines_h */
