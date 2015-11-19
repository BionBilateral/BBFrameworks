//
//  BBMediaPickerFilterViewController.m
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

#import "BBMediaPickerFilterViewController.h"
#import "BBMediaPickerModel.h"
#import "BBMediaPickerFilterTableViewController.h"
#import "BBMediaPickerFilterModel.h"
#import "BBBlocks.h"
#import "NSArray+BBFoundationExtensions.h"

@interface BBMediaPickerFilterViewController () <BBMediaPickerFilterTableViewControllerDelegate>
@property (strong,nonatomic) BBMediaPickerFilterTableViewController *tableViewController;

@property (strong,nonatomic) BBMediaPickerModel *model;
@property (copy,nonatomic) NSSet<BBMediaPickerFilterModel *> *selectedFilterModels;

@property (strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@end

@implementation BBMediaPickerFilterViewController

- (NSString *)title {
    return @"Filter";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewController:[[BBMediaPickerFilterTableViewController alloc] initWithModel:self.model]];
    [self.tableViewController setDelegate:self];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setDoneBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneBarButtonItemAction:)]];
    [self.doneBarButtonItem setEnabled:NO];
    [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancelBarButtonItemAction:)];
    
    [self.navigationItem setLeftBarButtonItems:@[cancelItem]];
}
- (void)viewDidLayoutSubviews {
    [self.tableViewController.view setFrame:self.view.bounds];
}

- (void)mediaPickerFilterTableViewController:(BBMediaPickerFilterTableViewController *)mpftvc didSelectFilterModel:(BBMediaPickerFilterModel *)filterModel {
    NSMutableSet *temp = [NSMutableSet setWithSet:self.selectedFilterModels];
    
    [temp addObject:filterModel];
    
    [self setSelectedFilterModels:temp];
}
- (void)mediaPickerFilterTableViewController:(BBMediaPickerFilterTableViewController *)mpftvc didDeselectFilterModel:(BBMediaPickerFilterModel *)filterModel {
    NSMutableSet *temp = [NSMutableSet setWithSet:self.selectedFilterModels];
    
    [temp removeObject:filterModel];
    
    [self setSelectedFilterModels:temp];
}

- (instancetype)initWithModel:(BBMediaPickerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:model];
    [self setSelectedFilterModels:self.model.selectedFilterModels];
    
    return self;
}

- (void)setSelectedFilterModels:(NSSet<BBMediaPickerFilterModel *> *)selectedFilterModels {
    _selectedFilterModels = [selectedFilterModels copy];
    
    [self.doneBarButtonItem setEnabled:![self.model.selectedFilterModels isEqual:_selectedFilterModels]];
}

- (IBAction)_doneBarButtonItemAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)_cancelBarButtonItemAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
