//
//  BBMediaPickerAssetsGroupTableViewController.m
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

#import "BBMediaPickerAssetsGroupTableViewController.h"
#import "BBMediaPickerAssetsGroupTableViewCell.h"
#import "BBMediaPickerViewModel.h"
#import "BBMediaPickerAssetCollectionViewController.h"
#import "BBMediaPickerAssetsGroupTableView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetsGroupTableViewController ()
@property (strong,nonatomic) BBMediaPickerViewModel *viewModel;
@end

@implementation BBMediaPickerAssetsGroupTableViewController
#pragma mark *** Subclass Overrides ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView:[[BBMediaPickerAssetsGroupTableView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:[BBMediaPickerAssetsGroupTableViewCell rowHeight]];
    [self.tableView registerClass:[BBMediaPickerAssetsGroupTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BBMediaPickerAssetsGroupTableViewCell class])];
    
    @weakify(self);
    [[RACObserve(self.viewModel, assetsGroupViewModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.tableView reloadData];
     }];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.assetsGroupViewModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetsGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBMediaPickerAssetsGroupTableViewCell class]) forIndexPath:indexPath];
    
    [cell setViewModel:self.viewModel.assetsGroupViewModels[indexPath.row]];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[BBMediaPickerAssetCollectionViewController alloc] initWithViewModel:self.viewModel.assetsGroupViewModels[indexPath.row]] animated:YES];
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBMediaPickerViewModel *)viewModel; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    return self;
}

@end
