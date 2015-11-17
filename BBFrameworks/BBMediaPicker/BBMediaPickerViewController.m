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

@interface BBMediaPickerViewController () <BBMediaPickerModelDelegate>
@property (strong,nonatomic) BBMediaPickerModel *model;
@property (strong,nonatomic) BBMediaPickerAssetsViewController *assetsViewController;

@property (assign,nonatomic) BOOL hasRequestedPhotosAccess;
@end

@implementation BBMediaPickerViewController
#pragma mark *** Subclass Overrides ***
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
    
    [self setTitleView:[[BBMediaPickerDefaultTitleView alloc] initWithFrame:CGRectZero]];
    
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
    [self BB_addObserverForKeyPath:@BBKeypath(self.titleView) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.navigationItem setTitleView:self.titleView];
    }];
    
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,theme) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        [self.titleView setTheme:self.theme];
        [self.titleView sizeToFit];
    }];
    
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,title) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.titleView setTitle:self.model.title];
        [self.titleView setSubtitle:@"Tap to change album ▼"];
        [self.titleView sizeToFit];
    }];
    
    [self.model BB_addObserverForKeyPath:@BBKeypath(self.model,allowsMultipleSelection) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        if (self.model.allowsMultipleSelection) {
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
#pragma mark Properties
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

- (void)setTitleView:(UIView<BBMediaPickerTitleView> *)titleView {
    _titleView = titleView ?: [[BBMediaPickerDefaultTitleView alloc] initWithFrame:CGRectZero];
    
    if (_titleView) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
        
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [tapGestureRecognizer setNumberOfTouchesRequired:1];
        
        [_titleView addGestureRecognizer:tapGestureRecognizer];
    }
}

@dynamic theme;
- (BBMediaPickerTheme *)theme {
    return self.model.theme;
}
- (void)setTheme:(BBMediaPickerTheme *)theme {
    [self.model setTheme:theme];
}

@dynamic mediaTypes;
- (BBMediaPickerMediaTypes)mediaTypes {
    return self.model.mediaTypes;
}
- (void)setMediaTypes:(BBMediaPickerMediaTypes)mediaTypes {
    [self.model setMediaTypes:mediaTypes];
}
#pragma mark *** Private Methods ***
#pragma mark Actions
- (IBAction)_tapGestureRecognizerAction:(id)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[BBMediaPickerAssetCollectionsViewController alloc] initWithModel:self.model]] animated:YES completion:nil];
}

@end
