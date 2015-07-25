//
//  BBAssetsPickerViewModel.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerViewModel.h"
#import "BBMediaPickerCollectionViewModel.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMediaPickerViewModel () <PHPhotoLibraryChangeObserver>
@property (readwrite,copy,nonatomic) NSArray *assetGroupViewModels;

@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;

@property (readwrite,strong,nonatomic) PHCachingImageManager *imageManager;

- (void)_reloadAssetGroupViewModels;
@end

@implementation BBMediaPickerViewModel
#pragma mark *** Subclass Overrides ***
- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                 @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                 @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                 @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                 @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                 @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                 @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                 @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                 @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                 @(PHAssetCollectionSubtypeSmartAlbumAllHidden),
                                 @(PHAssetCollectionSubtypeSmartAlbumGeneric),
                                 @(PHAssetCollectionSubtypeAlbumRegular),
                                 @(PHAssetCollectionSubtypeAlbumSyncedAlbum),
                                 @(PHAssetCollectionSubtypeAlbumSyncedEvent),
                                 @(PHAssetCollectionSubtypeAlbumSyncedFaces),
                                 @(PHAssetCollectionSubtypeAlbumImported),
                                 @(PHAssetCollectionSubtypeAlbumCloudShared)];
    
    @weakify(self);
    [self setCancelCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self.didBecomeActiveSignal
     subscribeNext:^(BBMediaPickerViewModel *value) {
         [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:value];
     }];
    
    [self.didBecomeInactiveSignal
     subscribeNext:^(BBMediaPickerViewModel *value) {
         [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:value];
     }];
    
    [self setImageManager:[[PHCachingImageManager alloc] init]];
    [self.imageManager setAllowsCachingHighQualityImages:NO];
    
    [[[self requestAssetsLibraryAuthorizationStatus]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if (value.boolValue) {
             [self _reloadAssetGroupViewModels];
         }
     }];
    
    return self;
}
#pragma mark PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    BBLogObject(changeInstance);
}
#pragma mark *** Public Methods ***
- (RACSignal *)requestAssetsLibraryAuthorizationStatus; {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [subscriber sendNext:@([BBMediaPickerViewController authorizationStatus] == BBMediaPickerViewControllerAuthorizationStatusAuthorized)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)requestThumbnailImageForAsset:(PHAsset *)asset size:(CGSize)size; {
    NSParameterAssert(asset);
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return [RACSignal return:nil];
    }
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        
        [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
        [options setNetworkAccessAllowed:YES];
        
        PHImageRequestID requestID = [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.imageManager cancelImageRequest:requestID];
        }];
    }];
}
#pragma mark *** Private Methods ***
- (void)_reloadAssetGroupViewModels; {
    NSMutableArray *assetsGroupViewModels = [[NSMutableArray alloc] init];
    NSArray *subtypes = self.assetCollectionSubtypes;
    
    for (NSNumber *subtype in subtypes) {
        PHAssetCollectionType type = subtype.integerValue >= PHAssetCollectionSubtypeSmartAlbumGeneric ? PHAssetCollectionTypeSmartAlbum : PHAssetCollectionTypeAlbum;
        PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:subtype.integerValue options:nil];
        
        for (PHAssetCollection *collection in result) {
            [assetsGroupViewModels addObject:[[BBMediaPickerCollectionViewModel alloc] initWithAssetsGroup:collection viewModel:self]];
        }
    }
    
    [self setAssetGroupViewModels:assetsGroupViewModels];
}
#pragma mark Properties

@end
