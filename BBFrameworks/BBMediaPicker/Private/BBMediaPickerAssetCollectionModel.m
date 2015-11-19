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

#import <Photos/Photos.h>

@interface BBMediaPickerAssetCollectionModel ()
@property (readwrite,strong,nonatomic) PHAssetCollection *assetCollection;
@property (readwrite,weak,nonatomic) BBMediaPickerModel *model;
@property (readwrite,strong,nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (assign,nonatomic) PHImageRequestID firstImageRequestID, secondImageRequestID, thirdImageRequestID;

- (void)_cancelThumbnailImageRequestWithImageRequestID:(PHImageRequestID)imageRequestID;
@end

@implementation BBMediaPickerAssetCollectionModel

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(BBMediaPickerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    [self setAssetCollection:assetCollection];
    [self setModel:model];
    
    [self reloadFetchResult];
    
    return self;
}

- (BBMediaPickerAssetCollectionSubtype)subtype {
    return (BBMediaPickerAssetCollectionSubtype)self.assetCollection.assetCollectionSubtype;
}
- (NSString *)title {
    return self.assetCollection.localizedTitle;
}
- (NSString *)subtitle {
    return [NSNumberFormatter localizedStringFromNumber:@(self.fetchResult.count) numberStyle:NSNumberFormatterDecimalStyle];
}
- (UIImage *)typeImage {
    switch (self.assetCollection.assetCollectionSubtype) {
        case PHAssetCollectionSubtypeSmartAlbumVideos:
        case PHAssetCollectionSubtypeSmartAlbumSlomoVideos:
            return self.model.theme.assetTypeVideoImage;
        default:
            return nil;
    }
}

- (NSUInteger)countOfAssetModels {
    return self.fetchResult.count;
}
- (BBMediaPickerAssetModel *)assetModelAtIndex:(NSUInteger)index {
    return [[BBMediaPickerAssetModel alloc] initWithAsset:[self.fetchResult objectAtIndex:index] assetCollectionModel:self];
}

- (NSUInteger)indexOfAssetModel:(BBMediaPickerAssetModel *)assetModel {
    return [self.fetchResult indexOfObject:assetModel.asset];
}

- (void)requestFirstThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (self.fetchResult.count == 0) {
        completion(nil);
        return;
    }
    
    [self _cancelThumbnailImageRequestWithImageRequestID:self.firstImageRequestID];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    PHAsset *asset = self.fetchResult.firstObject;
    
    _firstImageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}
- (void)requestSecondThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (self.fetchResult.count <= 1) {
        completion(nil);
        return;
    }
    
    [self _cancelThumbnailImageRequestWithImageRequestID:self.secondImageRequestID];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    PHAsset *asset = [self.fetchResult objectAtIndex:1];
    
    _secondImageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}
- (void)requestThirdThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (self.fetchResult.count <= 2) {
        completion(nil);
        return;
    }
    
    [self _cancelThumbnailImageRequestWithImageRequestID:self.thirdImageRequestID];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    PHAsset *asset = [self.fetchResult objectAtIndex:2];
    
    _thirdImageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}
- (void)cancelAllThumbnailRequests; {
    [self _cancelThumbnailImageRequestWithImageRequestID:self.firstImageRequestID];
    [self _cancelThumbnailImageRequestWithImageRequestID:self.secondImageRequestID];
    [self _cancelThumbnailImageRequestWithImageRequestID:self.thirdImageRequestID];
    
    _firstImageRequestID = PHInvalidImageRequestID;
    _secondImageRequestID = PHInvalidImageRequestID;
    _thirdImageRequestID = PHInvalidImageRequestID;
}

- (void)_cancelThumbnailImageRequestWithImageRequestID:(PHImageRequestID)imageRequestID; {
    if (imageRequestID == PHInvalidImageRequestID) {
        return;
    }
    
    [[PHCachingImageManager defaultManager] cancelImageRequest:imageRequestID];
}

- (void)reloadFetchResult; {
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
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@BBKeypath(PHAsset.new,creationDate) ascending:NO]]];
    
    [self setFetchResult:[PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options]];
}

- (void)setFetchResult:(PHFetchResult<PHAsset *> *)fetchResult {
    [self willChangeValueForKey:@BBKeypath(self,countOfAssetModels)];
    
    _fetchResult = fetchResult;
    
    [self didChangeValueForKey:@BBKeypath(self,countOfAssetModels)];
}

@end
