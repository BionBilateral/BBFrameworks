//
//  BBAssetsPickerAssetGroupTableViewController.m
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

#import "BBAssetsPickerAssetGroupTableViewController.h"
#import "BBAssetsPickerViewModel.h"
#import "BBAssetsPickerAssetGroupViewModel.h"
#import "BBAssetsPickerAssetGroupTableViewCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAssetsPickerAssetGroupTableViewController ()
@property (strong,nonatomic) BBAssetsPickerViewModel *viewModel;
@end

@implementation BBAssetsPickerAssetGroupTableViewController
#pragma mark *** Subclass Overrides ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setRowHeight:[BBAssetsPickerAssetGroupTableViewCell rowHeight]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBAssetsPickerAssetGroupTableViewCell class]) bundle:[NSBundle bundleForClass:[BBAssetsPickerAssetGroupTableViewCell class]]] forCellReuseIdentifier:NSStringFromClass([BBAssetsPickerAssetGroupTableViewCell class])];
    
    @weakify(self);
    [[RACObserve(self.viewModel, assetGroupViewModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.tableView reloadData];
     }];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.assetGroupViewModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBAssetsPickerAssetGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBAssetsPickerAssetGroupTableViewCell class]) forIndexPath:indexPath];
    
    [cell setViewModel:self.viewModel.assetGroupViewModels[indexPath.row]];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBAssetsPickerViewModel *)viewModel; {
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    return self;
}

@end
