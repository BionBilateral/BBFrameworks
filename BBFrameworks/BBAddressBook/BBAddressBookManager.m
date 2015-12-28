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
#import "BBFoundationFunctions.h"
#import "BBBlocks.h"
#import "BBFrameworksMacros.h"
#import "BBAddressBookGroup.h"

#import <AddressBook/AddressBook.h>

NSString *const BBAddressBookManagerNotificationNameExternalChange = @"BBAddressBookManagerNotificationNameExternalChange";

@interface BBAddressBookManager ()
@property (assign,nonatomic) ABAddressBookRef addressBook;
@property (strong,nonatomic) dispatch_queue_t addressBookQueue;

- (void)_createAddressBookIfNecessary;
- (void)_requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion;
- (void)_addressBookChanged;
@end

static void kAddressBookManagerCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    [(__bridge BBAddressBookManager *)context _addressBookChanged];
}

@implementation BBAddressBookManager
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    if (_addressBook) {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        
        CFRelease(_addressBook);
    }
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAddressBookQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.%p",NSStringFromClass(self.class),self].UTF8String, DISPATCH_QUEUE_SERIAL)];
    
    return self;
}
#pragma mark *** Public Methods ***
+ (BBAddressBookManagerAuthorizationStatus)authorizationStatus; {
    return (BBAddressBookManagerAuthorizationStatus)ABAddressBookGetAuthorizationStatus();
}

+ (void)requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion; {
    NSParameterAssert(completion);
    
    if ([self authorizationStatus] == BBAddressBookManagerAuthorizationStatusAuthorized) {
        completion(YES,nil);
        return;
    }
    
    CFErrorRef errorRef;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
    
    if (addressBookRef) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            CFRelease(addressBookRef);
            
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
    else {
        BBDispatchMainSyncSafe(^{
            completion(NO,(__bridge NSError *)errorRef);
        });
    }
}

- (void)requestPersonWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookPerson *person, NSError *error))completion; {
    [self requestPeopleWithRecordIDs:@[@(recordID)] completion:^(NSArray *people, NSError *error) {
        completion(people.firstObject,error);
    }];
}
- (void)requestPeopleWithRecordIDs:(NSArray *)recordIDs completion:(void(^)(NSArray<BBAddressBookPerson *> *people, NSError *error))completion; {
    NSParameterAssert(recordIDs);
    NSParameterAssert(completion);
    
    BBWeakify(self);
    [self _requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        BBStrongify(self);
        if (success) {
            dispatch_async(self.addressBookQueue, ^{
                BBStrongify(self);
                NSMutableArray *retval = [[NSMutableArray alloc] init];
                
                for (NSNumber *recordID in recordIDs) {
                    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(self.addressBook, recordID.intValue);
                    
                    if (personRef) {
                        [retval addObject:[[BBAddressBookPerson alloc] initWithPerson:personRef]];
                    }
                }
                
                BBDispatchMainSyncSafe(^{
                    completion([retval copy],nil);
                });
            });
        }
        else {
            BBDispatchMainSyncSafe(^{
                completion(nil,error);
            });
        }
    }];
}

- (void)requestGroupWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookGroup *group, NSError *error))completion; {
    [self requestGroupsWithRecordIDs:@[@(recordID)] completion:^(NSArray *groups, NSError *error) {
        completion(groups.firstObject,error);
    }];
}
- (void)requestGroupsWithRecordIDs:(NSArray *)recordIDs completion:(void(^)(NSArray<BBAddressBookGroup *> *groups, NSError *error))completion; {
    NSParameterAssert(completion);
    
    BBWeakify(self);
    [self _requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        BBStrongify(self);
        if (success) {
            dispatch_async(self.addressBookQueue, ^{
                BBStrongify(self);
                NSMutableArray *retval = [[NSMutableArray alloc] init];
                
                for (NSNumber *recordID in recordIDs) {
                    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(self.addressBook, recordID.intValue);
                    
                    if (groupRef) {
                        [retval addObject:[[BBAddressBookGroup alloc] initWithGroup:groupRef]];
                    }
                }
                
                BBDispatchMainSyncSafe(^{
                    completion([retval copy],nil);
                });
            });
        }
        else {
            BBDispatchMainSyncSafe(^{
                completion(nil,error);
            });
        }
    }];
}

- (void)requestAllPeopleWithCompletion:(void(^)(NSArray *people, NSError *error))completion; {
    [self requestAllPeopleWithSortDescriptors:nil completion:completion];
}
- (void)requestAllPeopleWithSortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookPerson *> *people, NSError *error))completion; {
    NSParameterAssert(completion);
    
    BBWeakify(self);
    [self _requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        BBStrongify(self);
        if (success) {
            dispatch_async(self.addressBookQueue, ^{
                BBStrongify(self);
                NSArray *peopleRefs;
                
                if (sortDescriptors.count > 0) {
                    peopleRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
                }
                else {
                    ABRecordRef sourceRef = ABAddressBookCopyDefaultSource(self.addressBook);
                    
                    peopleRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, sourceRef, ABPersonGetSortOrdering());
                    
                    CFRelease(sourceRef);
                }
                
                NSArray *people = [[peopleRefs BB_map:^id(id obj, NSInteger idx) {
                    return [[BBAddressBookPerson alloc] initWithPerson:(__bridge ABRecordRef)obj];
                }] BB_filter:^BOOL(BBAddressBookPerson *obj, NSInteger idx) {
                    return obj.fullName.length > 0;
                }];
                
                if (sortDescriptors.count > 0) {
                    people = [people sortedArrayUsingDescriptors:sortDescriptors];
                }
                
                BBDispatchMainSyncSafe(^{
                    completion(people,nil);
                });
            });
        }
        else {
            BBDispatchMainSyncSafe(^{
                completion(nil,error);
            });
        }
    }];
}

- (void)requestAllGroupsWithCompletion:(void(^)(NSArray<BBAddressBookGroup *> *groups, NSError *error))completion; {
    [self requestAllGroupsWithSortDescriptors:nil completion:completion];
}
- (void)requestAllGroupsWithSortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookGroup *> *groups, NSError *error))completion; {
    NSParameterAssert(completion);
    
    BBWeakify(self);
    [self _requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        BBStrongify(self);
        if (success) {
            dispatch_async(self.addressBookQueue, ^{
                BBStrongify(self);
                NSArray *groupRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllGroups(self.addressBook);
                NSArray *groups = [[groupRefs BB_map:^id(id object, NSInteger index) {
                    return [[BBAddressBookGroup alloc] initWithGroup:(__bridge ABRecordRef)object];
                }] BB_filter:^BOOL(BBAddressBookGroup *object, NSInteger index) {
                    return object.name.length > 0;
                }];
                
                if (sortDescriptors.count > 0) {
                    groups = [groups sortedArrayUsingDescriptors:sortDescriptors];
                }
                
                BBDispatchMainSyncSafe(^{
                    completion(groups,nil);
                });
            });
        }
        else {
            BBDispatchMainSyncSafe(^{
                completion(nil,error);
            });
        }
    }];
}
#pragma mark *** Private Methods ***
- (void)_createAddressBookIfNecessary; {
    if (!self.addressBook) {
        [self setAddressBook:ABAddressBookCreateWithOptions(NULL, NULL)];
        
        if (self.addressBook) {
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        }
    }
}
- (void)_requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion; {
    NSParameterAssert(completion);
    
    if ([self.class authorizationStatus] == BBAddressBookManagerAuthorizationStatusAuthorized) {
        completion(YES,nil);
        return;
    }
    
    BBWeakify(self);
    dispatch_async(self.addressBookQueue, ^{
        BBStrongify(self);
        [self _createAddressBookIfNecessary];
        
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
    });
}
- (void)_addressBookChanged; {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBAddressBookManagerNotificationNameExternalChange object:self];
}

@end
