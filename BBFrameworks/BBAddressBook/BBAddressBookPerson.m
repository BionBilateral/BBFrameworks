//
//  BBAddressBookPerson.m
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

#import "BBAddressBookPerson.h"
#import "NSArray+BBBlocksExtensions.h"

#import <AddressBook/AddressBook.h>

@interface BBAddressBookPerson ()
@property (readwrite,assign,nonatomic) ABRecordID recordID;
@property (readwrite,strong,nonatomic,nullable) UIImage *image;
@property (readwrite,strong,nonatomic,nullable) UIImage *thumbnailImage;
@property (readwrite,copy,nonatomic,nullable) NSString *prefix;
@property (readwrite,copy,nonatomic,nullable) NSString *firstName;
@property (readwrite,copy,nonatomic,nullable) NSString *middleName;
@property (readwrite,copy,nonatomic,nullable) NSString *lastName;
@property (readwrite,copy,nonatomic,nullable) NSString *suffix;
@property (readwrite,copy,nonatomic,nullable) NSString *fullName;
@property (readwrite,copy,nonatomic,nullable) NSString *nickname;
@property (readwrite,copy,nonatomic,nullable) NSString *organization;
@property (readwrite,copy,nonatomic,nullable) NSString *jobTitle;
@property (readwrite,copy,nonatomic,nullable) NSString *department;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSString *> *emails;
@property (readwrite,copy,nonatomic) NSDate *birthday;
@property (readwrite,copy,nonatomic,nullable) NSString *note;
@property (readwrite,copy,nonatomic,nullable) NSDate *creationDate;
@property (readwrite,copy,nonatomic,nullable) NSDate *modificationDate;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *addresses;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSDate *> *dates;
@property (readwrite,copy,nonatomic,nullable) NSNumber *kind;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSString *> *phoneNumbers;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *instantMessages;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSString *> *URLStrings;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSString *> *relatedNames;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *socialProfiles;
@property (readwrite,copy,nonatomic,nullable) NSArray<NSDictionary<NSString *, id> *> *alternateBirthdays;
@end

@implementation BBAddressBookPerson

- (instancetype)initWithPerson:(ABRecordRef)personRef {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(personRef);
    
    _recordID = ABRecordGetRecordID(personRef);
    _image = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatOriginalSize)];
    _thumbnailImage = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatThumbnail)];
    _prefix = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonPrefixProperty);
    _firstName = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
    _middleName = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonMiddleNameProperty);
    _lastName = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonLastNameProperty);
    _suffix = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonSuffixProperty);
    _fullName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(personRef);
    _nickname = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonNicknameProperty);
    _organization = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonOrganizationProperty);
    _department = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonDepartmentProperty);
    _jobTitle = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonJobTitleProperty);
    _emails = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonEmailProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _birthday = (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonBirthdayProperty);
    _note = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonNoteProperty);
    _creationDate = (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonCreationDateProperty);
    _modificationDate = (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonModificationDateProperty);
    _addresses = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonAddressProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _dates = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonDateProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _kind = (__bridge_transfer NSNumber *)ABRecordCopyValue(personRef, kABPersonKindProperty);
    _phoneNumbers = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _instantMessages = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonInstantMessageProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _URLStrings = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonURLProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _relatedNames = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonRelatedNamesProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _socialProfiles = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonSocialProfileProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    _alternateBirthdays = ({
        ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonAlternateBirthdayProperty);
        NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
        
        if (valueRef != NULL) {
            CFRelease(valueRef);
        }
        
        retval;
    });
    
    return self;
}

@end
