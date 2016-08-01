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
#import "BBFoundationDebugging.h"

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

NSString *const BBAddressBookManagerNotificationNameExternalChange = @"BBAddressBookManagerNotificationNameExternalChange";

@interface BBAddressBookManager ()
@property (assign,nonatomic) ABAddressBookRef addressBook;
@property (assign,nonatomic) ABPersonSortOrdering currentPersonSortOrdering;
@property (strong,nonatomic) dispatch_queue_t addressBookQueue;
@property (strong,nonatomic) dispatch_queue_t addressBookSyncQueue;
@property (strong,nonatomic) dispatch_semaphore_t addressBookSyncSemaphore;
@property (assign,nonatomic) BOOL addressBookNeedsSync;
@property (copy,nonatomic) NSArray<BBAddressBookPerson *> *addressBookPeople;
@property (copy,nonatomic) NSArray<BBAddressBookGroup *> *addressBookGroups;

- (void)_createAddressBookIfNecessary;
- (void)_requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion;
- (void)_requestAuthorizationAndReturnAddressBookWithCompletion:(void(^)(ABAddressBookRef addressBookRef, NSError *error))completion;
- (void)_addressBookChanged;
- (void)_syncAddressBookPeopleAndGroups;
@end

static void kAddressBookManagerCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    [(__bridge BBAddressBookManager *)context _addressBookChanged];
}

@implementation BBAddressBookManager
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_addressBook != NULL) {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        
        CFRelease(_addressBook);
    }
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _currentPersonSortOrdering = ABPersonGetSortOrdering();
    
    _addressBookQueue = dispatch_queue_create([NSString stringWithFormat:@"%@.%p.addressBookQueue",NSStringFromClass(self.class),self].UTF8String, DISPATCH_QUEUE_CONCURRENT);
    dispatch_set_target_queue(_addressBookQueue, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0));
    
    _addressBookSyncQueue = dispatch_queue_create([NSString stringWithFormat:@"%@.%p.addressBookSyncQueue",NSStringFromClass(self.class),self].UTF8String, DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_addressBookSyncQueue, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
    
    _addressBookSyncSemaphore = dispatch_semaphore_create(0);
    
    _addressBookNeedsSync = YES;
    
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
    
    if (addressBookRef == NULL) {
        BBDispatchMainAsync(^{
            completion(NO,(__bridge NSError *)errorRef);
        });
    }
    else {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            CFRelease(addressBookRef);
            
            BBDispatchMainAsync(^{
                if (granted) {
                    completion(YES,nil);
                }
                else {
                    completion(NO,(__bridge NSError *)error);
                }
            });
        });
    }
}

- (nullable BBAddressBookPerson *)fetchPersonWithRecordID:(ABRecordID)recordID; {
    return [self fetchPeopleWithRecordIDs:@[@(recordID)]].firstObject;
}
- (nullable NSArray<BBAddressBookPerson *> *)fetchPeopleWithRecordIDs:(NSArray<NSNumber *> *)recordIDs; {
    if ([self.class authorizationStatus] != BBAddressBookManagerAuthorizationStatusAuthorized) {
        BBLog(@"called %@ with authorization status %@, returning nil",NSStringFromSelector(_cmd),@([self.class authorizationStatus]));
        return nil;
    }
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (addressBookRef == NULL) {
        return nil;
    }
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (NSNumber *recordID in recordIDs) {
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, recordID.intValue);
        
        if (personRef == NULL) {
            continue;
        }
        
        [retval addObject:[[BBAddressBookPerson alloc] initWithPerson:personRef]];
    }
    
    CFRelease(addressBookRef);
    
    return [retval copy];
}
- (void)requestPersonWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookPerson *person, NSError *error))completion; {
    [self requestPeopleWithRecordIDs:@[@(recordID)] completion:^(NSArray *people, NSError *error) {
        completion(people.firstObject,error);
    }];
}
- (void)requestPeopleWithRecordIDs:(NSArray *)recordIDs completion:(void(^)(NSArray<BBAddressBookPerson *> *people, NSError *error))completion; {
    NSParameterAssert(recordIDs);
    NSParameterAssert(completion);
    
    [self _requestAuthorizationAndReturnAddressBookWithCompletion:^(ABAddressBookRef addressBookRef, NSError *error) {
        if (addressBookRef == NULL) {
            BBDispatchMainAsync(^{
                completion(nil,error);
            });
        }
        else {
            dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
            
            dispatch_async(queue, ^{
                NSMutableArray *retval = [[NSMutableArray alloc] init];
                
                for (NSNumber *recordID in recordIDs) {
                    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, recordID.intValue);
                    
                    if (personRef == NULL) {
                        continue;
                    }
                    
                    [retval addObject:[[BBAddressBookPerson alloc] initWithPerson:personRef]];
                }
                
                CFRelease(addressBookRef);
                
                BBDispatchMainAsync(^{
                    completion(retval,nil);
                });
            });
        }
    }];
}

- (nullable BBAddressBookGroup *)fetchGroupWithRecordID:(ABRecordID)recordID; {
    return [self fetchGroupsWithRecordIDs:@[@(recordID)]].firstObject;
}
- (nullable NSArray<BBAddressBookGroup *> *)fetchGroupsWithRecordIDs:(NSArray<NSNumber *> *)recordIDs; {
    if ([self.class authorizationStatus] != BBAddressBookManagerAuthorizationStatusAuthorized) {
        BBLog(@"called %@ with authorization status %@, returning nil",NSStringFromSelector(_cmd),@([self.class authorizationStatus]));
        return nil;
    }
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (addressBookRef == NULL) {
        return nil;
    }
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (NSNumber *recordID in recordIDs) {
        ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, recordID.intValue);
        
        if (groupRef == NULL) {
            continue;
        }
        
        [retval addObject:[[BBAddressBookGroup alloc] initWithGroup:groupRef]];
    }
    
    CFRelease(addressBookRef);
    
    return [retval copy];
}
- (void)requestGroupWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookGroup *group, NSError *error))completion; {
    [self requestGroupsWithRecordIDs:@[@(recordID)] completion:^(NSArray *groups, NSError *error) {
        completion(groups.firstObject,error);
    }];
}
- (void)requestGroupsWithRecordIDs:(NSArray *)recordIDs completion:(void(^)(NSArray<BBAddressBookGroup *> *groups, NSError *error))completion; {
    NSParameterAssert(completion);
    
    [self _requestAuthorizationAndReturnAddressBookWithCompletion:^(ABAddressBookRef addressBookRef, NSError *error) {
        if (addressBookRef == NULL) {
            BBDispatchMainAsync(^{
                completion(nil,error);
            });
        }
        else {
            dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
            
            dispatch_async(queue, ^{
                NSMutableArray *retval = [[NSMutableArray alloc] init];
                
                for (NSNumber *recordID in recordIDs) {
                    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, recordID.intValue);
                    
                    if (groupRef == NULL) {
                        continue;
                    }
                    
                    [retval addObject:[[BBAddressBookGroup alloc] initWithGroup:groupRef]];
                }
                
                CFRelease(addressBookRef);
                
                BBDispatchMainAsync(^{
                    completion(retval,nil);
                });
            });
        }
    }];
}

- (void)requestAllPeopleWithCompletion:(void(^)(NSArray *people, NSError *error))completion; {
    [self requestAllPeopleWithSortDescriptors:nil completion:completion];
}
- (void)requestAllPeopleWithSortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookPerson *> *people, NSError *error))completion; {
    [self requestAllPeopleWithPredicate:nil sortDescriptors:sortDescriptors completion:completion];
}
- (void)requestAllPeopleWithPredicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookPerson *> * _Nullable people, NSError *_Nullable error))completion; {
    NSParameterAssert(completion);
    
    BBWeakify(self);
    [self _requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        BBStrongify(self);
        if (success) {
            [self _syncAddressBookPeopleAndGroups];
            
            dispatch_async(self.addressBookQueue, ^{
                dispatch_semaphore_wait(self.addressBookSyncSemaphore, DISPATCH_TIME_FOREVER);
                
                NSArray<BBAddressBookPerson *> *people = self.addressBookPeople;
                
                if (predicate != nil) {
                    people = [people filteredArrayUsingPredicate:predicate];
                }
                
                if (sortDescriptors.count > 0) {
                    people = [people sortedArrayUsingDescriptors:sortDescriptors];
                }
                
                BBDispatchMainAsync(^{
                    completion(people,nil);
                });
            });
        }
        else {
            BBDispatchMainAsync(^{
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
            [self _syncAddressBookPeopleAndGroups];
            
            dispatch_async(self.addressBookQueue, ^{
                dispatch_semaphore_wait(self.addressBookSyncSemaphore, DISPATCH_TIME_FOREVER);
                
                NSArray<BBAddressBookGroup *> *groups = self.addressBookGroups;
                
                if (sortDescriptors.count > 0) {
                    groups = [groups sortedArrayUsingDescriptors:sortDescriptors];
                }
                
                BBDispatchMainAsync(^{
                    completion(groups,nil);
                });
            });
        }
        else {
            BBDispatchMainAsync(^{
                completion(nil,error);
            });
        }
    }];
}
#pragma mark Properties
- (NSInteger)numberOfPeople {
    if ([self.class authorizationStatus] != BBAddressBookManagerAuthorizationStatusAuthorized) {
        BBLog(@"called %@ with authorization status %@, returning 0",NSStringFromSelector(_cmd),@([self.class authorizationStatus]));
        return 0;
    }
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (addressBookRef == NULL) {
        return 0;
    }
    
    NSInteger retval = ABAddressBookGetPersonCount(addressBookRef);
    
    CFRelease(addressBookRef);
    
    return retval;
}
#pragma mark *** Private Methods ***
- (void)_createAddressBookIfNecessary; {
    if (_addressBook == NULL) {
        [self setAddressBook:ABAddressBookCreateWithOptions(NULL, NULL)];
    }
}
- (void)_requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion; {
    if ([self.class authorizationStatus] == BBAddressBookManagerAuthorizationStatusAuthorized) {
        [self _createAddressBookIfNecessary];
        
        BBDispatchMainAsync(^{
            completion(YES,nil);
        });
        return;
    }
    
    [self _createAddressBookIfNecessary];
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            BBDispatchMainAsync(^{
                completion(YES,nil);
            });
        }
        else {
            BBDispatchMainAsync(^{
                completion(NO,(__bridge NSError *)error);
            });
        }
    });
}
- (void)_requestAuthorizationAndReturnAddressBookWithCompletion:(void(^)(ABAddressBookRef addressBookRef, NSError *error))completion; {
    if ([self.class authorizationStatus] == BBAddressBookManagerAuthorizationStatusAuthorized) {
        CFErrorRef outErrorRef;
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &outErrorRef);
        
        if (addressBookRef == NULL) {
            NSError *outError = (__bridge_transfer NSError *)outErrorRef;
            
            completion(NULL,outError);
        }
        else {
            completion(addressBookRef,nil);
        }
    }
    else {
        CFErrorRef outErrorRef;
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &outErrorRef);
        
        if (addressBookRef == NULL) {
            NSError *outError = (__bridge_transfer NSError *)outErrorRef;
            
            completion(NULL,outError);
        }
        else {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    completion(addressBookRef,nil);
                }
                else {
                    NSError *outError = (__bridge_transfer NSError *)error;
                    
                    completion(NULL,outError);
                }
            });
        }
    }
}
- (void)_addressBookChanged; {
    [self setAddressBook:NULL];
    [self _createAddressBookIfNecessary];
    
    BBWeakify(self);
    BBDispatchMainAsync(^{
        BBStrongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:BBAddressBookManagerNotificationNameExternalChange object:self];
    });
}
- (void)_syncAddressBookPeopleAndGroups; {
    BBWeakify(self);
    dispatch_async(self.addressBookSyncQueue, ^{
        BBStrongify(self);
        if (!self.addressBookNeedsSync) {
            dispatch_semaphore_signal(self.addressBookSyncSemaphore);
            return;
        }
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        NSArray *peopleRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBookRef, NULL, ABPersonGetSortOrdering());
        NSArray *people = [[peopleRefs BB_filter:^BOOL(id  _Nonnull object, NSInteger index) {
            ABRecordRef personRef = (__bridge ABRecordRef)object;
            NSString *fullName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(personRef);
            
            return fullName.length > 0;
        }] BB_map:^id(id obj, NSInteger idx) {
            return [[BBAddressBookPerson alloc] initWithPerson:(__bridge ABRecordRef)obj];
        }];
        
        [self setAddressBookPeople:people];
        
        NSArray *groupRefs = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBookRef);
        NSArray *groups = [[groupRefs BB_filter:^BOOL(id  _Nonnull object, NSInteger index) {
            ABRecordRef groupRef = (__bridge ABRecordRef)object;
            NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(groupRef, kABGroupNameProperty);
            
            return name.length > 0;
        }] BB_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
            return [[BBAddressBookGroup alloc] initWithGroup:(__bridge ABRecordRef)object];
        }];
        
        [self setAddressBookGroups:groups];
        
        CFRelease(addressBookRef);
        
        [self setAddressBookNeedsSync:NO];
        
        dispatch_semaphore_signal(self.addressBookSyncSemaphore);
    });
}
#pragma mark Properties
- (void)setAddressBook:(ABAddressBookRef)addressBook {
    if (_addressBook != NULL) {
        BBWeakify(self);
        BBDispatchMainAsync(^{
            BBStrongify(self);
            ABAddressBookUnregisterExternalChangeCallback(_addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        });
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        CFRelease(_addressBook);
    }
    
    _addressBook = addressBook;
    
    if (_addressBook != NULL) {
        _addressBookNeedsSync = YES;
        
        BBWeakify(self);
        BBDispatchMainAsync(^{
            BBStrongify(self);
            ABAddressBookRegisterExternalChangeCallback(_addressBook, &kAddressBookManagerCallback, (__bridge void *)self);
        });
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}
- (void)setCurrentPersonSortOrdering:(ABPersonSortOrdering)currentPersonSortOrdering {
    ABPersonSortOrdering oldSort = _currentPersonSortOrdering;
    
    _currentPersonSortOrdering = currentPersonSortOrdering;
    
    if (oldSort != _currentPersonSortOrdering) {
        [self _addressBookChanged];
    }
}
#pragma mark Notifications
- (void)_applicationWillResignActive:(NSNotification *)note {
    [self setCurrentPersonSortOrdering:ABPersonGetSortOrdering()];
}
- (void)_applicationDidBecomeActive:(NSNotification *)note {
    [self setCurrentPersonSortOrdering:ABPersonGetSortOrdering()];
    
}

@end
