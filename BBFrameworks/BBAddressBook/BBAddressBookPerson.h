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
 Get the record id of the managed record ref.
 */
@property (readonly,assign,nonatomic) ABRecordID recordID;

/**
 Get the full size contact image.
 */
@property (readonly,strong,nonatomic,nullable) UIImage *image;
/**
 Get the thumbnail contact image.
 */
@property (readonly,strong,nonatomic,nullable) UIImage *thumbnailImage;

/**
 Get the prefix. Corresponds to kABPersonPrefixProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *prefix;
/**
 Get the first name. Corresponds to kABPersonFirstNameProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *firstName;
/**
 Get the middle name. Corresponds to kABPersonMiddleNameProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *middleName;
/**
 Get the last name. Corresponds to kABPersonLastNameProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *lastName;
/**
 Get the suffix. Corresponds to kABPersonSuffixProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *suffix;
/**
 Get the full name. This is equivalent to concatenating prefix, firstName, middleName, lastName, and suffix if non-nil.
 */
@property (readonly,copy,nonatomic,nullable) NSString *fullName;
/**
 Get the nickname. This corresponds to kABPersonNicknameProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *nickname;
/**
 Get the organization. This corresponds to kABPersonOrganizationProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *organization;
/**
 Get the job title. This corresponds to kABPersonJobTitleProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *jobTitle;
/**
 Get the department. This corresponds to kABPersonDepartmentProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *department;
/**
 Get the emails, which will be an array of NSString objects. This corresponds to kABPersonEmailProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSString *> *emails;
/**
 Get the birthday. This corresponds to kABPersonBirthdayProperty.
 */
@property (readonly,copy,nonatomic) NSDate *birthday;
/**
 Get the note. This corresponds to kABPersonNoteProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSString *note;
/**
 Get the creation date. This corresponds to kABPersonCreationDateProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSDate *creationDate;
/**
 Get the modification date. This corresponds to kABPersonModificationDateProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSDate *modificationDate;
/**
 Get the addresses, which will be an array of NSDictionary objects. This corresponds to kABPersonAddressProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *addresses;
/**
 Get the dates, which will be an array of NSDate objects. This corresponds to kABPersonDateProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSDate *> *dates;
/**
 Get the kind. This corresponds to kABPersonKindProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSNumber *kind;
/**
 Get the phone numbers, which will be an array of NSString objects. This corresponds to kABPersonPhoneProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSString *> *phoneNumbers;
/**
 Get the phoneNumbers property, stripped of all formatting. For example, (123) 456-7890 would be transformed into 1234567890.
 */
@property (readonly,nonatomic,nullable) NSArray<NSString *> *phoneNumbersUnformatted;
/**
 Get the instant messages, which will be an array of NSDictionary objects. This corresponds to kABPersonInstantMessageProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *instantMessages;
/**
 Get the URL strings, which will be an array of NSString objects. This corresponds to kABPersonURLProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSString *> *URLStrings;
/**
 Get the related names, which will be an array of NSString objects. This corresponds to kABPersonRelatedNamesProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSString *> *relatedNames;
/**
 Get the social profiles, which will be an array of NSDictionary objects. This corresponds to kABPersonSocialProfileProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *socialProfiles;
/**
 Get the alternate birthdays, which will be an array of NSDictionary objects. This corresponds to kABPersonAlternateBirthdayProperty.
 */
@property (readonly,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, NSDateComponents *> *> *alternateBirthdays;

/**
 Designated initializer.
 
 @param The person record to manage
 @return An initialized instance of the receiver
 */
- (instancetype)initWithPerson:(ABRecordRef)person NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable("use initWithPerson: instead")));

@end

NS_ASSUME_NONNULL_END
