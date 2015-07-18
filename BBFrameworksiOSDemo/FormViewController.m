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

#import <BBFrameworks/BBKit.h>
#import <BBFrameworks/BBForm.h>

@interface FormViewController () <BBFormTableViewControllerDataSource>
@property (strong,nonatomic) BBFormTableViewController *tableViewController;
@property (copy,nonatomic) NSArray *formFieldDictionaries;

@property (copy,nonatomic) NSString *firstName;
@property (copy,nonatomic) NSString *middleName;
@property (copy,nonatomic) NSString *lastName;
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
    
    [self setFormFieldDictionaries:@[@{BBFormFieldKeyTitle: @"First Name",
                                       BBFormFieldKeyKey: @"firstName",
                                       BBFormFieldKeyPlaceholder: @"Type your first name…",
                                       BBFormFieldKeyKeyboardType: @(UIKeyboardTypeTwitter)},
                                     @{BBFormFieldKeyTitle: @"Middle Name",
                                       BBFormFieldKeyKey: @"middleName",
                                       BBFormFieldKeyPlaceholder: @"Type your middle name…",
                                       BBFormFieldKeyKeyboardType: @(UIKeyboardTypeEmailAddress)},
                                     @{BBFormFieldKeyTitle: @"Last Name",
                                       BBFormFieldKeyKey: @"lastName",
                                       BBFormFieldKeyPlaceholder: @"Type your last name…",
                                       BBFormFieldKeyKeyboardType: @(UIKeyboardTypeURL)}]];
    
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
