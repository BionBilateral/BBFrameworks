//
//  AddressBookTableViewController.m
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

#import "AddressBookViewController.h"

#import <BBFrameworks/BBAddressBook.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AddressBookUI/AddressBookUI.h>

@interface AddressBookViewController () <ABPeoplePickerNavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *systemAddressBookButton;
@property (weak,nonatomic) IBOutlet UIButton *addressBookButton;
@end

@implementation AddressBookViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.systemAddressBookButton addTarget:self action:@selector(_systemAddressBookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addressBookButton addTarget:self action:@selector(_addressBookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

+ (NSString *)rowClassTitle {
    return @"Address Book";
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    
}

- (IBAction)_systemAddressBookButtonAction:(id)sender {
    ABPeoplePickerNavigationController *viewController = [[ABPeoplePickerNavigationController alloc] init];
    
    [viewController setPeoplePickerDelegate:self];
    [viewController setDisplayedProperties:@[@(kABPersonPrefixProperty),
                                             @(kABPersonFirstNameProperty),
                                             @(kABPersonMiddleNameProperty),
                                             @(kABPersonLastNameProperty),
                                             @(kABPersonSuffixProperty),
                                             @(kABPersonOrganizationProperty)]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)_addressBookButtonAction:(id)sender {
    BBAddressBookTableViewController *viewController = [[BBAddressBookTableViewController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
}

@end
