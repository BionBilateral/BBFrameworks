//
//  BBMediaPickerAssetCollectionModel.h
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
#import <Photos/PHCollection.h>

@class BBMediaPickerModel,BBMediaPickerAssetModel;

@interface BBMediaPickerAssetCollectionModel : NSObject

@property (readonly,strong,nonatomic) PHAssetCollection *assetCollection;

@property (readonly,weak,nonatomic) BBMediaPickerModel *model;

@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) NSString *subtitle;

@property (readonly,nonatomic) NSUInteger countOfAssetModels;
- (BBMediaPickerAssetModel *)assetModelAtIndex:(NSUInteger)index;

- (void)requestFirstThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion;
- (void)requestSecondThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion;
- (void)requestThirdThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage *thumbnailImage))completion;
- (void)cancelAllThumbnailRequests;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(BBMediaPickerModel *)model;

@end
