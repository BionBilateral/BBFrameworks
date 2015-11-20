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
#import "BBMediaPickerAssetCollectionModel.h"
#import "BBMediaPickerAssetModel.h"
#import "BBMediaPickerTheme.h"

#import <Photos/Photos.h>

static NSString *const kNotificationAuthorizationStatusDidChange = @"kNotificationAuthorizationStatusDidChange";

@interface BBMediaPickerModel () <PHPhotoLibraryChangeObserver>
@property (readwrite,copy,nonatomic) NSString *title;

@property (readwrite,copy,nonatomic,nullable) NSArray<BBMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (readwrite,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;

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
    
    _theme = [BBMediaPickerTheme defaultTheme];
    
    _hidesEmptyAssetCollections = YES;
    _mediaTypes = BBMediaPickerMediaTypesAll;
    _initiallySelectedAssetCollectionSubtype = BBMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary;
    
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
    for (BBMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
        PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:model.fetchResult];
        
        if (!details) {
            continue;
        }
        
        if (details.hasIncrementalChanges &&
            (details.removedIndexes.count > 0 || details.insertedIndexes.count > 0 || details.changedIndexes.count > 0)) {
            [model reloadFetchResult];
        }
        else if (details.fetchResultAfterChanges) {
            [model reloadFetchResult];
        }
    }
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

- (BOOL)shouldSelectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    return [self.delegate mediaPickerModel:self shouldSelectMedia:assetModel];
}
- (BOOL)shouldDeselectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    return [self.delegate mediaPickerModel:self shouldDeselectMedia:assetModel];
}
- (void)selectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers];
    
    [temp addObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    [self.delegate mediaPickerModel:self didSelectMedia:assetModel];
}
- (void)deselectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers];
    
    [temp removeObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    [self.delegate mediaPickerModel:self didDeselectMedia:assetModel];
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
        [_doneBarButtonItem setEnabled:self.selectedAssetIdentifiers.count > 0];
    }
}
- (void)setCancelBarButtonItem:(UIBarButtonItem *)cancelBarButtonItem {
    _cancelBarButtonItem = cancelBarButtonItem;
    
    if (_cancelBarButtonItem) {
        [_cancelBarButtonItem setTarget:self];
        [_cancelBarButtonItem setAction:@selector(_cancelBarButtonItemAction:)];
    }
}

- (void)setTheme:(BBMediaPickerTheme *)theme {
    _theme = theme ?: [BBMediaPickerTheme defaultTheme];
}

- (void)setMediaTypes:(BBMediaPickerMediaTypes)mediaTypes {
    _mediaTypes = mediaTypes;
    
    [self _reloadAssetCollections];
}

- (void)setInitiallySelectedAssetCollectionSubtype:(BBMediaPickerAssetCollectionSubtype)initiallySelectedAssetCollectionSubtype {
    if (_initiallySelectedAssetCollectionSubtype == initiallySelectedAssetCollectionSubtype) {
        return;
    }
    
    _initiallySelectedAssetCollectionSubtype = initiallySelectedAssetCollectionSubtype;
    
    [self _reloadAssetCollections];
}
- (void)setAllowedAssetCollectionSubtypes:(NSSet<NSNumber *> *)allowedAssetCollectionSubtypes {
    _allowedAssetCollectionSubtypes = [allowedAssetCollectionSubtypes copy];
    
    [self _reloadAssetCollections];
}

- (NSString *)subtitle {
    return @"Tap to change album ▼";
}

- (void)setSelectedAssetCollectionModel:(BBMediaPickerAssetCollectionModel *)selectedAssetCollectionModel {
    _selectedAssetCollectionModel = selectedAssetCollectionModel;
    
    [self setSelectedAssetIdentifiers:nil];
    [self _updateTitle];
}
- (void)setSelectedAssetIdentifiers:(NSOrderedSet<NSString *> *)selectedAssetIdentifiers {
    // deselect everything and we currently have a selection, call did deselect for each asset
    if (selectedAssetIdentifiers == nil &&
        _selectedAssetIdentifiers.count > 0) {
        for (NSString *identifier in _selectedAssetIdentifiers) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            
            [options setWantsIncrementalChangeDetails:NO];
            
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:options].firstObject;
            
            [self.delegate mediaPickerModel:self didDeselectMedia:[[BBMediaPickerAssetModel alloc] initWithAsset:asset assetCollectionModel:nil]];
        }
    }
    
    _selectedAssetIdentifiers = selectedAssetIdentifiers;
    
    [self.doneBarButtonItem setEnabled:_selectedAssetIdentifiers.count > 0];
    
    if (!self.allowsMultipleSelection &&
        _selectedAssetIdentifiers.count > 0) {
        
        [self _doneBarButtonItemAction:self.doneBarButtonItem];
    }
}
- (NSArray<BBMediaPickerAssetModel *> *)selectedAssetModels {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    [options setWantsIncrementalChangeDetails:NO];
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [[PHAsset fetchAssetsWithLocalIdentifiers:self.selectedAssetIdentifiers.array options:options] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    return [retval BB_map:^id _Nullable(PHAsset * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetModel alloc] initWithAsset:object assetCollectionModel:nil];
    }];
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
    
    // sort asset collections by title
    [retval sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES selector:@selector(localizedStandardCompare:)]]];
    
    BBMediaPickerAssetCollectionModel *oldSelectedAssetCollectionModel = self.selectedAssetCollectionModel;
    
    [self setAssetCollectionModels:[[[retval BB_map:^id _Nullable(PHAssetCollection * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object model:self];
    }] BB_reject:^BOOL(BBMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return object.title.length == 0 || (self.hidesEmptyAssetCollections && object.countOfAssetModels == 0);
    }] BB_filter:^BOOL(BBMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return self.allowedAssetCollectionSubtypes == nil || [self.allowedAssetCollectionSubtypes containsObject:@(object.subtype)];
    }]];

    // try to select previously selected asset collection model
    if (oldSelectedAssetCollectionModel) {
        for (BBMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
            if (model.subtype == oldSelectedAssetCollectionModel.subtype) {
                [self setSelectedAssetCollectionModel:model];
                break;
            }
        }
    }
    
    // select camera roll by default
    if (!self.selectedAssetCollectionModel) {
        for (BBMediaPickerAssetCollectionModel *collection in self.assetCollectionModels) {
            if (collection.subtype == self.initiallySelectedAssetCollectionSubtype) {
                [self setSelectedAssetCollectionModel:collection];
                break;
            }
        }
    }
    
    // if still no selection, select the first asset collection
    if (!self.selectedAssetCollectionModel) {
        [self setSelectedAssetCollectionModel:self.assetCollectionModels.firstObject];
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
