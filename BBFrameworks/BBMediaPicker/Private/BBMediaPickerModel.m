//
//  BBMediaPickerModel.m
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

#import "BBMediaPickerModel.h"
#import "BBFoundationFunctions.h"
#import "BBFoundationDebugging.h"
#import "BBBlocks.h"

#import <Photos/Photos.h>

static NSString *const kNotificationAuthorizationStatusDidChange = @"kNotificationAuthorizationStatusDidChange";

@interface BBMediaPickerModel () <PHPhotoLibraryChangeObserver>
@property (readwrite,copy,nonatomic) NSString *title;

@property (readwrite,copy,nonatomic,nullable) NSArray<BBMediaPickerAssetCollectionModel *> *assetCollectionModels;

- (void)_updateTitle;
- (void)_reloadAssetCollections;
@end

@implementation BBMediaPickerModel

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self _updateTitle];
    [self _reloadAssetCollections];
    
    [self setDoneBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL]];
    [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_authorizationStatusDidChange:) name:kNotificationAuthorizationStatusDidChange object:nil];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    return self;
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}

- (void)setDoneBarButtonItem:(UIBarButtonItem *)doneBarButtonItem {
    _doneBarButtonItem = doneBarButtonItem;
    
    if (_doneBarButtonItem) {
        [_doneBarButtonItem setTarget:self];
        [_doneBarButtonItem setAction:@selector(_doneBarButtonItemAction:)];
    }
}
- (void)setCancelBarButtonItem:(UIBarButtonItem *)cancelBarButtonItem {
    _cancelBarButtonItem = cancelBarButtonItem;
    
    if (_cancelBarButtonItem) {
        [_cancelBarButtonItem setTarget:self];
        [_cancelBarButtonItem setAction:@selector(_cancelBarButtonItemAction:)];
    }
}

- (void)setSelectedAssetCollectionModel:(BBMediaPickerAssetCollectionModel *)selectedAssetCollectionModel {
    _selectedAssetCollectionModel = selectedAssetCollectionModel;
    
    [self _updateTitle];
}

+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return (BBMediaPickerAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}
+ (void)requestAuthorizationWithCompletion:(void(^)(BBMediaPickerAuthorizationStatus status))completion; {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BBDispatchMainSyncSafe(^{
            if (completion) {
                completion((BBMediaPickerAuthorizationStatus)status);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAuthorizationStatusDidChange object:self];
        });
    }];
}

- (void)_updateTitle; {
    if (self.selectedAssetCollectionModel) {
        [self setTitle:self.selectedAssetCollectionModel.title];
        return;
    }
    
    switch ([self.class authorizationStatus]) {
        case BBMediaPickerAuthorizationStatusAuthorized:
            [self setTitle:@"Authorized"];
            break;
        case BBMediaPickerAuthorizationStatusDenied:
            [self setTitle:@"Denied"];
            break;
        case BBMediaPickerAuthorizationStatusNotDetermined:
            [self setTitle:@"Requesting Authorization"];
            break;
        case BBMediaPickerAuthorizationStatusRestricted:
            [self setTitle:@"Restricted"];
            break;
        default:
            break;
    }
}
- (void)_reloadAssetCollections {
    if ([self.class authorizationStatus] != BBMediaPickerAuthorizationStatusAuthorized) {
        return;
    }
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [self setAssetCollectionModels:[[retval BB_filter:^BOOL(PHAssetCollection * _Nonnull object, NSInteger index) {
        return object.localizedTitle.length > 0;
    }] BB_map:^id _Nullable(PHAssetCollection * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object];
    }]];
    
    if (!self.selectedAssetCollectionModel) {
        for (BBMediaPickerAssetCollectionModel *collection in self.assetCollectionModels) {
            if (collection.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [self setSelectedAssetCollectionModel:collection];
                break;
            }
        }
    }
}

- (IBAction)_doneBarButtonItemAction:(id)sender {
    if (self.doneBarButtonItemActionBlock) {
        self.doneBarButtonItemActionBlock();
    }
}
- (IBAction)_cancelBarButtonItemAction:(id)sender {
    if (self.cancelBarButtonItemActionBlock) {
        self.cancelBarButtonItemActionBlock();
    }
}

- (void)_authorizationStatusDidChange:(NSNotification *)note {
    [self _updateTitle];
    [self _reloadAssetCollections];
}

@end
