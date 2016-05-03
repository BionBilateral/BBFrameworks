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
@property (assign,nonatomic) ABRecordRef person;
@end

@implementation BBAddressBookPerson

- (instancetype)initWithPerson:(ABRecordRef)person {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(person);
    
    [self setPerson:person];
    
    return self;
}

- (ABRecordID)recordID {
    return ABRecordGetRecordID(self.person);
}

- (UIImage *)image {
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(self.person, kABPersonImageFormatOriginalSize);
    
    return [UIImage imageWithData:data];
}
- (UIImage *)thumbnailImage {
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(self.person, kABPersonImageFormatThumbnail);
    
    return [UIImage imageWithData:data];
}

- (NSString *)prefix {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonPrefixProperty);
}
- (NSString *)firstName {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonFirstNameProperty);
}
- (NSString *)middleName {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonMiddleNameProperty);
}
- (NSString *)lastName {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonLastNameProperty);
}
- (NSString *)suffix {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonSuffixProperty);
}
- (NSString *)fullName {
    return (__bridge_transfer NSString *)ABRecordCopyCompositeName(self.person);
}
- (NSString *)nickname {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonNicknameProperty);
}
- (NSString *)organization {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonOrganizationProperty);
}
- (NSString *)jobTitle {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonJobTitleProperty);
}
- (NSString *)department {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonDepartmentProperty);
}
- (NSArray *)emails {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonEmailProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSDate *)birthday {
    return (__bridge_transfer NSDate *)ABRecordCopyValue(self.person, kABPersonBirthdayProperty);
}
- (NSString *)note {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.person, kABPersonNoteProperty);
}
- (NSDate *)creationDate {
    return (__bridge_transfer NSDate *)ABRecordCopyValue(self.person, kABPersonCreationDateProperty);
}
- (NSDate *)modificationDate {
    return (__bridge_transfer NSDate *)ABRecordCopyValue(self.person, kABPersonModificationDateProperty);
}
- (NSArray *)addresses {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonAddressProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray *)dates {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonDateProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSNumber *)kind {
    return (__bridge_transfer NSNumber *)ABRecordCopyValue(self.person, kABPersonKindProperty);
}
- (NSArray *)phoneNumbers {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonPhoneProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray<NSString *> *)phoneNumbersUnformatted {
    return [self.phoneNumbers BB_map:^id _Nullable(NSString * _Nonnull object, NSInteger index) {
        return [[object componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    }];
}
- (NSArray *)instantMessages {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonInstantMessageProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray *)URLStrings {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonURLProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray *)relatedNames {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonRelatedNamesProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray *)socialProfiles {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonSocialProfileProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}
- (NSArray *)alternateBirthdays {
    ABMultiValueRef valueRef = ABRecordCopyValue(self.person, kABPersonAlternateBirthdayProperty);
    NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
    
    CFRelease(valueRef);
    
    return retval;
}

@end
