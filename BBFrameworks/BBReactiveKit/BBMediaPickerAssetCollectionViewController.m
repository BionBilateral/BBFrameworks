//
//  BBAssetsPickerAssetCollectionViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
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
#import "BBMediaPickerCollectionViewModel.h"
#import "BBAssetsPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetViewModel.h"
#import "BBMediaPickerViewController+BBReactiveKitExtensionsPrivate.h"
#import "BBMediaPickerAssetCollectionViewLayout.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionViewController ()
@property (strong,nonatomic) BBMediaPickerCollectionViewModel *viewModel;
@end

@implementation BBMediaPickerAssetCollectionViewController
#pragma mark *** Subclass Overrides ***
- (NSString *)title {
    return self.viewModel.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BBAssetsPickerAssetCollectionViewCell class]) bundle:[NSBundle bundleForClass:[BBAssetsPickerAssetCollectionViewCell class]]] forCellWithReuseIdentifier:NSStringFromClass([BBAssetsPickerAssetCollectionViewCell class])];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, deleted)
      ignore:@NO]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.navigationController popViewControllerAnimated:YES];
     }];
    
    [[RACObserve(self.viewModel, assetViewModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.collectionView reloadData];
     }];
    
    [[[self.viewModel.doneCommand.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         
         BBMediaPickerViewController *viewController = [self BB_mediaPickerViewController];
         
         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
             @strongify(self);
             if ([viewController.delegate respondsToSelector:@selector(assetsPickerViewController:didFinishPickingAssets:)]) {
                 
                 [viewController.delegate assetsPickerViewController:viewController didFinishPickingAssets:self.viewModel.selectedAssetViewModels];
             }
         }];
     }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self BB_mediaPickerViewController].allowsMultipleSelection) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
        
        [doneItem setRac_command:self.viewModel.doneCommand];
        
        [self.navigationItem setRightBarButtonItems:@[doneItem]];
        
        [self.collectionView setAllowsMultipleSelection:YES];
    }
    else if ([self BB_mediaPickerViewController].cancelBarButtonItem) {
        [self.navigationItem setRightBarButtonItems:@[[self BB_mediaPickerViewController].cancelBarButtonItem]];
    }
}
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (parent) {
        [self.viewModel setActive:YES];
    }
    else {
        [self.viewModel setActive:NO];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];

    [(BBMediaPickerAssetCollectionViewLayout *)self.collectionView.collectionViewLayout setNumberOfColumns:self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular ? 5 : 3];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.assetViewModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBAssetsPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBAssetsPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setTintColor:collectionView.tintColor];
    [cell setViewModel:self.viewModel.assetViewModels[indexPath.row]];
    
    return cell;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetViewModel *viewModel = self.viewModel.assetViewModels[indexPath.row];
    
    if ([self.viewModel.selectedAssetViewModels containsObject:viewModel]) {
        [cell setSelected:YES];
    }
    else {
        [cell setSelected:NO];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetViewModel *viewModel = self.viewModel.assetViewModels[indexPath.row];
    
    if ([self BB_mediaPickerViewController].allowsMultipleSelection) {
        if ([self.viewModel.selectedAssetViewModels containsObject:viewModel]) {
            [self.viewModel deselectAssetViewModel:viewModel];
        }
        else {
            [self.viewModel selectAssetViewModel:viewModel];
        }
    }
    else {
        [self.viewModel selectAssetViewModel:viewModel];
        
        BBMediaPickerViewController *viewController = [self BB_mediaPickerViewController];
        
        @weakify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            
            if ([viewController.delegate respondsToSelector:@selector(assetsPickerViewController:didFinishPickingAssets:)]) {
                [viewController.delegate assetsPickerViewController:viewController didFinishPickingAssets:self.viewModel.selectedAssetViewModels];
            }
        }];
    }
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBMediaPickerCollectionViewModel *)viewModel; {
    if (!(self = [super initWithCollectionViewLayout:[[BBMediaPickerAssetCollectionViewLayout alloc] init]]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    return self;
}

@end
