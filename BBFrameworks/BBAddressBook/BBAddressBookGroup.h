//
//  BBAddressBookGroup.h
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
#import <AddressBook/ABGroup.h>

NS_ASSUME_NONNULL_BEGIN

/**
 BBAddressBookGroup is an NSObject subclass that wraps a ABRecordRef representing a group.
 */
@interface BBAddressBookGroup : NSObject

/**
 Get the represented group of the receiver.
 */
@property (readonly,assign,nonatomic) ABRecordRef group;

/**
 Get the record id of the managed record ref.
 */
@property (readonly,nonatomic) ABRecordID recordID;

/**
 Get the name. This corresponds to kABGroupNameProperty.
 */
@property (readonly,nonatomic,nullable) NSString *name;
/**
 Get all the people in the group. Calls `[self sortedPeopleWithSortDescriptors:nil]`.
 */
@property (readonly,nonatomic,nullable) NSArray *people;

/**
 Designated initializer.
 
 @param group The group record to manage
 @return An initialized instance of the receiver
 */
- (instancetype)initWithGroup:(ABRecordRef)group NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable("use initWithGroup: instead")));

/**
 Returns an array of all people in the receiver as BBAddressBookPerson objects, sorted using sortDescriptors.
 
 @param sortDescriptors The sort descriptors to sort by, see BBAddressBookPerson.h for supported keys
 @return The sorted array of people in the group
 */
- (nullable NSArray *)sortedPeopleWithSortDescriptors:(nullable NSArray *)sortDescriptors;

@end

NS_ASSUME_NONNULL_END
