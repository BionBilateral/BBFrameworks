//
//  BBAddressBookTableViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBAddressBookTableViewController.h"
#import "BBAddressBookPerson.h"
#import "BBAddressBookPersonTableViewCell.h"
#import "BBFrameworksFunctions.h"
#import "BBAddressBookTableViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAddressBookTableViewController ()
@property (strong,nonatomic) BBAddressBookTableViewModel *viewModel;
@end

@implementation BBAddressBookTableViewController

- (NSString *)title {
    return NSLocalizedStringWithDefaultValue(@"ADDRESS_BOOK_ALL_CONTACTS_TITLE", @"AddressBook", BBFrameworksResourcesBundle(), @"All Contacts", @"all contacts title");
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:[[BBAddressBookTableViewModel alloc] init]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    
    [cancelItem setRac_command:self.viewModel.cancelCommand];
    
    [self.navigationItem setRightBarButtonItems:@[cancelItem]];
    
    [self.tableView setBackgroundView:({
        UIActivityIndicatorView *retval = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [retval setColor:[UIColor darkGrayColor]];
        [retval setHidesWhenStopped:YES];
        
        retval;
    })];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setRowHeight:44.0];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBAddressBookPersonTableViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellReuseIdentifier:NSStringFromClass([BBAddressBookPersonTableViewCell class])];
    
    @weakify(self);
    [[RACObserve(self.viewModel, people)
     deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(NSArray *value) {
        @strongify(self);
        [self.tableView reloadData];
        
        if (value.count > 0) {
            [(UIActivityIndicatorView *)self.tableView.backgroundView stopAnimating];
        }
    }];
    
    [[[self.viewModel.cancelCommand.executionSignals
     concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     }];
}
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (parent) {
        [self.viewModel setActive:YES];
        [(UIActivityIndicatorView *)self.tableView.backgroundView startAnimating];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.people.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBAddressBookPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBAddressBookPersonTableViewCell class]) forIndexPath:indexPath];
    
    [cell setPerson:self.viewModel.people[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
