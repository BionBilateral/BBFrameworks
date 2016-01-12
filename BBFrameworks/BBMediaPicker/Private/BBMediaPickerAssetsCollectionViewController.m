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
#import "BBFrameworksMacros.h"
#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBFrameworksFunctions.h"
#import "BBMediaPickerAssetCollectionViewLayout.h"
#import "BBMediaPickerAssetModel.h"
#import "BBMediaPickerAssetCollectionModel.h"
#import "BBMediaPickerTheme.h"
#import "BBMediaPickerModel.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetsCollectionViewController ()
@property (strong,nonatomic) BBMediaPickerModel *model;
@end

@implementation BBMediaPickerAssetsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self.collectionView setAllowsMultipleSelection:self.model.allowsMultipleSelection];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellWithReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class])];
    
    BBWeakify(self);
    [[RACObserve(self.model, selectedAssetCollectionModel.countOfAssetModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         [self.collectionView reloadData];
         
         // scroll to the last item
         if (self.model.selectedAssetCollectionModel.countOfAssetModels > 0) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.model.selectedAssetCollectionModel.countOfAssetModels - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
         }
     }];
    
    [[RACObserve(self.model, selectedAssetIdentifiers)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
             BBMediaPickerAssetCollectionViewCell *cell = (BBMediaPickerAssetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
             
             [cell reloadSelectedOverlayView];
             
             if ([self.model isAssetModelSelected:cell.model]) {
                 [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
             }
             else {
                 [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
             }
         }
     }];
    
    [[RACObserve(self.model, theme)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         [(UICollectionView *)self.collectionView setBackgroundColor:self.model.theme.assetBackgroundColor];
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetModel *model = [(BBMediaPickerAssetCollectionViewCell *)cell model];
    
    if ([self.model isAssetModelSelected:model]) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = (BBMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    return [self.model shouldSelectAssetModel:cell.model];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = (BBMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    return [self.model shouldDeselectAssetModel:cell.model];
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

- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media; {
    NSUInteger index = [self.model.selectedAssetCollectionModel indexOfAssetModel:[[BBMediaPickerAssetModel alloc] initWithAsset:[media mediaAsset] assetCollectionModel:nil]];
    
    if (index == NSNotFound) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

@end
