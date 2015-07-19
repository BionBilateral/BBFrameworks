//
//  BBFormTableViewController.m
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

#import "BBFormTableViewController.h"
#import "BBFormTextTableViewCell.h"
#import "BBFormField.h"
#import "BBFormBooleanSwitchTableViewCell.h"
#import "BBFormPickerTableViewCell.h"
#import "BBFormDatePickerTableViewCell.h"
#import "BBFormBooleanCheckmarkTableViewCell.h"
#import "BBFormTableViewHeaderView.h"
#import "BBFormTableViewFooterView.h"
#import "BBFormStepperTableViewCell.h"

static NSString *const kFormFieldDictionariesKey = @"formFieldDictionaries";

static void *kObservingContext = &kObservingContext;

@interface BBFormTableViewController ()
@property (copy,nonatomic) NSArray *formFields;
@end

@implementation BBFormTableViewController
#pragma mark *** Subclass Overrides ***
- (instancetype)init {
    if (!(self = [super initWithStyle:UITableViewStyleGrouped]))
        return nil;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.formFields.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formFields[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBFormField *formField = self.formFields[indexPath.section][indexPath.row];
    Class cellClass = [self tableViewCellClassForFormField:formField];
    BBFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
    }
    
    [cell setFormField:formField];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BBFormField *formField = self.formFields[section][0];
    Class viewClass = [self tableViewHeaderClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        if ([view respondsToSelector:@selector(setTitle:)]) {
            [(id)view setTitle:formField.titleHeader];
        }
        
        return [view sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)].height;
    }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BBFormField *formField = self.formFields[section][0];
    Class viewClass = [self tableViewFooterClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        if ([view respondsToSelector:@selector(setTitle:)]) {
            [(id)view setTitle:formField.titleFooter];
        }
        
        return [view sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)].height;
    }
    return 0.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BBFormField *formField = self.formFields[section][0];
    Class viewClass = [self tableViewHeaderClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        if ([view respondsToSelector:@selector(setTitle:)]) {
            [(id)view setTitle:formField.titleHeader];
        }
        
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BBFormField *formField = self.formFields[section][0];
    Class viewClass = [self tableViewFooterClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        if ([view respondsToSelector:@selector(setTitle:)]) {
            [(id)view setTitle:formField.titleFooter];
        }
        
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBFormField *formField = self.formFields[indexPath.section][indexPath.row];
    
    if (formField.viewControllerClass) {
        [self.navigationController pushViewController:[[formField.viewControllerClass alloc] init] animated:YES];
    }
    else if (formField.didSelectBlock) {
        formField.didSelectBlock(formField,indexPath);
    }
    else if (formField.type == BBFormFieldTypeBooleanCheckmark) {
        [formField setBoolValue:!formField.boolValue];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark *** Public Methods ***
- (Class)tableViewCellClassForFormField:(BBFormField *)formField; {
    switch (formField.type) {
        case BBFormFieldTypeText:
        case BBFormFieldTypeLabel:
            return [BBFormTextTableViewCell class];
        case BBFormFieldTypeBooleanSwitch:
            return [BBFormBooleanSwitchTableViewCell class];
        case BBFormFieldTypeBooleanCheckmark:
            return [BBFormBooleanCheckmarkTableViewCell class];
        case BBFormFieldTypePicker:
            return [BBFormPickerTableViewCell class];
        case BBFormFieldTypeDatePicker:
            return [BBFormDatePickerTableViewCell class];
        case BBFormFieldTypeStepper:
            return [BBFormStepperTableViewCell class];
        default:
            return Nil;
    }
}
- (Class)tableViewHeaderClassForFormField:(BBFormField *)formField; {
    if (formField.titleHeader) {
        return [BBFormTableViewHeaderView class];
    }
    return Nil;
}
- (Class)tableViewFooterClassForFormField:(BBFormField *)formField {
    if (formField.titleFooter) {
        return [BBFormTableViewFooterView class];
    }
    return Nil;
}

- (void)reloadData; {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.dataSource.formFieldDictionaries) {
        [temp addObject:[[BBFormField alloc] initWithDictionary:dict dataSource:self.dataSource]];
    }
    
    [self setFormFields:@[temp]];
}
#pragma mark Properties
- (void)setDataSource:(id<BBFormTableViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (_dataSource) {
        [self reloadData];
    }
}
#pragma mark *** Private Methods ***
#pragma mark Properties
- (void)setFormFields:(NSArray *)formFields {
    _formFields = formFields;
    
    [self.tableView reloadData];
}

@end
