//
//  BBMediaPickerAssetCollectionsTableViewController.m
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

#import "BBMediaPickerAssetCollectionsTableViewController.h"
#import "BBMediaPickerAssetCollectionTableViewCell.h"
#import "BBFrameworksFunctions.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerTheme.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionsTableViewController ()
@property (strong,nonatomic) BBMediaPickerModel *model;
@end

@implementation BBMediaPickerAssetCollectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setRowHeight:[BBMediaPickerAssetCollectionTableViewCell rowHeight]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBMediaPickerAssetCollectionTableViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellReuseIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionTableViewCell class])];
    
    BBWeakify(self);
    [[RACObserve(self.model, theme)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         [self.tableView setTintColor:self.model.theme.assetCollectionCellCheckmarkColor];
         [self.tableView setSeparatorColor:self.model.theme.assetCollectionSeparatorColor];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.assetCollectionModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBMediaPickerAssetCollectionTableViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:self.model.assetCollectionModels[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerAssetCollectionModel *model = self.model.assetCollectionModels[indexPath.row];
    
    if ([model.identifier isEqualToString:self.model.selectedAssetCollectionModel.identifier]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.model setSelectedAssetCollectionModel:self.model.assetCollectionModels[indexPath.row]];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithModel:(BBMediaPickerModel *)model {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:model];
    
    return self;
}

@end
