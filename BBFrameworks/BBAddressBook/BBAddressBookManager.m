//
//  BBAddressBookManager.m
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

#import "BBAddressBookManager.h"
#import "BBAddressBookPerson.h"
#import "BBFoundation.h"
#import "BBBlocks.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AddressBook/AddressBook.h>

NSString *const BBAddressBookManagerNotificationNameExternalChange = @"BBAddressBookManagerNotificationNameExternalChange";

@interface BBAddressBookManager ()
@property (assign,nonatomic) ABAddressBookRef addressBook;

- (void)_addressBookChanged;
@end

static void kAddressBookManagerCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    [(__bridge BBAddressBookManager *)context _addressBookChanged];
}

@implementation BBAddressBookManager

- (void)dealloc {
    if (_addressBook) {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        
        CFRelease(_addressBook);
    }
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAddressBook:ABAddressBookCreateWithOptions(NULL, NULL)];
    
    if (self.addressBook) {
        ABAddressBookRegisterExternalChangeCallback(self.addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
    }
    
    return self;
}

- (void)requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion; {
    NSParameterAssert(completion);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        completion(YES,nil);
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        BBDispatchMainSyncSafe(^{
            if (granted) {
                completion(YES,nil);
            }
            else {
                completion(NO,(__bridge NSError *)error);
            }
        });
    });
}

- (void)requestAllPeopleWithCompletion:(void(^)(NSArray *people))completion; {
    @weakify(self);
    [self requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                @strongify(self);
                NSArray *peopleRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
                NSArray *people = [[peopleRefs BB_map:^id(id obj, NSInteger idx) {
                    return [[BBAddressBookPerson alloc] initWithPerson:(__bridge ABRecordRef)obj];
                }] BB_filter:^BOOL(BBAddressBookPerson *obj, NSInteger idx) {
                    return obj.fullName.length > 0;
                }];
                
                BBDispatchMainSyncSafe(^{
                    completion(people);
                });
            });
        }
        else {
            BBDispatchMainSyncSafe(^{
                completion(nil);
            });
        }
    }];
}

- (void)_addressBookChanged; {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBAddressBookManagerNotificationNameExternalChange object:self];
}

@end
