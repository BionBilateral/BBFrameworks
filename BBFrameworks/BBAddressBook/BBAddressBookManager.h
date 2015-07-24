//
//  BBAddressBookManager.h
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

#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>

typedef NS_ENUM(NSInteger, BBAddressBookManagerAuthorizationStatus) {
    BBAddressBookManagerAuthorizationStatusNotDetermined = kABAuthorizationStatusNotDetermined,
    BBAddressBookManagerAuthorizationStatusRestricted = kABAuthorizationStatusRestricted,
    BBAddressBookManagerAuthorizationStatusDenied = kABAuthorizationStatusDenied,
    BBAddressBookManagerAuthorizationStatusAuthorized = kABAuthorizationStatusAuthorized
};

@class BBAddressBookPerson,BBAddressBookGroup;

extern NSString *const BBAddressBookManagerNotificationNameExternalChange;

@interface BBAddressBookManager : NSObject

+ (BBAddressBookManagerAuthorizationStatus)authorizationStatus;

- (void)requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion;

- (void)requestPersonWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookPerson *person, NSError *error))completion;

- (void)requestGroupWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookGroup *group, NSError *error))completion;

- (void)requestAllPeopleWithCompletion:(void(^)(NSArray *people, NSError *error))completion;
- (void)requestAllPeopleWithSortDescriptors:(NSArray *)sortDescriptors completion:(void(^)(NSArray *people, NSError *error))completion;

- (void)requestAllGroupsWithCompletion:(void(^)(NSArray *groups, NSError *error))completion;
- (void)requestAllGroupsWithSortDescriptors:(NSArray *)sortDescriptors completion:(void(^)(NSArray *groups, NSError *error))completion;

@end
