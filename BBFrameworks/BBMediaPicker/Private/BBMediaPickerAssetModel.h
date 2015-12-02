//
//  BBMediaPickerAssetModel.h
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

#import <UIKit/UIKit.h>
#import "BBMediaPickerMedia.h"
#import "BBMediaPickerDefines.h"

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/PHAsset.h>
#else
#import <AssetsLibrary/ALAsset.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class BBMediaPickerAssetCollectionModel;

@interface BBMediaPickerAssetModel : NSObject <BBMediaPickerMedia>

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
@property (readonly,strong,nonatomic) PHAsset *asset;
#else
@property (readonly,strong,nonatomic) ALAsset *asset;
#endif

@property (readonly,weak,nonatomic,nullable) BBMediaPickerAssetCollectionModel *assetCollectionModel;

@property (readonly,nonatomic) NSString *identifier;
@property (readonly,nonatomic) BBMediaPickerAssetMediaType mediaType;

@property (readonly,nonatomic) UIImage *typeImage;
@property (readonly,nonatomic) NSTimeInterval duration;
@property (readonly,nonatomic) NSString *formattedDuration;
@property (readonly,nonatomic) NSDate *creationDate;
@property (readonly,nonatomic) NSUInteger selectedIndex;

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (instancetype)initWithAsset:(PHAsset *)asset assetCollectionModel:(nullable BBMediaPickerAssetCollectionModel *)assetCollectionModel;
#else
- (instancetype)initWithAsset:(ALAsset *)asset assetCollectionModel:(nullable BBMediaPickerAssetCollectionModel *)assetCollectionModel;
#endif

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage * _Nullable thumbnailImage))completion;
- (void)cancelAllThumbnailRequests;

@end

NS_ASSUME_NONNULL_END
