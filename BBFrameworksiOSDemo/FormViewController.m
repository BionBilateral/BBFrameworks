//
//  TextFieldViewController.m
//  BBFrameworks
//
//  Created by William Towe on 7/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "FormViewController.h"
#import "DetailViewController.h"
#import "BBFoundation.h"

#import <BBFrameworks/BBKit.h>
#import <BBFrameworks/BBForm.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FormViewController () <BBFormTableViewControllerDataSource>
@property (strong,nonatomic) BBFormTableViewController *tableViewController;
@property (copy,nonatomic) NSArray *formFieldDictionaries;

@property (copy,nonatomic) NSString *firstName;
@property (copy,nonatomic) NSString *lastName;
@property (assign,nonatomic) BOOL doIt;
@property (assign,nonatomic) BOOL checkmark;
@property (copy,nonatomic) NSString *pickerSelection;
@property (copy,nonatomic) NSDate *datePickerSelection;
@property (copy,nonatomic) NSString *didUpdateText;
@end

@implementation FormViewController

+ (void)initialize {
    if (self == [FormViewController class]) {
        
    }
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setLastName:@"Smith"];
    [self setPickerSelection:@"Second"];
    [self setDatePickerSelection:[NSDate date]];
    
    @weakify(self);
    [self setFormFieldDictionaries:@[@{BBFormFieldKeyTitleHeader: @"Header Title",
                                       BBFormFieldKeyTitleFooter : @"This is multiline footer title text that should wrap to multiple lines if things work properly.",
                                       BBFormFieldKeyTitle: @"First Name",
                                       BBFormFieldKeyKey: @"firstName",
                                       BBFormFieldKeyPlaceholder: @"Type your first name…",
                                       BBFormFieldKeyKeyboardType: @(UIKeyboardTypeASCIICapable)},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeLabel),
                                       BBFormFieldKeyTitle: @"Label",
                                       BBFormFieldKeySubtitle: @"Label subtitle",
                                       BBFormFieldKeyImage: ({
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
        
        [[UIColor lightGrayColor] setFill];
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 22, 22) cornerRadius:3.0] fill];
        
        UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        retval;
    }),
                                       BBFormFieldKeyKey: @"lastName"},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeBooleanSwitch),
                                       BBFormFieldKeyTitle: @"Boolean Switch",
                                       BBFormFieldKeyKey: @"doIt"},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeBooleanCheckmark),
                                       BBFormFieldKeyTitle: @"Boolean Checkmark",
                                       BBFormFieldKeyKey: @"checkmark"},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypePicker),
                                       BBFormFieldKeyTitle: @"Picker",
                                       BBFormFieldKeyKey: @"pickerSelection",
                                       BBFormFieldKeyPickerRows: @[@"First",
                                                                   @"Second",
                                                                   @"Third"]},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeDatePicker),
                                       BBFormFieldKeyTitle: @"Date Picker",
                                       BBFormFieldKeyKey: @"datePickerSelection",
                                       BBFormFieldKeyDatePickerMode: @(UIDatePickerModeDate),
                                       BBFormFieldKeyDateFormatter: ({
        NSDateFormatter *retval = [[NSDateFormatter alloc] init];
        
        [retval setDateStyle:NSDateFormatterLongStyle];
        [retval setTimeStyle:NSDateFormatterNoStyle];
        
        retval;
    })},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeLabel),
                                       BBFormFieldKeyTitle: @"View Controller",
                                       BBFormFieldKeyTableViewCellAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
                                       BBFormFieldKeyViewControllerClass: [DetailViewController class]},
                                     @{BBFormFieldKeyType: @(BBFormFieldTypeLabel),
                                       BBFormFieldKeyTitle: @"Did Select",
                                       BBFormFieldKeyDidSelectBlock: ^(BBFormField *formField, NSIndexPath *indexPath){
        @strongify(self);
        
        BBLog(@"%@ %@",formField,indexPath);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title" message:@"Alert message that is informative" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }},
                                     @{BBFormFieldKeyTitle: @"Did Update",
                                       BBFormFieldKeyPlaceholder: @"Type something…",
                                       BBFormFieldKeyKey: @"didUpdateText",
                                       BBFormFieldKeyDidUpdateBlock: ^(BBFormField *formField){
        BBLogObject(formField.value);
    }}]];
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTableViewController:[[BBFormTableViewController alloc] init]];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    [self.tableViewController setDataSource:self];
}
- (void)viewDidLayoutSubviews {
    [self.tableViewController.view setFrame:self.view.bounds];
}

+ (NSString *)rowClassTitle {
    return @"Forms";
}

@end
