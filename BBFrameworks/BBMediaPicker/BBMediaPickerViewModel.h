//
//  BBMediaPickerViewModel.h
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

#import <ReactiveViewModel/RVMViewModel.h>
#import <UIKit/UIBarButtonItem.h>
#import "BBMediaPickerDefines.h"
#import "BBMediaPickerViewModelDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class BBMediaPickerAssetsGroupViewModel,BBMediaPickerAssetViewModel,BBMediaPickerViewController;
@class RACCommand;

@interface BBMediaPickerViewModel : RVMViewModel

+ (BBMediaPickerAuthorizationStatus)authorizationStatus;

@property (weak,nonatomic,nullable) id<BBMediaPickerViewModelDelegate> delegate;

@property (assign,nonatomic) BOOL allowsMultipleSelection;
@property (assign,nonatomic) BOOL hidesEmptyMediaGroups;
@property (assign,nonatomic) BOOL automaticallyDismissForSingleSelection;
@property (copy,nonatomic,nullable) NSString *cancelBarButtonItemTitle;

@property (assign,nonatomic) BBMediaPickerMediaTypes mediaTypes;

@property (copy,nonatomic,nullable) BBMediaPickerMediaFilterBlock mediaFilterBlock;

@property (readonly,copy,nonatomic) NSString *selectedAssetString;

@property (readonly,copy,nonatomic) NSArray *assetsGroupViewModels;
@property (readonly,copy,nonatomic) NSOrderedSet *selectedAssetViewModels;

@property (readonly,strong,nonatomic) RACCommand *cancelCommand;
@property (readonly,strong,nonatomic) RACCommand *doneCommand;

@property (readonly,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (readonly,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;

@property (readonly,weak,nonatomic) BBMediaPickerViewController *mediaPickerViewController;

- (instancetype)initWithViewController:(BBMediaPickerViewController *)viewController;

- (void)selectAssetViewModel:(BBMediaPickerAssetViewModel *)viewModel;
- (void)deselectAssetViewModel:(BBMediaPickerAssetViewModel *)viewModel;
- (void)deselectAllAssetViewModels;

- (RACSignal *)requestAssetsLibraryAuthorization;

@end

NS_ASSUME_NONNULL_END
