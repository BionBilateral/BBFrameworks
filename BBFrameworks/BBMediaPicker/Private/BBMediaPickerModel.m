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
@property (readwrite,copy,nonatomic) NSOrderedSet<BBMediaPickerAssetModel *> *selectedAssetModels;

- (void)_updateTitle;
- (void)_reloadAssetCollections;
@end

@implementation BBMediaPickerModel
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _hidesEmptyAssetCollections = YES;
    
    [self _updateTitle];
    [self _reloadAssetCollections];
    
    [self setDoneBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL]];
    [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_authorizationStatusDidChange:) name:kNotificationAuthorizationStatusDidChange object:nil];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    return self;
}
#pragma mark PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}
#pragma mark *** Public Methods ***
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

- (void)selectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetModels];
    
    [temp addObject:assetModel];
    
    [self setSelectedAssetModels:temp];
}
- (void)deselectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetModels];
    
    [temp removeObject:assetModel];
    
    [self setSelectedAssetModels:temp];
}
#pragma mark Properties
- (void)setHidesEmptyAssetCollections:(BOOL)hidesEmptyAssetCollections {
    if (_hidesEmptyAssetCollections == hidesEmptyAssetCollections) {
        return;
    }
    
    _hidesEmptyAssetCollections = hidesEmptyAssetCollections;
    
    [self _reloadAssetCollections];
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
- (void)setSelectedAssetModels:(NSOrderedSet<BBMediaPickerAssetModel *> *)selectedAssetModels {
    _selectedAssetModels = selectedAssetModels;
    
    if (!self.allowsMultipleSelection &&
        _selectedAssetModels.count > 0) {
        
        [self _doneBarButtonItemAction:self.doneBarButtonItem];
    }
}
#pragma mark *** Private Methods ***
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
    
    NSMutableArray<PHAssetCollection *> *retval = [[NSMutableArray alloc] init];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    [self setAssetCollectionModels:[[retval BB_map:^id _Nullable(PHAssetCollection * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object];
    }] BB_reject:^BOOL(BBMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return object.title.length == 0 || (self.hidesEmptyAssetCollections && object.countOfAssetModels == 0);
    }]];
    
    // try to select previously selected asset collection model
    if (self.selectedAssetCollectionModel) {
        
    }
    
    // select camera roll by default
    if (!self.selectedAssetCollectionModel) {
        for (BBMediaPickerAssetCollectionModel *collection in self.assetCollectionModels) {
            if (collection.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [self setSelectedAssetCollectionModel:collection];
                break;
            }
        }
    }
}
#pragma mark Actions
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
#pragma mark Notifications
- (void)_authorizationStatusDidChange:(NSNotification *)note {
    [self _updateTitle];
    [self _reloadAssetCollections];
}

@end
