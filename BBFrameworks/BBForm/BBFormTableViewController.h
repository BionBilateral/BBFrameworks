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

NS_ASSUME_NONNULL_BEGIN

/**
 BBFormTableViewController is a UITableViewController subclass that manages settings style table view.
 */
@interface BBFormTableViewController : UITableViewController

/**
 Set and get the data source of the receiver.
 
 @see BBFormTableViewControllerDataSource
 */
@property (weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;

/**
 Register a table view header class that conforms to BBFormFieldTableViewHeaderView.
 
 The default is BBFormTableViewHeaderView.
 
 @param tableViewHeaderClass The table view header class to register
 */
- (void)registerTableViewHeaderClass:(Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClass;
/**
 Register a table view footer class that conforms to BBFormFieldTableViewFooterView.
 
 The default is BBFormTableViewFooterView.
 
 @param tableViewFooterClass The table view footer class to register
 */
- (void)registerTableViewFooterClass:(Class<BBFormFieldTableViewFooterView>)tableViewFooterClass;
/**
 Register a table view cell class for form field type.
 
 @param cellClass The table view cell class to register
 @param formFieldType The form field type for which to register
 */
- (void)registerCellClass:(Class<BBFormFieldTableViewCell>)cellClass forFormFieldType:(BBFormFieldType)formFieldType;

/**
 Return the table view header view for form field.
 
 @param formField The form field for which to return a table view header class
 @return The table view header class
 */
- (Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClassForFormField:(BBFormField *)formField;

/**
 Return the table view footer view for form field.
 
 @param formField The form field for which to return a table view footer class
 @return The table view footer class
 */
- (Class<BBFormFieldTableViewFooterView>)tableViewFooterClassForFormField:(BBFormField *)formField;
/**
 Return the table view cell class for form field.
 
 @param formField The form field for which to return a table view cell class
 @return The table view cell class
 */
- (Class<BBFormFieldTableViewCell>)tableViewCellClassForFormField:(BBFormField *)formField;

/**
 Return the form field for the provided index path.
 
 @param indexPath The index path for which to return a form field
 @return The form field for index path
 */
- (nullable BBFormField *)formFieldForIndexPath:(NSIndexPath *)indexPath;
/**
 Return the index path for the provided form field.
 
 @param formField The form field for which to return a index path
 @param The index path for form field
 */
- (NSIndexPath *)indexPathForFormField:(BBFormField *)formField;

/**
 Reload the table view managed by the receiver.
 */
- (void)reloadData;
/**
 Reload the rows represented by the array of form fields.
 
 @param formFields An array of BBFormField objects
 */
- (void)reloadRowsForFormFields:(NSArray<BBFormField *> *)formFields;

@end

NS_ASSUME_NONNULL_END
