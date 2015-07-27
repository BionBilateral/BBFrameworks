//
//  BBFormTableViewController.h
//  BBFrameworks
//
//  Created by William Towe on 7/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import "BBFormTableViewControllerDataSource.h"
#import "BBFormField.h"
#import "BBFormFieldTableViewCell.h"
#import "BBFormFieldTableViewHeaderView.h"
#import "BBFormFieldTableViewFooterView.h"

@interface BBFormTableViewController : UITableViewController

@property (weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;

- (void)registerTableViewHeaderClass:(Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClass;
- (void)registerTableViewFooterClass:(Class<BBFormFieldTableViewFooterView>)tableViewFooterClass;
- (void)registerCellClass:(Class<BBFormFieldTableViewCell>)cellClass forFormFieldType:(BBFormFieldType)formFieldType;

- (Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClassForFormField:(BBFormField *)formField;
- (Class<BBFormFieldTableViewFooterView>)tableViewFooterClassForFormField:(BBFormField *)formField;
- (Class<BBFormFieldTableViewCell>)tableViewCellClassForFormField:(BBFormField *)formField;

- (BBFormField *)formFieldForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForFormField:(BBFormField *)formField;

- (void)reloadData;
- (void)reloadRowsForFormFields:(NSArray *)formFields;

@end
