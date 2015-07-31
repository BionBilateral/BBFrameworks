//
//  BBMediaPickerAssetCollectionViewController.m
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

#import "BBMediaPickerAssetCollectionViewController.h"
#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetsGroupViewModel.h"
#import "BBMediaPickerViewModel.h"
#import "BBMediaPickerAssetCollectionViewLayout.h"
#import "BBMediaPickerViewController.h"
#import "BBMediaPickerAssetCollectionFooterView.h"
#import "BBMediaPickerAssetCollectionView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) BBMediaPickerAssetsGroupViewModel *viewModel;
@property (copy,nonatomic) NSArray *assetViewModels;
@end

@implementation BBMediaPickerAssetCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.viewModel.parentViewModel.allowsMultipleSelection) {
        [self.navigationItem setRightBarButtonItems:@[self.viewModel.parentViewModel.doneBarButtonItem]];
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[self.viewModel.parentViewModel.cancelBarButtonItem]];
    }
    
    [self setCollectionView:[[BBMediaPickerAssetCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[BBMediaPickerAssetCollectionViewLayout alloc] init]]];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setAllowsMultipleSelection:self.viewModel.parentViewModel.allowsMultipleSelection];
    [self.collectionView registerClass:[BBMediaPickerAssetCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionFooterView class])];
    [self.collectionView registerClass:[BBMediaPickerAssetCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class])];
    
    @weakify(self);
    
    [[[RACObserve(self.viewModel, deleted)
     ignore:@NO]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.navigationController popToRootViewControllerAnimated:YES];
     }];
    
    RAC(self,assetViewModels) = [self.viewModel assetViewModels];
    
    [[RACObserve(self, assetViewModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.collectionView reloadData];
         
         if (self.assetViewModels.count > 0) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assetViewModels.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
         }
     }];
    
    if (self.viewModel.parentViewModel.allowsMultipleSelection) {
        RAC(self,title) = [RACSignal combineLatest:@[RACObserve(self.viewModel, name),RACObserve(self.viewModel.parentViewModel, selectedAssetString)] reduce:^id(NSString *name, NSString *selected){
            return selected.length > 0 ? selected : name;
        }];
    }
    else {
        RAC(self,title) = RACObserve(self.viewModel, name);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetViewModels.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionFooterView class]) forIndexPath:indexPath];
    
    [view setViewModel:self.viewModel];
    
    return view;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setViewModel:self.assetViewModels[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), [BBMediaPickerAssetCollectionFooterView rowHeight]);
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel.parentViewModel.selectedAssetViewModels containsObject:self.assetViewModels[indexPath.row]]) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.parentViewModel selectAssetViewModel:self.assetViewModels[indexPath.row]];
    
    if ([self.viewModel.parentViewModel.mediaPickerViewController.delegate respondsToSelector:@selector(mediaPickerViewController:didSelectMedia:)]) {
        [self.viewModel.parentViewModel.mediaPickerViewController.delegate mediaPickerViewController:self.viewModel.parentViewModel.mediaPickerViewController didSelectMedia:@[self.assetViewModels[indexPath.row]]];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.parentViewModel deselectAssetViewModel:self.assetViewModels[indexPath.row]];
    
    if ([self.viewModel.parentViewModel.mediaPickerViewController.delegate respondsToSelector:@selector(mediaPickerViewController:didDeselectMedia:)]) {
        [self.viewModel.parentViewModel.mediaPickerViewController.delegate mediaPickerViewController:self.viewModel.parentViewModel.mediaPickerViewController didDeselectMedia:@[self.assetViewModels[indexPath.row]]];
    }
}

- (instancetype)initWithViewModel:(BBMediaPickerAssetsGroupViewModel *)viewModel; {
    if (!(self = [super initWithCollectionViewLayout:[[BBMediaPickerAssetCollectionViewLayout alloc] init]]))
        return nil;
    
    [self setViewModel:viewModel];
    [self setTitle:self.viewModel.name];
    
    return self;
}

@end
