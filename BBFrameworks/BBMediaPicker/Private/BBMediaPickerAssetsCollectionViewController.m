//
//  BBMediaPickerAssetsCollectionViewController.m
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

#import "BBMediaPickerAssetsCollectionViewController.h"
#import "BBKeyValueObserving.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBFrameworksFunctions.h"
#import "BBMediaPickerAssetCollectionViewLayout.h"
#import "BBMediaPickerAssetModel.h"
#import "BBMediaPickerAssetCollectionModel.h"

@interface BBMediaPickerAssetsCollectionViewController ()
@property (strong,nonatomic) BBMediaPickerModel *model;
@end

@implementation BBMediaPickerAssetsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setAllowsMultipleSelection:YES];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellWithReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class])];
    
    BBWeakify(self);
    [self.model BB_addObserverForKeyPath:@"selectedAssetCollectionModel" options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.collectionView reloadData];
    }];
    
    [self.model BB_addObserverForKeyPath:@"selectedAssetIdentifiers" options:0 block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        for (BBMediaPickerAssetCollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.isSelected) {
                [cell reloadSelectedOverlayView];
            }
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.selectedAssetCollectionModel.countOfAssetModels;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:[self.model.selectedAssetCollectionModel assetModelAtIndex:indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = (BBMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.model selectAssetModel:cell.model];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = (BBMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.model deselectAssetModel:cell.model];
}

- (instancetype)initWithModel:(BBMediaPickerModel *)model {
    if (!(self = [super initWithCollectionViewLayout:[[BBMediaPickerAssetCollectionViewLayout alloc] init]]))
        return nil;
    
    [self setModel:model];
    
    return self;
}

@end
