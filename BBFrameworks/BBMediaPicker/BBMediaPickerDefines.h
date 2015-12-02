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

#ifndef BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK
#define BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK 1
#endif

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PhotosTypes.h>
#else
#import <AssetsLibrary/ALAssetsLibrary.h>
#endif

/**
 Enum describing the authorization status of the library.
 */
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
typedef NS_ENUM(NSInteger, BBMediaPickerAuthorizationStatus) {
    /**
     The authorization status has not been determined. When attempting to access the user's media, the appropriate alert will be displayed.
     */
    BBMediaPickerAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     The authorization status has been restricted.
     */
    BBMediaPickerAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     The authorization status has been denied.
     */
    BBMediaPickerAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     The user has authorized the client to access their media.
     */
    BBMediaPickerAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};
#else
typedef NS_ENUM(NSInteger, BBMediaPickerAuthorizationStatus) {
    /**
     The authorization status has not been determined. When attempting to access the user's media, the appropriate alert will be displayed.
     */
    BBMediaPickerAuthorizationStatusNotDetermined = ALAuthorizationStatusNotDetermined,
    /**
     The authorization status has been restricted.
     */
    BBMediaPickerAuthorizationStatusRestricted = ALAuthorizationStatusRestricted,
    /**
     The authorization status has been denied.
     */
    BBMediaPickerAuthorizationStatusDenied = ALAuthorizationStatusDenied,
    /**
     The user has authorized the client to access their media.
     */
    BBMediaPickerAuthorizationStatusAuthorized = ALAuthorizationStatusAuthorized
};
#endif

/**
 Mask describing the types of media that should be displayed when using the library.
 */
typedef NS_OPTIONS(NSInteger, BBMediaPickerMediaTypes) {
    /**
     Unknown media should be displayed.
     */
    BBMediaPickerMediaTypesUnknown = 1 << 0,
    /**
     Image media should be displayed.
     */
    BBMediaPickerMediaTypesImage = 1 << 1,
    /**
     Video media should be displayed.
     */
    BBMediaPickerMediaTypesVideo = 1 << 2,
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    /**
     Audio media should be displayed.
     */
    BBMediaPickerMediaTypesAudio = 1 << 3,
    /**
     All media should be displayed.
     */
    BBMediaPickerMediaTypesAll = BBMediaPickerMediaTypesUnknown | BBMediaPickerMediaTypesImage | BBMediaPickerMediaTypesVideo | BBMediaPickerMediaTypesAudio
#else
    BBMediaPickerMediaTypesAll = BBMediaPickerMediaTypesUnknown | BBMediaPickerMediaTypesImage | BBMediaPickerMediaTypesVideo
#endif
};

/**
 Enum describing the asset collection subtypes available for display when using the library.
 */
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
typedef NS_ENUM(NSInteger, BBMediaPickerAssetCollectionSubtype) {
    /**
     An album created in the photos app.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumRegular = PHAssetCollectionSubtypeAlbumRegular,
    /**
     An event synced to the device from iPhoto.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedEvent = PHAssetCollectionSubtypeAlbumSyncedEvent,
    /**
     A faces group synced to the device from iPhoto.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedFaces = PHAssetCollectionSubtypeAlbumSyncedFaces,
    
    /**
     An album synced to the device from iPhoto.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumSyncedAlbum = PHAssetCollectionSubtypeAlbumSyncedAlbum,
    /**
     An album imported from a camera or external storage.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumImported = PHAssetCollectionSubtypeAlbumImported,
    
    /**
     The user's personal iCloud Photo Stream.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumMyPhotoStream = PHAssetCollectionSubtypeAlbumMyPhotoStream,
    /**
     An iCloud Shared Photo Stream.
     */
    BBMediaPickerAssetCollectionSubtypeAlbumCloudShared = PHAssetCollectionSubtypeAlbumCloudShared,
    
    /**
     A smart album of no more specific subtype. This subtype applies to smart albums synced to the device from iPhoto.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumGeneric = PHAssetCollectionSubtypeSmartAlbumGeneric,
    /**
     A smart album that groups all panorama photos in the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumPanorama = PHAssetCollectionSubtypeSmartAlbumPanoramas,
    /**
     A smart album that groups all video assets in the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumVideos = PHAssetCollectionSubtypeSmartAlbumVideos,
    /**
     A smart album that groups all assets the user has marked as favorites.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumFavorites = PHAssetCollectionSubtypeSmartAlbumFavorites,
    /**
     A smart album that groups all time lapse videos in the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumTimelapses = PHAssetCollectionSubtypeSmartAlbumTimelapses,
    /**
     A smart album that groups all assets hidden from the Moments view in the Photos app.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumAllHidden = PHAssetCollectionSubtypeSmartAlbumAllHidden,
    /**
     A smart album that groups assets that were recently added to the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumRecentlyAdded = PHAssetCollectionSubtypeSmartAlbumRecentlyAdded,
    /**
     A smart album that groups all burst photo sequences in the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumBursts = PHAssetCollectionSubtypeSmartAlbumBursts,
    /**
     A smart album that groups all slomo video assets in the photo library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumSlomoVideos = PHAssetCollectionSubtypeSmartAlbumSlomoVideos,
    /**
     A smart album that groups all assets that originate in the user's own library.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary = PHAssetCollectionSubtypeSmartAlbumUserLibrary,
    /**
     A smart album that groups all photos and videos captured using the device's front facing camera.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = PHAssetCollectionSubtypeSmartAlbumSelfPortraits,
    /**
     A smart album that groups all images captured using the device's screenshot function.
     */
    BBMediaPickerAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = PHAssetCollectionSubtypeSmartAlbumScreenshots
};
#else
typedef NS_ENUM(NSInteger, BBMediaPickerAssetCollectionSubtype) {
    /**
     The group that includes all assets that are synced from iTunes.
     */
    BBMediaPickerAssetCollectionSubtypeLibrary = ALAssetsGroupLibrary,
    /**
     All the albums created on the device or synced from iTunes.
     */
    BBMediaPickerAssetCollectionSubtypeAlbum = ALAssetsGroupAlbum,
    /**
     All events, including those created during Camera Connection Kit import.
     */
    BBMediaPickerAssetCollectionSubtypeEvent = ALAssetsGroupEvent,
    /**
     All the faces albums synced from iTunes.
     */
    BBMediaPickerAssetCollectionSubtypeFaces = ALAssetsGroupFaces,
    /**
     All the photos in the Camera Roll.
     */
    BBMediaPickerAssetCollectionSubtypeSavedPhotos = ALAssetsGroupSavedPhotos,
    /**
     The PhotoStream album.
     */
    BBMediaPickerAssetCollectionSubtypePhotoStream = ALAssetsGroupPhotoStream
};
#endif

/**
 Enum describing the media type of an asset.
 */
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
typedef NS_ENUM(NSInteger, BBMediaPickerAssetMediaType) {
    /**
     The media type is unknown.
     */
    BBMediaPickerAssetMediaTypeUnknown = PHAssetMediaTypeUnknown,
    /**
     The media type is an image.
     */
    BBMediaPickerAssetMediaTypeImage = PHAssetMediaTypeImage,
    /**
     The media type is a video.
     */
    BBMediaPickerAssetMediaTypeVideo = PHAssetMediaTypeVideo,
    /**
     The media type is audio.
     */
    BBMediaPickerAssetMediaTypeAudio = PHAssetMediaTypeAudio
};
#else
typedef NS_ENUM(NSInteger, BBMediaPickerAssetMediaType) {
    /**
     The media type is unknown.
     */
    BBMediaPickerAssetMediaTypeUnknown,
    /**
     The media type is an image.
     */
    BBMediaPickerAssetMediaTypeImage,
    /**
     The media type is a video.
     */
    BBMediaPickerAssetMediaTypeVideo
};
#endif

#endif /* BBMediaPickerDefines_h */
