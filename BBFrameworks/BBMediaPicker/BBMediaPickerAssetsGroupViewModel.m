//
//  BBMediaPickerAssetGroupViewModel.m
//  BBFrameworks
//
//  Created by William Towe on 7/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetsGroupViewModel.h"
#import "BBMediaPickerAssetViewModel.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBMediaPickerViewModel.h"
#import "BBBlocks.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMediaPickerAssetsGroupViewModel ()
@property (readwrite,copy,nonatomic) NSArray *assetViewModels;
@property (readwrite,weak,nonatomic) BBMediaPickerViewModel *parentViewModel;

@property (strong,nonatomic) ALAssetsGroup *assetsGroup;

- (void)_reloadAssetViewModels;
@end

@implementation BBMediaPickerAssetsGroupViewModel

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup parentViewModel:(BBMediaPickerViewModel *)parentViewModel; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(assetsGroup);
    NSParameterAssert(parentViewModel);
    
    [self setAssetsGroup:assetsGroup];
    [self setParentViewModel:parentViewModel];
    
    return self;
}

- (NSNumber *)type {
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyType];
}

- (UIImage *)badgeImage {
    ALAssetsGroupType type = self.type.integerValue;
    
    switch (type) {
        case ALAssetsGroupSavedPhotos:
            return [UIImage BB_imageInResourcesBundleNamed:@"media_picker_camera_roll"];
        default:
            return nil;
    }
}
- (UIImage *)posterImage {
    return [UIImage imageWithCGImage:self.assetsGroup.posterImage];
}
- (UIImage *)secondPosterImage {
    __block UIImage *retval = nil;
    
    if (self.assetsGroup.numberOfAssets >= 2) {
        [self.assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                retval = [UIImage imageWithCGImage:result.thumbnail];
                *stop = YES;
            }
        }];
    }
    
    return retval;
}
- (UIImage *)thirdPosterImage {
    __block UIImage *retval = nil;
    
    if (self.assetsGroup.numberOfAssets >= 3) {
        [self.assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                retval = [UIImage imageWithCGImage:result.thumbnail];
                *stop = YES;
            }
        }];
    }
    
    return retval;
}
- (NSString *)name {
    return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}
- (NSString *)countString {
    return @(self.assetsGroup.numberOfAssets).stringValue;
}

- (NSArray *)assetViewModels {
    if (!_assetViewModels) {
        [self _reloadAssetViewModels];
    }
    return _assetViewModels;
}

- (void)_reloadAssetViewModels; {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [temp addObject:[[BBMediaPickerAssetViewModel alloc] initWithAsset:result]];
        }
        else {
            [self setAssetViewModels:[temp BB_filter:^BOOL(BBMediaPickerAssetViewModel *object, NSInteger index) {
                return (([object.type isEqualToString:ALAssetTypePhoto] &&
                        self.parentViewModel.mediaTypes & BBMediaPickerMediaTypesPhoto) ||
                        ([object.type isEqualToString:ALAssetTypeVideo] &&
                         self.parentViewModel.mediaTypes & BBMediaPickerMediaTypesVideo) ||
                        ([object.type isEqualToString:ALAssetTypeUnknown] &&
                         self.parentViewModel.mediaTypes & BBMediaPickerMediaTypesUnknown));
            }]];
        }
    }];
}

@end
