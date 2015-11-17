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

#import <Photos/Photos.h>

@interface BBMediaPickerAssetModel ()
@property (readwrite,strong,nonatomic) PHAsset *asset;
@property (readwrite,weak,nonatomic) BBMediaPickerAssetCollectionModel *assetCollectionModel;

@property (assign,nonatomic) PHImageRequestID imageRequestID;
@end

@implementation BBMediaPickerAssetModel

- (instancetype)initWithAsset:(PHAsset *)asset assetCollectionModel:(BBMediaPickerAssetCollectionModel *)assetCollectionModel; {
    if (!(self = [super init]))
        return nil;
    
    [self setAsset:asset];
    [self setAssetCollectionModel:assetCollectionModel];
    
    return self;
}

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    [self cancelAllThumbnailRequests];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    _imageRequestID = [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}
- (void)cancelAllThumbnailRequests; {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
}

- (NSString *)identifier {
    return self.asset.localIdentifier;
}
- (UIImage *)typeImage {
    switch (self.asset.mediaType) {
        case PHAssetMediaTypeVideo:
            return self.assetCollectionModel.model.theme.assetTypeVideoImage;
        default:
            return nil;
    }
}
- (NSString *)formattedDuration {
    if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        NSTimeInterval duration = self.asset.duration;
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
- (NSUInteger)selectedIndex {
    if ([self.assetCollectionModel.model.selectedAssetIdentifiers containsObject:self.identifier]) {
        return [self.assetCollectionModel.model.selectedAssetIdentifiers indexOfObject:self.identifier];
    }
    return NSNotFound;
}

@end
