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
#import "BBFormSliderTableViewCell.h"
#import "BBFormSegmentedTableViewCell.h"
#import "BBNextPreviousInputAccessoryView.h"
#import "BBBlocks.h"
#import "NSArray+BBFoundationExtensions.h"

@interface BBFormTableViewController ()
@property (copy,nonatomic) NSArray *formFields;

@property (strong,nonatomic) Class<BBFormFieldTableViewHeaderView> tableViewHeaderClass;
@property (strong,nonatomic) Class<BBFormFieldTableViewFooterView> tableViewFooterClass;
@property (strong,nonatomic) NSMutableDictionary *formFieldTypesToCellClasses;

- (UITableViewHeaderFooterView<BBFormFieldTableViewHeaderView> *)_tableViewHeaderViewForFormField:(BBFormField *)formField;
- (UITableViewHeaderFooterView<BBFormFieldTableViewFooterView> *)_tableViewFooterViewForFormField:(BBFormField *)formField;
@end

@implementation BBFormTableViewController
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (!(self = [super initWithStyle:UITableViewStyleGrouped]))
        return nil;
    
    _formFieldTypesToCellClasses = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nextPreviousInputAccessoryViewNotification:) name:BBNextPreviousInputAccessoryViewNotificationNext object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nextPreviousInputAccessoryViewNotification:) name:BBNextPreviousInputAccessoryViewNotificationPrevious object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
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
    UITableViewCell<BBFormFieldTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
    }
    
    [cell setFormField:formField];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self _tableViewHeaderViewForFormField:self.formFields[section][0]] sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)].height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [[self _tableViewFooterViewForFormField:self.formFields[section][0]] sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.frame), CGFLOAT_MAX)].height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self _tableViewHeaderViewForFormField:self.formFields[section][0]];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self _tableViewFooterViewForFormField:self.formFields[section][0]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBFormField *formField = self.formFields[indexPath.section][indexPath.row];
    
    if (formField.viewControllerClass) {
        id viewController = [[formField.viewControllerClass alloc] init];
        
        if ([viewController respondsToSelector:@selector(setFormField:)]) {
            [viewController setFormField:formField];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
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
- (void)registerTableViewHeaderClass:(Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClass; {
    [self setTableViewHeaderClass:tableViewHeaderClass];
}
- (void)registerTableViewFooterClass:(Class<BBFormFieldTableViewFooterView>)tableViewFooterClass; {
    [self setTableViewFooterClass:tableViewFooterClass];
}
- (void)registerCellClass:(Class<BBFormFieldTableViewCell>)cellClass forFormFieldType:(BBFormFieldType)formFieldType; {
    [self.formFieldTypesToCellClasses setObject:cellClass forKey:@(formFieldType)];
}

- (Class<BBFormFieldTableViewHeaderView>)tableViewHeaderClassForFormField:(BBFormField *)formField; {
    if (formField.tableViewHeaderViewClass) {
        NSParameterAssert([formField.tableViewHeaderViewClass conformsToProtocol:@protocol(BBFormFieldTableViewHeaderView)]);
        
        return formField.tableViewHeaderViewClass;
    }
    else if (self.tableViewHeaderClass) {
        return self.tableViewHeaderClass;
    }
    else if (formField.titleHeader) {
        return [BBFormTableViewHeaderView class];
    }
    return Nil;
}
- (Class<BBFormFieldTableViewFooterView>)tableViewFooterClassForFormField:(BBFormField *)formField {
    if (formField.tableViewFooterViewClass) {
        NSParameterAssert([formField.tableViewFooterViewClass conformsToProtocol:@protocol(BBFormFieldTableViewFooterView)]);
        
        return formField.tableViewFooterViewClass;
    }
    else if (self.tableViewFooterClass) {
        return self.tableViewFooterClass;
    }
    else if (formField.titleFooter) {
        return [BBFormTableViewFooterView class];
    }
    return Nil;
}
- (Class<BBFormFieldTableViewCell>)tableViewCellClassForFormField:(BBFormField *)formField; {
    if (formField.tableViewCellClass) {
        return formField.tableViewCellClass;
    }
    else if (self.formFieldTypesToCellClasses[@(formField.type)]) {
        return self.formFieldTypesToCellClasses[@(formField.type)];
    }
    else {
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
            case BBFormFieldTypeSlider:
                return [BBFormSliderTableViewCell class];
            case BBFormFieldTypeSegmented:
                return [BBFormSegmentedTableViewCell class];
            default:
                return Nil;
        }
    }
}

- (BBFormField *)formFieldForIndexPath:(NSIndexPath *)indexPath; {
    return self.formFields[indexPath.section][indexPath.row];
}
- (NSIndexPath *)indexPathForFormField:(BBFormField *)formField; {
    __block NSIndexPath *retval = nil;
    
    [self.formFields enumerateObjectsUsingBlock:^(NSArray *rows, NSUInteger section, BOOL *stop) {
        [rows enumerateObjectsUsingBlock:^(BBFormField *ff, NSUInteger row, BOOL *stop) {
            if ([ff isEqual:formField]) {
                retval = [NSIndexPath indexPathForRow:row inSection:section];
                *stop = YES;
            }
        }];
        
        if (retval) {
            *stop = YES;
        }
    }];
    
    return retval;
}

- (void)reloadData; {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableArray *section = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.dataSource.formFieldDictionaries) {
        BBFormField *formField = [[BBFormField alloc] initWithDictionary:dict dataSource:self.dataSource];
        
        if (formField.titleHeader ||
            formField.titleFooter ||
            formField.tableViewHeaderViewClass ||
            formField.tableViewFooterViewClass) {
            
            if (section.count > 0) {
                [temp addObject:[section copy]];
                
                [section removeAllObjects];
            }
            
            [section addObject:formField];
        }
        else {
            [section addObject:formField];
        }
    }
    
    if (section.count > 0) {
        [temp addObject:[section copy]];
    }
    
    [self setFormFields:temp];
}
- (void)reloadRowsForFormFields:(NSArray *)formFields; {
    [self.tableView reloadRowsAtIndexPaths:[formFields BB_map:^id(id object, NSInteger index) {
        return [self indexPathForFormField:object];
    }] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark Properties
- (void)setDataSource:(id<BBFormTableViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (_dataSource) {
        [self reloadData];
    }
}
#pragma mark *** Private Methods ***
- (UITableViewHeaderFooterView<BBFormFieldTableViewHeaderView> *)_tableViewHeaderViewForFormField:(BBFormField *)formField; {
    Class viewClass = [self tableViewHeaderClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView<BBFormFieldTableViewHeaderView> *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        [view setFormField:formField];
        
        return view;
    }
    return nil;
}
- (UITableViewHeaderFooterView<BBFormFieldTableViewFooterView> *)_tableViewFooterViewForFormField:(BBFormField *)formField; {
    Class viewClass = [self tableViewFooterClassForFormField:formField];
    
    if (viewClass) {
        UITableViewHeaderFooterView<BBFormFieldTableViewFooterView> *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
        
        if (!view) {
            view = [[viewClass alloc] initWithReuseIdentifier:NSStringFromClass(viewClass)];
        }
        
        [view setFormField:formField];
        
        return view;
    }
    return nil;
}
#pragma mark Properties
- (void)setFormFields:(NSArray *)formFields {
    _formFields = formFields;

    [self.tableView reloadData];
}
#pragma mark Notifications
- (void)_nextPreviousInputAccessoryViewNotification:(NSNotification *)note {
    UITableViewCell *tableViewCell = nil;
    
    // loop through all visible cells and find the one that is currently first responder
    for (UITableViewCell *tvc in self.tableView.visibleCells) {
        if ([tvc isFirstResponder]) {
            tableViewCell = tvc;
            break;
        }
    }
    
    // if something in our table view is first responder, continue
    if (tableViewCell) {
        // flatten our array of form field arrays into a single array
        NSArray *flattenedFormFields = [self.formFields BB_reduceWithStart:[[NSMutableArray alloc] init] block:^id(NSMutableArray *sum, id object, NSInteger index) {
            [sum addObjectsFromArray:object];
            return sum;
        }];
        // find the index of the form field represented by the table view cell
        NSInteger index = [flattenedFormFields indexOfObject:[(BBFormTableViewCell *)tableViewCell formField]];
        BBFormField *formField = nil;
        
        // if the next item was tapped, increment the index
        if ([note.name isEqualToString:BBNextPreviousInputAccessoryViewNotificationNext]) {
            if ((++index) == flattenedFormFields.count) {
                index = 0;
            }
        }
        // if the previous item was tapped, check to make sure we aren't at the beginning of the table view
        else {
            if ((index - 1) < 0) {
                index = flattenedFormFields.count - 1;
            }
        }
        
        // if the next item was tapped, look at the subarray starting with index to the end of the array, otherwise look at the reverse of the beginning of the array to index
        NSArray *subarray = [note.name isEqualToString:BBNextPreviousInputAccessoryViewNotificationNext] ? [flattenedFormFields subarrayWithRange:NSMakeRange(index, flattenedFormFields.count - index)] : [[flattenedFormFields subarrayWithRange:NSMakeRange(0, index)] BB_reversedArray];
        for (BBFormField *ff in subarray) {
            if (ff.isEditable) {
                formField = ff;
                break;
            }
        }
        
        // if the next item was tapped and we didn't find the next form field, start at the beginning of the array
        if (!formField &&
            [note.name isEqualToString:BBNextPreviousInputAccessoryViewNotificationNext]) {
            
            subarray = flattenedFormFields;
            
            for (BBFormField *ff in subarray) {
                if (ff.isEditable) {
                    formField = ff;
                    break;
                }
            }
        }
        
        // if we found the next form field, continue
        if (formField) {
            // get the index path for the next form field
            NSIndexPath *indexPath = [self indexPathForFormField:formField];
            
            // scroll to the middle for the index path
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            // tell the cell representing the next form field to become first responder
            [[self.tableView cellForRowAtIndexPath:indexPath] becomeFirstResponder];
        }
    }
}
- (void)_keyboardNotification:(NSNotification *)note {
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if ([note.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGRect keyboardFrame = [self.tableView convertRect:[self.tableView.window convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromWindow:nil] fromView:nil];
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [UIView setAnimationCurve:curve];
            
            [self.tableView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, CGRectGetHeight(CGRectIntersection(self.tableView.bounds, keyboardFrame)), 0)];
        } completion:^(BOOL finished) {
            [self.tableView flashScrollIndicators];
        }];
    }
    else {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [UIView setAnimationCurve:curve];
            
            [self.tableView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, [self.bottomLayoutGuide length], 0)];
        } completion:^(BOOL finished) {
            [self.tableView flashScrollIndicators];
        }];
    }
}

@end
