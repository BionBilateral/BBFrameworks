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

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the authorization status of the AddressBook framework.
 */
typedef NS_ENUM(NSInteger, BBAddressBookManagerAuthorizationStatus) {
    /**
     The status has not been determined for the calling application. The appropriate alert will be shown to grant access upon request.
     */
    BBAddressBookManagerAuthorizationStatusNotDetermined = kABAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and the current user may not be able to modify it.
     */
    BBAddressBookManagerAuthorizationStatusRestricted = kABAuthorizationStatusRestricted,
    /**
     The user has denied access to the calling application. Prompt the user to adjust access in the Settings application.
     */
    BBAddressBookManagerAuthorizationStatusDenied = kABAuthorizationStatusDenied,
    /**
     The user has granted access to the calling application.
     */
    BBAddressBookManagerAuthorizationStatusAuthorized = kABAuthorizationStatusAuthorized
};

@class BBAddressBookPerson,BBAddressBookGroup;

/**
 Notification is posted when the contents of the address book change. Clients should discard all model objects and request them again. The notification is always posted on the main thread.
 */
extern NSString *const BBAddressBookManagerNotificationNameExternalChange;

/**
 BBAddressBookManager is a NSObject subclass that manages a ABAddressBookRef object and provides the groups and people objects it contains. People and groups are represented by BBAddressBookPerson and BBAddressBookGroup.
 */
@interface BBAddressBookManager : NSObject

/**
 Get the number of people in the address book. If the user has not granted access, returns 0.
 */
@property (readonly,nonatomic) NSInteger numberOfPeople;

/**
 Returns the current authorization status.
 
 @see BBAddressBookManagerAuthorizationStatus
 */
+ (BBAddressBookManagerAuthorizationStatus)authorizationStatus;

/**
 Requests authorization to access the user's contacts and invokes the completion block with YES or NO, and an error if NO.
 
 @param completion The completion block that is invoked once authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
+ (void)requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Calls `[self fetchPeopleWithRecordIDs:]`, passing @[@(recordID)] respectively.
 
 @param recordID The record id of the person
 @return The BBAddressBookPerson object or nil
 */
- (nullable BBAddressBookPerson *)fetchPersonWithRecordID:(ABRecordID)recordID;
/**
 Returns an array of BBAddressBookPerson objects for the provided recordIDs. If the user has not authorized the client returns nil.
 
 @param recordIDs The array of record ids to fetch people for
 @return The array of BBAddressBookPerson objects or nil
 */
- (nullable NSArray<BBAddressBookPerson *> *)fetchPeopleWithRecordIDs:(NSArray<NSNumber *> *)recordIDs;
/**
 Calls `[self requestPeopleWithRecordIDs:completion:]`, passing @[@(recordID)] and completion respectively.
 
 @param recordID The record id of the person
 @param completion The completion block to invoke once the request is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestPersonWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookPerson * _Nullable person, NSError *_Nullable error))completion;
/**
 Attempts to fetch BBAddressBookPerson objects for the provided record ids and invokes the completion block when the operation is complete.
 
 @param recordIDs The array of record ids to fetch people for
 @param completion The completion block to invoke once the request is complete
 @exception NSException Thrown if recordIDs or completion are nil
 */
- (void)requestPeopleWithRecordIDs:(NSArray<NSNumber *> *)recordIDs completion:(void(^)(NSArray<BBAddressBookPerson *> * _Nullable people, NSError *_Nullable error))completion;

/**
 Calls `[self fetchGroupsWithRecordIDs:]`, passing @[@(recordID)] respectively.
 
 @param recordID The record id of the group to fetch
 @return The BBAddressBookGroup object or nil
 */
- (nullable BBAddressBookGroup *)fetchGroupWithRecordID:(ABRecordID)recordID;
/**
 Returns an array of BBAddressBookGroup objects for the provided recordIDs. If the user has not authorized the client returns nil.
 
 @param recordIDs The array of record ids to fetch groups for
 @return The array of BBAddressBookGroup objects or nil
 */
- (nullable NSArray<BBAddressBookGroup *> *)fetchGroupsWithRecordIDs:(NSArray<NSNumber *> *)recordIDs;
/**
 Calls `[self requestGroupsWithRecordIDs:completion:]`, passing @[@(recordID)] and completion respectively.
 
 @param recordID The record id of the group
 @param completion The completion block to invoke once the request is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestGroupWithRecordID:(ABRecordID)recordID completion:(void(^)(BBAddressBookGroup * _Nullable group, NSError *_Nullable error))completion;
/**
 Attempts to fetch BBAddressBookGroup objects for the provided record ids and invokes the completion block when the operation is complete.
 
 @param recordIDs The array of record ids to fetch groups for
 @param completion The completion block to invoke once the request is complete
 @exception NSException Thrown if recordIDs or completion are nil
 */
- (void)requestGroupsWithRecordIDs:(NSArray<NSNumber *> *)recordIDs completion:(void(^)(NSArray<BBAddressBookGroup *> * _Nullable groups, NSError *_Nullable error))completion;

/**
 Calls `[self requestAllPeopleWithSortDescriptors:completion:]`, passing nil and completion respectively.
 
 @param completion The completion block that is invoked when the request is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestAllPeopleWithCompletion:(void(^)(NSArray * _Nullable people, NSError *_Nullable error))completion;
/**
 Calls `[self requestAllPeopleWithPredicate:sortDescriptors:completion:]`, passing nil, sortDescriptors, and completion respectively.
 
 @param sortDescriptors The array of sort descriptors to sort the return BBAddressBookPerson objects by
 @param completion The completion block to invoke when the operation is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestAllPeopleWithSortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookPerson *> * _Nullable people, NSError *_Nullable error))completion;
/**
 Requests all people in the address book sorted with the provided sort descriptors and invokes the completion block when the request is complete. The array of people in the completion block will contain BBAddressBookPerson instances. See BBAddressBookPerson.h for supported keys for sorting.
 
 @param predicate The predicate to filter the resulting array of people with invoking completion
 @param sortDescriptors The array of sort descriptors to sort the return BBAddressBookPerson objects by
 @param completion The completion block to invoke when the operation is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestAllPeopleWithPredicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookPerson *> * _Nullable people, NSError *_Nullable error))completion;

/**
 Calls `[self requestAllGroupsWithSortDescriptors:completion:]`, passing nil and completion respectively.
 
 @param completion The completion block that is invoked when the request is complete
 @exception NSException Throw if completion is nil
 */
- (void)requestAllGroupsWithCompletion:(void(^)(NSArray<BBAddressBookGroup *> * _Nullable groups, NSError *_Nullable error))completion;
/**
 Requests all groups in the address book sorted with the provided sort descriptors and invokes the completion block when the request is complete. The array of groups in the completion block will contain BBAddressBookGroup instances. See BBAddressBookGroup.h for supported keys for sorting.
 
 @param sortDescriptors The array of sort descriptors to sort the return BBAddressBookGroup objects by
 @param completion The completion block to invoke when the operation is complete
 @exception NSException Thrown if completion is nil
 */
- (void)requestAllGroupsWithSortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<BBAddressBookGroup *> * _Nullable groups, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
