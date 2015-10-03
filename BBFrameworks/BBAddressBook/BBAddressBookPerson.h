//
//  BBAddressBookPerson.h
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

#import <UIKit/UIImage.h>
#import <AddressBook/ABPerson.h>

NS_ASSUME_NONNULL_BEGIN

/**
 BBAddressBookPerson is an NSObject subclass that wraps a ABRecordRef representing a person.
 */
@interface BBAddressBookPerson : NSObject

/**
 Get the represented person of the receiver.
 */
@property (readonly,assign,nonatomic) ABRecordRef person;

/**
 Get the record id of the managed record ref.
 */
@property (readonly,nonatomic) ABRecordID recordID;

/**
 Get the full size contact image.
 */
@property (readonly,nonatomic,nullable) UIImage *image;
/**
 Get the thumbnail contact image.
 */
@property (readonly,nonatomic,nullable) UIImage *thumbnailImage;

/**
 Get the prefix. Corresponds to kABPersonPrefixProperty.
 */
@property (readonly,nonatomic,nullable) NSString *prefix;
/**
 Get the first name. Corresponds to kABPersonFirstNameProperty.
 */
@property (readonly,nonatomic,nullable) NSString *firstName;
/**
 Get the middle name. Corresponds to kABPersonMiddleNameProperty.
 */
@property (readonly,nonatomic,nullable) NSString *middleName;
/**
 Get the last name. Corresponds to kABPersonLastNameProperty.
 */
@property (readonly,nonatomic,nullable) NSString *lastName;
/**
 Get the suffix. Corresponds to kABPersonSuffixProperty.
 */
@property (readonly,nonatomic,nullable) NSString *suffix;
/**
 Get the full name. This is equivalent to concatenating prefix, firstName, middleName, lastName, and suffix if non-nil.
 */
@property (readonly,nonatomic,nullable) NSString *fullName;
/**
 Get the nickname. This corresponds to kABPersonNicknameProperty.
 */
@property (readonly,nonatomic,nullable) NSString *nickname;
/**
 Get the organization. This corresponds to kABPersonOrganizationProperty.
 */
@property (readonly,nonatomic,nullable) NSString *organization;
/**
 Get the job title. This corresponds to kABPersonJobTitleProperty.
 */
@property (readonly,nonatomic,nullable) NSString *jobTitle;
/**
 Get the department. This corresponds to kABPersonDepartmentProperty.
 */
@property (readonly,nonatomic,nullable) NSString *department;
/**
 Get the emails, which will be an array of NSString objects. This corresponds to kABPersonEmailProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSString *> *emails;
/**
 Get the birthday. This corresponds to kABPersonBirthdayProperty.
 */
@property (readonly,nonatomic) NSDate *birthday;
/**
 Get the note. This corresponds to kABPersonNoteProperty.
 */
@property (readonly,nonatomic,nullable) NSString *note;
/**
 Get the creation date. This corresponds to kABPersonCreationDateProperty.
 */
@property (readonly,nonatomic,nullable) NSDate *creationDate;
/**
 Get the modification date. This corresponds to kABPersonModificationDateProperty.
 */
@property (readonly,nonatomic,nullable) NSDate *modificationDate;
/**
 Get the addresses, which will be an array of NSDictionary objects. This corresponds to kABPersonAddressProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *addresses;
/**
 Get the dates, which will be an array of NSDate objects. This corresponds to kABPersonDateProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSDate *> *dates;
/**
 Get the kind. This corresponds to kABPersonKindProperty.
 */
@property (readonly,nonatomic,nullable) NSNumber *kind;
/**
 Get the phone numbers, which will be an array of NSString objects. This corresponds to kABPersonPhoneProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSString *> *phoneNumbers;
/**
 Get the instant messages, which will be an array of NSDictionary objects. This corresponds to kABPersonInstantMessageProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *instantMessages;
/**
 Get the URL strings, which will be an array of NSString objects. This corresponds to kABPersonURLProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSString *> *URLStrings;
/**
 Get the related names, which will be an array of NSString objects. This corresponds to kABPersonRelatedNamesProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSString *> *relatedNames;
/**
 Get the social profiles, which will be an array of NSDictionary objects. This corresponds to kABPersonSocialProfileProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *socialProfiles;
/**
 Get the alternate birthdays, which will be an array of NSDictionary objects. This corresponds to kABPersonAlternateBirthdayProperty.
 */
@property (readonly,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *alternateBirthdays;

/**
 Designated initializer.
 
 @param The person record to manage
 @return An initialized instance of the receiver
 */
- (instancetype)initWithPerson:(ABRecordRef)person NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable("use initWithPerson: instead")));

@end

NS_ASSUME_NONNULL_END
