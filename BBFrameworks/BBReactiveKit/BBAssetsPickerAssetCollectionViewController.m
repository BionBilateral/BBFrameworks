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

#import "BBAssetsPickerAssetCollectionViewController.h"
#import "BBAssetsPickerAssetGroupViewModel.h"
#import "BBAssetsPickerAssetCollectionViewCell.h"
#import "BBAssetsPickerAssetViewModel.h"
#import "BBAssetsPickerViewController+BBReactiveKitExtensionsPrivate.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAssetsPickerAssetCollectionViewController ()
@property (strong,nonatomic) BBAssetsPickerAssetGroupViewModel *viewModel;
@end

@implementation BBAssetsPickerAssetCollectionViewController
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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self BB_assetsPickerViewController].cancelBarButtonItem) {
        [self.navigationItem setRightBarButtonItems:@[[self BB_assetsPickerViewController].cancelBarButtonItem]];
    }
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.assetViewModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBAssetsPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBAssetsPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setViewModel:self.viewModel.assetViewModels[indexPath.row]];
    
    return cell;
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBAssetsPickerAssetGroupViewModel *)viewModel; {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setSectionInset:UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0)];
    [layout setMinimumInteritemSpacing:2.0];
    [layout setMinimumLineSpacing:2.0];
    [layout setItemSize:[BBAssetsPickerAssetCollectionViewCell defaultCellSize]];
    
    if (!(self = [super initWithCollectionViewLayout:layout]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    return self;
}

@end
