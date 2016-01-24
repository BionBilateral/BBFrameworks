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
#import "BBFrameworksMacros.h"
#import "BBFrameworksFunctions.h"

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
#import <Photos/Photos.h>
#else
#import "ALAssetsLibrary+BBMediaPickerExtensions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#endif

NSString *const BBMediaPickerErrorDomain = @"com.bionbilateral.bbmediapicker.error";

NSInteger const BBMediaPickerErrorCodeMixedMediaSelection = 1;
NSInteger const BBMediaPickerErrorCodeMaximumSelectedMedia = 2;
NSInteger const BBMediaPickerErrorCodeMaximumSelectedImages = 3;
NSInteger const BBMediaPickerErrorCodeMaximumSelectedVideos = 4;

static NSString *const kNotificationAuthorizationStatusDidChange = @"kNotificationAuthorizationStatusDidChange";

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
@interface BBMediaPickerModel () <PHPhotoLibraryChangeObserver>
#else
@interface BBMediaPickerModel ()
#endif
@property (readwrite,copy,nonatomic) NSString *title;
@property (readwrite,copy,nonatomic,nullable) NSString *subtitle;

#if (!BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;
#endif
@property (readwrite,copy,nonatomic,nullable) NSArray<BBMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (readwrite,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;

@property (readwrite,strong,nonatomic,nullable) UIControl *cancelBottomAccessoryControl;
@property (readwrite,strong,nonatomic,nullable) UIControl *doneBottomAccessoryControl;

- (void)_updateTitle;
- (void)_updateSubtitle;
- (void)_reloadAssetCollections;
- (void)_updateThemeDependentProperties;
@end

@implementation BBMediaPickerModel
#pragma mark *** Subclass Overrides ***
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@BBKeypath(BBMediaPickerModel.new,selectedAssetCollectionModel)]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)dealloc {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
#else
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _theme = [BBMediaPickerTheme defaultTheme];
    
    _allowsMixedMediaSelection = YES;
    _hidesEmptyAssetCollections = YES;
    _mediaTypes = BBMediaPickerMediaTypesAll;
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    _initiallySelectedAssetCollectionSubtype = BBMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary;
#else
    _initiallySelectedAssetCollectionSubtype = BBMediaPickerAssetCollectionSubtypeSavedPhotos;
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
#endif
    
    [self _updateTitle];
    [self _updateSubtitle];
    [self _reloadAssetCollections];
    [self _updateThemeDependentProperties];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_authorizationStatusDidChange:) name:kNotificationAuthorizationStatusDidChange object:nil];

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
#else
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_assetsLibraryDidChange:) name:ALAssetsLibraryChangedNotification object:_assetsLibrary];
#endif
    
    return self;
}
#pragma mark PHPhotoLibraryChangeObserver

#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
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
#endif

#pragma mark *** Public Methods ***
+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    return (BBMediaPickerAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
#else
    return (BBMediaPickerAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
#endif
}
+ (void)requestAuthorizationWithCompletion:(void(^)(BBMediaPickerAuthorizationStatus status))completion; {
    void(^completionBlock)(void) = ^{
        BBDispatchMainSyncSafe(^{
            if (completion) {
                completion([self authorizationStatus]);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAuthorizationStatusDidChange object:self];
        });
    };
    
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        completionBlock();
    }];
#else
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group) {
            completionBlock();
        }
    } failureBlock:^(NSError *error) {
        completionBlock();
    }];
#endif
}

- (BOOL)isAssetModelSelected:(BBMediaPickerAssetModel *)assetModel; {
    return [self.selectedAssetIdentifiers containsObject:assetModel.identifier];
}
- (BOOL)shouldSelectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    BOOL retval = YES;
    
    // if we allow multiple selection but do not allow mixed media selection check to make sure all selected media are of the same media type
    if (self.allowsMultipleSelection &&
        !self.allowsMixedMediaSelection) {
        
        NSArray<BBMediaPickerAssetModel *> *selectedAssetModels = self.selectedAssetModels;
        
        retval = [selectedAssetModels BB_all:^BOOL(BBMediaPickerAssetModel * _Nonnull object, NSInteger index) {
            return object.mediaType == selectedAssetModels.firstObject.mediaType;
        }];
        
        if (!retval) {
            NSError *error = [NSError errorWithDomain:BBMediaPickerErrorDomain code:BBMediaPickerErrorCodeMixedMediaSelection userInfo:@{NSLocalizedDescriptionKey: NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_ERROR_CODE_MIXED_MEDIA_SELECTION", @"MediaPicker", BBFrameworksResourcesBundle(), @"You cannot select more than one media type.", @"media picker error code mixed media selection")}];
            
            [self.delegate mediaPickerModel:self didError:error];
        }
    }
    
    // if the asset model can still be selected and a maximum selected media limit has been set and selecting another media would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedMedia > 0 &&
        self.selectedAssetIdentifiers.count + 1 > self.maximumSelectedMedia) {
        
        retval = NO;
        
        NSError *error = [NSError errorWithDomain:BBMediaPickerErrorDomain code:BBMediaPickerErrorCodeMaximumSelectedMedia userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_ERROR_CODE_MAXIMUM_SELECTED_MEDIA", @"MediaPicker", BBFrameworksResourcesBundle(), @"You cannot select more than %@ media.", @"media picker error code maximum selected media"),[NSNumberFormatter localizedStringFromNumber:@(self.maximumSelectedMedia) numberStyle:NSNumberFormatterDecimalStyle]]}];
        
        [self.delegate mediaPickerModel:self didError:error];
    }
    
    // if the asset model can still be selected and a maximum selected images limit has been set and the asset model is an image and selecting it would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedImages > 0 &&
        assetModel.mediaType == BBMediaPickerAssetMediaTypeImage &&
        [self.selectedAssetModels BB_reduceIntegerWithStart:0 block:^NSInteger(NSInteger sum, BBMediaPickerAssetModel * _Nonnull object, NSInteger index) {
        return object.mediaType == BBMediaPickerAssetMediaTypeImage ? sum + 1 : sum;
    }] + 1 > self.maximumSelectedImages) {
        
        retval = NO;
        
        NSError *error = [NSError errorWithDomain:BBMediaPickerErrorDomain code:BBMediaPickerErrorCodeMaximumSelectedImages userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_ERROR_CODE_MAXIMUM_SELECTED_IMAGES", @"MediaPicker", BBFrameworksResourcesBundle(), @"You cannot select more than %@ images.", @"media picker error code maximum selected images"),[NSNumberFormatter localizedStringFromNumber:@(self.maximumSelectedImages) numberStyle:NSNumberFormatterDecimalStyle]]}];
        
        [self.delegate mediaPickerModel:self didError:error];
    }
    
    // if the asset model can still be selected and a maximum selected videos limit has been set and the asset model is a video and selecting it would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedVideos > 0 &&
        assetModel.mediaType == BBMediaPickerAssetMediaTypeVideo &&
        [self.selectedAssetModels BB_reduceIntegerWithStart:0 block:^NSInteger(NSInteger sum, BBMediaPickerAssetModel * _Nonnull object, NSInteger index) {
        return object.mediaType == BBMediaPickerAssetMediaTypeVideo ? sum + 1 : sum;
    }] + 1 > self.maximumSelectedVideos) {
        
        retval = NO;
        
        NSError *error = [NSError errorWithDomain:BBMediaPickerErrorDomain code:BBMediaPickerErrorCodeMaximumSelectedVideos userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_ERROR_CODE_MAXIMUM_SELECTED_VIDEOS", @"MediaPicker", BBFrameworksResourcesBundle(), @"You cannot select more than %@ videos.", @"media picker error code maximum selected videos"),[NSNumberFormatter localizedStringFromNumber:@(self.maximumSelectedVideos) numberStyle:NSNumberFormatterDecimalStyle]]}];
        
        [self.delegate mediaPickerModel:self didError:error];
    }
    
    return retval ? [self.delegate mediaPickerModel:self shouldSelectMedia:assetModel] : NO;
}
- (BOOL)shouldDeselectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    return [self.delegate mediaPickerModel:self shouldDeselectMedia:assetModel];
}
- (void)selectAssetModel:(BBMediaPickerAssetModel *)assetModel; {
    [self selectAssetModel:assetModel notifyDelegate:YES];
}
- (void)selectAssetModel:(BBMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate; {
    NSMutableOrderedSet *temp = self.allowsMultipleSelection ? [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers] : [[NSMutableOrderedSet alloc] init];
    
    [temp addObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    if (notifyDelegate) {
        [self.delegate mediaPickerModel:self didSelectMedia:assetModel];
    }
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

- (void)setCancelBottomAccessoryControl:(UIControl *)cancelBottomAccessoryControl {
    [_cancelBottomAccessoryControl removeFromSuperview];
    
    _cancelBottomAccessoryControl = cancelBottomAccessoryControl;
    
    if (_cancelBottomAccessoryControl) {
        [_cancelBottomAccessoryControl addTarget:self action:@selector(_cancelBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)setDoneBottomAccessoryControl:(UIControl *)doneBottomAccessoryControl {
    [_doneBottomAccessoryControl removeFromSuperview];
    
    _doneBottomAccessoryControl = doneBottomAccessoryControl;
    
    if (_doneBottomAccessoryControl) {
        [_doneBottomAccessoryControl setEnabled:self.selectedAssetIdentifiers.count > 0];
        
        [_doneBottomAccessoryControl addTarget:self action:@selector(_doneBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setTheme:(BBMediaPickerTheme *)theme {
    _theme = theme ?: [BBMediaPickerTheme defaultTheme];
    
    [self _updateThemeDependentProperties];
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

- (void)setSelectedAssetCollectionModel:(BBMediaPickerAssetCollectionModel *)selectedAssetCollectionModel {
    if ([_selectedAssetCollectionModel.identifier isEqualToString:selectedAssetCollectionModel.identifier] &&
        _selectedAssetCollectionModel.countOfAssetModels == selectedAssetCollectionModel.countOfAssetModels) {
        return;
    }
    
    [self willChangeValueForKey:@BBKeypath(self,selectedAssetCollectionModel)];
    
    _selectedAssetCollectionModel = selectedAssetCollectionModel;
    
    [self didChangeValueForKey:@BBKeypath(self,selectedAssetCollectionModel)];
    
    [self setSelectedAssetIdentifiers:nil];
    [self _updateTitle];
    [self _updateSubtitle];
}
- (void)setSelectedAssetIdentifiers:(NSOrderedSet<NSString *> *)selectedAssetIdentifiers {
    // deselect everything and we currently have a selection, call did deselect for each asset
    if (selectedAssetIdentifiers == nil &&
        _selectedAssetIdentifiers.count > 0) {
        for (NSString *identifier in _selectedAssetIdentifiers) {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            
            [options setWantsIncrementalChangeDetails:NO];
            
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:options].firstObject;
            
            [self.delegate mediaPickerModel:self didDeselectMedia:[[BBMediaPickerAssetModel alloc] initWithAsset:asset assetCollectionModel:nil]];
#else
            ALAsset *asset = [self.assetsLibrary BB_assetForIdentifier:identifier];
            
            [self.delegate mediaPickerModel:self didDeselectMedia:[[BBMediaPickerAssetModel alloc] initWithAsset:asset assetCollectionModel:nil]];
#endif
        }
    }
    
    _selectedAssetIdentifiers = selectedAssetIdentifiers;
    
    BOOL enabled = _selectedAssetIdentifiers.count > 0;
    
    [self.doneBarButtonItem setEnabled:enabled];
    [self.doneBottomAccessoryControl setEnabled:enabled];
    
    if (!self.allowsMultipleSelection &&
        _selectedAssetIdentifiers.count > 0) {
        
        [self _doneBarButtonItemAction:self.doneBarButtonItem];
    }
}
- (NSArray<BBMediaPickerAssetModel *> *)selectedAssetModels {
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    [options setWantsIncrementalChangeDetails:NO];
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [[PHAsset fetchAssetsWithLocalIdentifiers:self.selectedAssetIdentifiers.array options:options] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addObject:obj];
    }];
    
    return [retval BB_map:^id _Nullable(PHAsset * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetModel alloc] initWithAsset:object assetCollectionModel:nil];
    }];
#else
    return [self.selectedAssetIdentifiers.array BB_map:^id _Nullable(NSString * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetModel alloc] initWithAsset:[self.assetsLibrary BB_assetForIdentifier:object] assetCollectionModel:nil];
    }];
#endif
}
#pragma mark *** Private Methods ***
- (void)_updateTitle; {
    if (self.selectedAssetCollectionModel) {
        [self setTitle:self.selectedAssetCollectionModel.title];
        return;
    }
    
    switch ([self.class authorizationStatus]) {
        case BBMediaPickerAuthorizationStatusAuthorized:
            [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_AUTHORIZED_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Authorized", @"media picker authorized title")];
            break;
        case BBMediaPickerAuthorizationStatusDenied:
            [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_DENIED_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Denied", @"media picker denied title")];
            break;
        case BBMediaPickerAuthorizationStatusNotDetermined:
            [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_REQUESTING_AUTHORIZATION_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Requesting Authorization", @"media picker requesting authorization title")];
            break;
        case BBMediaPickerAuthorizationStatusRestricted:
            [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_RESTRICTED_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Restricted", @"media picker restricted title")];
            break;
        default:
            break;
    }
}
- (void)_updateSubtitle; {
    if (self.selectedAssetCollectionModel) {
        [self setSubtitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_DEFAULT_SUBTITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Tap to select album ▼", @"media picker default subtitle")];
        return;
    }
    
    [self setSubtitle:nil];
}
- (void)_reloadAssetCollections {
    if ([self.class authorizationStatus] != BBMediaPickerAuthorizationStatusAuthorized) {
        return;
    }
    
#if (BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
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
    
    NSArray<BBMediaPickerAssetCollectionModel *> *assetCollectionModels = [retval BB_map:^id _Nullable(PHAssetCollection * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object model:self];
    }];
#else
    NSMutableArray<ALAssetsGroup *> *retval = [[NSMutableArray alloc] init];
    
    // this is dumb, but the enumeration is performed asynchronously on the calling thread, so waiting on the semaphore on the main thread is a no go
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [retval addObject:group];
            }
            else {
                dispatch_semaphore_signal(semaphore);
            }
        } failureBlock:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSArray<BBMediaPickerAssetCollectionModel *> *assetCollectionModels = [retval BB_map:^id _Nullable(ALAssetsGroup * _Nonnull object, NSInteger index) {
        return [[BBMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object model:self];
    }];
#endif
    
    BBMediaPickerAssetCollectionModel *oldSelectedAssetCollectionModel = self.selectedAssetCollectionModel;
    
    [self setAssetCollectionModels:[[assetCollectionModels BB_reject:^BOOL(BBMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return object.title.length == 0 || (self.hidesEmptyAssetCollections && object.countOfAssetModels == 0);
    }] BB_filter:^BOOL(BBMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return self.allowedAssetCollectionSubtypes == nil || [self.allowedAssetCollectionSubtypes containsObject:@(object.subtype)];
    }]];
    
    // try to select previously selected asset collection model
    if (oldSelectedAssetCollectionModel) {
        for (BBMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
            if ([model.identifier isEqualToString:oldSelectedAssetCollectionModel.identifier]) {
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
- (void)_updateThemeDependentProperties; {
    [self setDoneBarButtonItem:_theme.doneBarButtonItem ?: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL]];
    [self setCancelBarButtonItem:_theme.cancelBarButtonItem ?: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
    [self setCancelBottomAccessoryControl:_theme.cancelBottomAccessoryControlClass ? [[_theme.cancelBottomAccessoryControlClass alloc] initWithFrame:CGRectZero] : nil];
    [self setDoneBottomAccessoryControl:_theme.doneBottomAccessoryControlClass ? [[_theme.doneBottomAccessoryControlClass alloc] initWithFrame:CGRectZero] : nil];
}
#pragma mark Properties
- (void)setAssetCollectionModels:(NSArray<BBMediaPickerAssetCollectionModel *> *)assetCollectionModels {
    _assetCollectionModels = [assetCollectionModels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@BBKeypath(BBMediaPickerAssetCollectionModel.new,title) ascending:YES selector:@selector(localizedStandardCompare:)]]];
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
    [self _updateSubtitle];
    [self _reloadAssetCollections];
}
#if (!BB_MEDIA_PICKER_USE_PHOTOS_FRAMEWORK)
- (void)_assetsLibraryDidChange:(NSNotification *)note {
    BBWeakify(self);
    BBDispatchMainSyncSafe(^{
        BBStrongify(self);
        [self _reloadAssetCollections];
    });
}
#endif

@end
