//
//  BBMediaPickerFilterTableViewController.m
//  BBFrameworks
//
//  Created by William Towe on 11/18/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerFilterTableViewController.h"
#import "BBMediaPickerModel.h"
#import "BBMediaPickerFilterModel.h"
#import "BBMediaPickerFilterTableViewCell.h"
#import "BBFrameworksFunctions.h"
#import "BBBlocks.h"

@interface BBMediaPickerFilterTableViewController ()
@property (strong,nonatomic) BBMediaPickerModel *model;
@end

@implementation BBMediaPickerFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setRowHeight:[BBMediaPickerFilterTableViewCell rowHeight]];
    [self.tableView setAllowsMultipleSelection:YES];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBMediaPickerFilterTableViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellReuseIdentifier:NSStringFromClass([BBMediaPickerFilterTableViewCell class])];
    
    for (BBMediaPickerFilterModel *filterModel in self.model.selectedFilterModels) {
        NSUInteger index = [self.model.filterModels indexOfObject:filterModel];
        
        if (index == NSNotFound) {
            continue;
        }
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.filterModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaPickerFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBMediaPickerFilterTableViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:self.model.filterModels[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate mediaPickerFilterTableViewController:self didSelectFilterModel:self.model.filterModels[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate mediaPickerFilterTableViewController:self didDeselectFilterModel:self.model.filterModels[indexPath.row]];
}


- (instancetype)initWithModel:(BBMediaPickerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:model];
    
    return self;
}

@end
