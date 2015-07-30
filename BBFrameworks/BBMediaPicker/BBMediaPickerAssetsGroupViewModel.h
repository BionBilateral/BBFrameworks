//
//  BBMediaPickerAssetGroupViewModel.h
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
#import <UIKit/UIImage.h>
#import <AssetsLibrary/ALAssetsGroup.h>

@class BBMediaPickerViewModel;

@interface BBMediaPickerAssetsGroupViewModel : RVMViewModel

@property (readonly,strong,nonatomic) ALAssetsGroup *assetsGroup;

@property (assign,nonatomic,getter=isDeleted) BOOL deleted;

@property (readonly,nonatomic) NSURL *URL;
@property (readonly,nonatomic) NSNumber *type;
@property (readonly,nonatomic) UIImage *badgeImage;
@property (readonly,nonatomic) UIImage *posterImage;
@property (readonly,nonatomic) UIImage *secondPosterImage;
@property (readonly,nonatomic) UIImage *thirdPosterImage;
@property (readonly,nonatomic) NSString *name;
@property (readonly,nonatomic) NSInteger count;
@property (readonly,nonatomic) NSString *countString;

@property (readonly,weak,nonatomic) BBMediaPickerViewModel *parentViewModel;

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup parentViewModel:(BBMediaPickerViewModel *)parentViewModel;

- (void)refreshAssetViewModels;

- (RACSignal *)assetViewModels;

@end
