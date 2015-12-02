//
//  BBMediaPickerAssetModel.m
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

#import "BBMediaPickerAssetModel.h"
#import "BBMediaPickerAssetCollectionModel.h"
#import "BBMediaPickerModel.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerTheme.h"

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/Photos.h>
#else
#import "ALAsset+BBMediaPickerExtensions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface BBMediaPickerAssetModel ()
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
@property (readwrite,strong,nonatomic) PHAsset *asset;
@property (assign,nonatomic) PHImageRequestID imageRequestID;
#else
@property (readwrite,strong,nonatomic) ALAsset *asset;
#endif
@property (readwrite,weak,nonatomic,nullable) BBMediaPickerAssetCollectionModel *assetCollectionModel;

@end

@implementation BBMediaPickerAssetModel

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (PHAsset *)mediaAsset {
#else
- (ALAsset *)mediaAsset {
#endif
    return self.asset;
}

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (instancetype)initWithAsset:(PHAsset *)asset assetCollectionModel:(nullable BBMediaPickerAssetCollectionModel *)assetCollectionModel; {
#else
- (instancetype)initWithAsset:(ALAsset *)asset assetCollectionModel:(nullable BBMediaPickerAssetCollectionModel *)assetCollectionModel; {
#endif
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(asset);
    
    [self setAsset:asset];
    [self setAssetCollectionModel:assetCollectionModel];
    
    return self;
}

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage * _Nullable thumbnailImage))completion; {
    NSParameterAssert(completion);
    
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    [self cancelAllThumbnailRequests];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    _imageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
#else
    UIImage *retval = [UIImage imageWithCGImage:[self.asset thumbnail]];
    
    completion(retval);
#endif
}
- (void)cancelAllThumbnailRequests; {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
#endif
}

- (NSString *)identifier {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return self.asset.localIdentifier;
#else
    return [self.asset BB_identifier];
#endif
}
- (BBMediaPickerAssetMediaType)mediaType {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return (BBMediaPickerAssetMediaType)self.asset.mediaType;
#else
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    
    if ([type isEqualToString:ALAssetTypePhoto]) {
        return BBMediaPickerAssetMediaTypeImage;
    }
    else if ([type isEqualToString:ALAssetTypeVideo]) {
        return BBMediaPickerAssetMediaTypeVideo;
    }
    else {
        return BBMediaPickerAssetMediaTypeUnknown;
    }
#endif
}
- (UIImage *)typeImage {
    switch (self.mediaType) {
        case BBMediaPickerAssetMediaTypeVideo:
            return self.assetCollectionModel.model.theme.assetTypeVideoImage;
        default:
            return nil;
    }
}
- (NSTimeInterval)duration {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return self.asset.duration;
#else
    return [[self.asset valueForProperty:ALAssetPropertyDuration] doubleValue];
#endif
}
- (NSString *)formattedDuration {
    if (self.mediaType == BBMediaPickerAssetMediaTypeVideo) {
        NSTimeInterval duration = self.duration;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:duration];
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:duration] options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (comps.hour > 0) {
            [dateFormatter setDateFormat:@"H:mm:ss"];
        }
        else {
            [dateFormatter setDateFormat:@"m:ss"];
        }
        
        date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}
- (NSDate *)creationDate {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return self.asset.creationDate;
#else
    return [self.asset valueForProperty:ALAssetPropertyDate];
#endif
}
- (NSUInteger)selectedIndex {
    if ([self.assetCollectionModel.model.selectedAssetIdentifiers containsObject:self.identifier]) {
        return [self.assetCollectionModel.model.selectedAssetIdentifiers indexOfObject:self.identifier];
    }
    return NSNotFound;
}

@end
