//
//  BBMediaPickerAssetCollectionModel.m
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

#import "BBMediaPickerAssetCollectionModel.h"
#import "BBMediaPickerModel.h"
#import "BBMediaPickerAssetModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerTheme.h"

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/Photos.h>
#else
#import "ALAssetsGroup+BBMediaPickerExtensions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface BBMediaPickerAssetCollectionModel ()
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
@property (readwrite,strong,nonatomic) PHAssetCollection *assetCollection;
@property (readwrite,strong,nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (assign,nonatomic) PHImageRequestID firstImageRequestID, secondImageRequestID, thirdImageRequestID;
@property (strong,nonatomic) NSMutableDictionary *thumbnailIndexesToImageRequestIDs;
#else
@property (readwrite,strong,nonatomic) ALAssetsGroup *assetCollection;
#endif
@property (readwrite,weak,nonatomic) BBMediaPickerModel *model;

- (void)_cancelThumbnailImageRequestAtIndex:(NSUInteger)thumbnailIndex;
@end

@implementation BBMediaPickerAssetCollectionModel

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(BBMediaPickerModel *)model; {
#else
- (instancetype)initWithAssetCollection:(ALAssetsGroup *)assetCollection model:(BBMediaPickerModel *)model; {
#endif
    if (!(self = [super init]))
        return nil;
    
    [self setAssetCollection:assetCollection];
    [self setModel:model];
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    [self setThumbnailIndexesToImageRequestIDs:[[NSMutableDictionary alloc] init]];
#endif
    
    [self reloadFetchResult];
    
    return self;
}

- (BBMediaPickerAssetCollectionSubtype)subtype {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return (BBMediaPickerAssetCollectionSubtype)self.assetCollection.assetCollectionSubtype;
#else
    return (BBMediaPickerAssetCollectionSubtype)[[self.assetCollection valueForProperty:ALAssetsGroupPropertyType] integerValue];
#endif
}
- (NSString *)title {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return self.assetCollection.localizedTitle;
#else
    return [self.assetCollection valueForProperty:ALAssetsGroupPropertyName];
#endif
}
- (NSString *)subtitle {
    return [NSNumberFormatter localizedStringFromNumber:@(self.countOfAssetModels) numberStyle:NSNumberFormatterDecimalStyle];
}
- (UIImage *)typeImage {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    switch (self.assetCollection.assetCollectionSubtype) {
        case PHAssetCollectionSubtypeSmartAlbumVideos:
        case PHAssetCollectionSubtypeSmartAlbumSlomoVideos:
            return self.model.theme.assetTypeVideoImage;
        default:
            return nil;
    }
#else
    return nil;
#endif
}

- (NSUInteger)countOfAssetModels {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return self.fetchResult.count;
#else
    return [self.assetCollection numberOfAssets];
#endif
}
- (BBMediaPickerAssetModel *)assetModelAtIndex:(NSUInteger)index {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return [[BBMediaPickerAssetModel alloc] initWithAsset:[self.fetchResult objectAtIndex:index] assetCollectionModel:self];
#else
    return [[BBMediaPickerAssetModel alloc] initWithAsset:[self.assetCollection BB_assetAtIndex:index] assetCollectionModel:self];
#endif
}

- (NSUInteger)indexOfAssetModel:(BBMediaPickerAssetModel *)assetModel {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return [self.fetchResult indexOfObject:assetModel.asset];
#else
    __block NSInteger retval = NSNotFound;
    
    [self.assetCollection enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        NSURL *assetURL = [result valueForProperty:ALAssetPropertyAssetURL];
        
        if ([assetURL.absoluteString isEqualToString:assetModel.identifier]) {
            retval = index;
            *stop = YES;
        }
    }];
    
    return retval;
#endif
}

- (void)requestThumbnailImageOfSize:(CGSize)size thumbnailIndex:(NSUInteger)thumbnailIndex completion:(void(^)(UIImage * _Nullable  thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (self.countOfAssetModels <= thumbnailIndex) {
        completion(nil);
        return;
    }
    
    [self _cancelThumbnailImageRequestAtIndex:thumbnailIndex];
    
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    PHAsset *asset = [self.fetchResult objectAtIndex:thumbnailIndex];
    PHImageRequestID imageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
    
    [self.thumbnailIndexesToImageRequestIDs setObject:@(imageRequestID) forKey:@(thumbnailIndex)];
#else
    
#endif
}
- (void)cancelAllThumbnailRequests; {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    for (NSNumber *thumbnailIndex in self.thumbnailIndexesToImageRequestIDs.allKeys) {
        [self _cancelThumbnailImageRequestAtIndex:thumbnailIndex.unsignedIntegerValue];
    }
#else
    
#endif
}

- (void)_cancelThumbnailImageRequestAtIndex:(NSUInteger)thumbnailIndex; {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    PHImageRequestID imageRequestID = [self.thumbnailIndexesToImageRequestIDs[@(thumbnailIndex)] intValue];
    
    if (imageRequestID == PHInvalidImageRequestID) {
        return;
    }
    
    [self.thumbnailIndexesToImageRequestIDs removeObjectForKey:@(thumbnailIndex)];
    
    [[PHCachingImageManager defaultManager] cancelImageRequest:imageRequestID];
#else
    
#endif
}

- (void)reloadFetchResult; {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (self.model.mediaTypes & BBMediaPickerMediaTypesUnknown) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@BBKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeUnknown)]];
    }
    if (self.model.mediaTypes & BBMediaPickerMediaTypesImage) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@BBKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeImage)]];
    }
    if (self.model.mediaTypes & BBMediaPickerMediaTypesVideo) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@BBKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeVideo)]];
    }
    if (self.model.mediaTypes & BBMediaPickerMediaTypesAudio) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@BBKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeAudio)]];
    }
    
    [options setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@BBKeypath(PHAsset.new,creationDate) ascending:YES]]];
    
    [self setFetchResult:[PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options]];
#else
    
#endif
}

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (void)setFetchResult:(PHFetchResult<PHAsset *> *)fetchResult {
    [self willChangeValueForKey:@BBKeypath(self,countOfAssetModels)];
    
    _fetchResult = fetchResult;
    
    [self didChangeValueForKey:@BBKeypath(self,countOfAssetModels)];
}
#endif

@end
