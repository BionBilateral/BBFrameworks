//
//  BBMediaPickerViewController.m
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

#import "BBMediaPickerViewController.h"
#import "BBMediaPickerModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerDefaultTitleView.h"
#import "BBKeyValueObserving.h"
#import "BBMediaPickerAssetCollectionsViewController.h"
#import "BBMediaPickerAssetsViewController.h"
#import "BBMediaPickerAssetModel.h"
#import "BBBlocks.h"
#import "BBMediaPickerTheme.h"
#import "BBMediaPickerAssetCollectionModel.h"

@interface BBMediaPickerViewController () <BBMediaPickerModelDelegate>
@property (strong,nonatomic) BBMediaPickerModel *model;
@property (strong,nonatomic) BBMediaPickerAssetsViewController *assetsViewController;
@property (strong,nonatomic) UIView<BBMediaPickerTitleView> *titleView;

@property (assign,nonatomic) BOOL hasRequestedPhotosAccess;

- (void)_updateTitleViewProperties;
- (void)_updateTitleViewTitleAndSubtitle;
@end

@implementation BBMediaPickerViewController
#pragma mark *** Subclass Overrides ***
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@BBKeypath(BBMediaPickerViewController.new,titleView)]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:[[BBMediaPickerModel alloc] init]];
    [self.model setDelegate:self];
    
    BBWeakify(self);
    [self.model setCancelBarButtonItemActionBlock:^{
        BBStrongify(self);
        if ([self.delegate respondsToSelector:@selector(mediaPickerViewControllerDidCancel:)]) {
            [self.delegate mediaPickerViewControllerDidCancel:self];
        }
    }];
    
    [self.model setDoneBarButtonItemActionBlock:^{
        BBStrongify(self);
        if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didFinishPickingMedia:)]) {
            [self.delegate mediaPickerViewController:self didFinishPickingMedia:self.model.selectedAssetModels];
        }
    }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setAssetsViewController:[[BBMediaPickerAssetsViewController alloc] initWithModel:self.model]];
    [self addChildViewController:self.assetsViewController];
    [self.view addSubview:self.assetsViewController.view];
    [self.assetsViewController didMoveToParentViewController:self];
    
    BBWeakify(self);
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,theme) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        [self setTitleView:[[self.model.theme.titleViewClass alloc] initWithFrame:CGRectZero]];
        
        [self _updateTitleViewProperties];
    }];
    
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,title) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self _updateTitleViewTitleAndSubtitle];
    }];
    
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,allowsMultipleSelection) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        if (self.model.allowsMultipleSelection) {
            [self.navigationItem setLeftBarButtonItems:@[self.model.cancelBarButtonItem]];
            [self.navigationItem setRightBarButtonItems:@[self.model.doneBarButtonItem]];
        }
        else {
            [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
        }
    }];
}
- (void)viewDidLayoutSubviews {
    [self.assetsViewController.view setFrame:self.view.bounds];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.class authorizationStatus] != BBMediaPickerAuthorizationStatusAuthorized &&
        !self.hasRequestedPhotosAccess) {
        
        [self setHasRequestedPhotosAccess:YES];
        
        [self.class requestAuthorizationWithCompletion:nil];
    }
}
#pragma mark BBMediaPickerModelDelegate
- (BOOL)mediaPickerModel:(BBMediaPickerModel *)model shouldSelectMedia:(id<BBMediaPickerMedia>)media {
    BOOL retval = YES;
    
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:shouldSelectMedia:)]) {
        retval = [self.delegate mediaPickerViewController:self shouldSelectMedia:media];
    }
    
    return retval;
}
- (BOOL)mediaPickerModel:(BBMediaPickerModel *)model shouldDeselectMedia:(id<BBMediaPickerMedia>)media {
    BOOL retval = YES;
    
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:shouldDeselectMedia:)]) {
        retval = [self.delegate mediaPickerViewController:self shouldDeselectMedia:media];
    }
    
    return retval;
}

- (void)mediaPickerModel:(BBMediaPickerModel *)model didSelectMedia:(id<BBMediaPickerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didSelectMedia:)]) {
        [self.delegate mediaPickerViewController:self didSelectMedia:media];
    }
}
- (void)mediaPickerModel:(BBMediaPickerModel *)model didDeselectMedia:(id<BBMediaPickerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewControllerDidCancel:)]) {
        [self.delegate mediaPickerViewController:self didDeselectMedia:media];
    }
}
#pragma mark *** Public Methods ***
+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return [BBMediaPickerModel authorizationStatus];
}
+ (void)requestAuthorizationWithCompletion:(nullable void(^)(BBMediaPickerAuthorizationStatus status))completion; {
    [BBMediaPickerModel requestAuthorizationWithCompletion:completion];
}

- (NSUInteger)countOfMedia; {
    return self.model.selectedAssetCollectionModel.countOfAssetModels;
}
- (NSUInteger)indexOfMedia:(id<BBMediaPickerMedia>)media; {
    return [self.model.selectedAssetCollectionModel indexOfAssetModel:[[BBMediaPickerAssetModel alloc] initWithAsset:[media mediaAsset] assetCollectionModel:nil]];
}
- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media; {
    
}
#pragma mark Properties
@dynamic theme;
- (BBMediaPickerTheme *)theme {
    return self.model.theme;
}
- (void)setTheme:(BBMediaPickerTheme *)theme {
    [self.model setTheme:theme];
}

@dynamic allowsMultipleSelection;
- (BOOL)allowsMultipleSelection {
    return self.model.allowsMultipleSelection;
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    [self.model setAllowsMultipleSelection:allowsMultipleSelection];
}
@dynamic hidesEmptyAssetCollections;
- (BOOL)hidesEmptyAssetCollections {
    return self.model.hidesEmptyAssetCollections;
}
- (void)setHidesEmptyAssetCollections:(BOOL)hidesEmptyAssetCollections {
    [self.model setHidesEmptyAssetCollections:hidesEmptyAssetCollections];
}

@dynamic mediaTypes;
- (BBMediaPickerMediaTypes)mediaTypes {
    return self.model.mediaTypes;
}
- (void)setMediaTypes:(BBMediaPickerMediaTypes)mediaTypes {
    [self.model setMediaTypes:mediaTypes];
}

@dynamic initiallySelectedAssetCollectionSubtype;
- (BBMediaPickerAssetCollectionSubtype)initiallySelectedAssetCollectionSubtype {
    return self.model.initiallySelectedAssetCollectionSubtype;
}
- (void)setInitiallySelectedAssetCollectionSubtype:(BBMediaPickerAssetCollectionSubtype)initiallySelectedAssetCollectionSubtype {
    [self.model setInitiallySelectedAssetCollectionSubtype:initiallySelectedAssetCollectionSubtype];
}

#pragma mark *** Private Methods ***
- (void)_updateTitleViewProperties; {
    for (UIGestureRecognizer *gr in self.titleView.gestureRecognizers) {
        [self.titleView removeGestureRecognizer:gr];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
    
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    
    [self.titleView addGestureRecognizer:tapGestureRecognizer];
    
    if ([self.titleView respondsToSelector:@selector(setTheme:)]) {
        [self.titleView setTheme:self.model.theme];
    }
    
    [self _updateTitleViewTitleAndSubtitle];
}
- (void)_updateTitleViewTitleAndSubtitle {
    [self.titleView setTitle:self.model.title];
    
    if ([self.titleView respondsToSelector:@selector(setSubtitle:)]) {
        [self.titleView setSubtitle:self.model.subtitle];
    }
    
    [self.titleView sizeToFit];
}
#pragma mark Properties
- (void)setTitleView:(UIView<BBMediaPickerTitleView> *)titleView {
    if ([_titleView isKindOfClass:self.model.theme.titleViewClass]) {
        return;
    }
    
    [self willChangeValueForKey:@BBKeypath(BBMediaPickerViewController.new,titleView)];
    
    _titleView = titleView;
    
    [self didChangeValueForKey:@BBKeypath(BBMediaPickerViewController.new,titleView)];
    
    if (_titleView) {
        [self _updateTitleViewProperties];
        
        [self.navigationItem setTitleView:_titleView];
    }
}
#pragma mark Actions
- (IBAction)_tapGestureRecognizerAction:(id)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[BBMediaPickerAssetCollectionsViewController alloc] initWithModel:self.model]] animated:YES completion:nil];
}

@end
