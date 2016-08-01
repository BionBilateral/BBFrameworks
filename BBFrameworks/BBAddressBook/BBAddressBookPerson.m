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

- (id)_executeWithPersonBlock:(id(^)(ABRecordRef personRef))block;
@end

@implementation BBAddressBookPerson

- (instancetype)initWithPerson:(ABRecordRef)person {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(person);
    
    _recordID = ABRecordGetRecordID(person);
    
    return self;
}

- (UIImage *)image {
    if (_image == nil) {
        _image = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatOriginalSize)];
        }];
    }
    return _image;
}
- (UIImage *)thumbnailImage {
    if (_thumbnailImage == nil) {
        _thumbnailImage = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatThumbnail)];
        }];
    }
    return _thumbnailImage;
}
- (NSString *)prefix {
    if (_prefix == nil) {
        _prefix = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonPrefixProperty);
        }];
    }
    return _prefix;
}
- (NSString *)firstName {
    if (_firstName == nil) {
        _firstName = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
        }];
    }
    return _firstName;
}
- (NSString *)middleName {
    if (_middleName == nil) {
        _middleName = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonMiddleNameProperty);
        }];
    }
    return _middleName;
}
- (NSString *)lastName {
    if (_lastName == nil) {
        _lastName = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonLastNameProperty);
        }];
    }
    return _lastName;
}
- (NSString *)suffix {
    if (_suffix == nil) {
        _suffix = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonSuffixProperty);
        }];
    }
    return _suffix;
}
- (NSString *)fullName {
    if (_fullName == nil) {
        _fullName = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyCompositeName(personRef);
        }];
    }
    return _fullName;
}
- (NSString *)nickname {
    if (_nickname == nil) {
        _nickname = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonNicknameProperty);
        }];
    }
    return _nickname;
}
- (NSString *)organization {
    if (_organization == nil) {
        _organization = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonOrganizationProperty);
        }];
    }
    return _organization;
}
- (NSString *)department {
    if (_department == nil) {
        _department = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonDepartmentProperty);
        }];
    }
    return _department;
}
- (NSString *)jobTitle {
    if (_jobTitle == nil) {
        _jobTitle = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonJobTitleProperty);
        }];
    }
    return _jobTitle;
}
- (NSArray<NSString *> *)emails {
    if (_emails == nil) {
        _emails = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonEmailProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _emails;
}
- (NSDate *)birthday {
    if (_birthday == nil) {
        _birthday = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonBirthdayProperty);
        }];
    }
    return _birthday;
}
- (NSString *)note {
    if (_note == nil) {
        _note = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonNoteProperty);
        }];
    }
    return _note;
}
- (NSDate *)creationDate {
    if (_creationDate == nil) {
        _creationDate = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonCreationDateProperty);
        }];
    }
    return _creationDate;
}
- (NSDate *)modificationDate {
    if (_modificationDate == nil) {
        _modificationDate = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSDate *)ABRecordCopyValue(personRef, kABPersonModificationDateProperty);
        }];
    }
    return _modificationDate;
}
- (NSArray<NSDictionary<NSString *,id> *> *)addresses {
    if (_addresses == nil) {
        _addresses = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonAddressProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _addresses;
}
- (NSArray<NSDate *> *)dates {
    if (_dates == nil) {
        _dates = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonDateProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _dates;
}
- (NSNumber *)kind {
    if (_kind == nil) {
        _kind = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return (__bridge_transfer NSNumber *)ABRecordCopyValue(personRef, kABPersonKindProperty);
        }];
    }
    return _kind;
}
- (NSArray<NSString *> *)phoneNumbers {
    if (_phoneNumbers == nil) {
        _phoneNumbers = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _phoneNumbers;
}
- (NSArray<NSString *> *)phoneNumbersUnformatted {
    return [self.phoneNumbers BB_map:^id _Nullable(NSString * _Nonnull object, NSInteger index) {
        return [[object componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    }];
}
- (NSArray<NSDictionary<NSString *,id> *> *)instantMessages {
    if (_instantMessages == nil) {
        _instantMessages = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonInstantMessageProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _instantMessages;
}
- (NSArray<NSString *> *)URLStrings {
    if (_URLStrings == nil) {
        _URLStrings = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonURLProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _URLStrings;
}
- (NSArray<NSString *> *)relatedNames {
    if (_relatedNames == nil) {
        _relatedNames = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonRelatedNamesProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _relatedNames;
}
- (NSArray<NSDictionary<NSString *,id> *> *)socialProfiles {
    if (_socialProfiles == nil) {
        _socialProfiles = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonSocialProfileProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _socialProfiles;
}
- (NSArray<NSDictionary<NSString *,NSDateComponents *> *> *)alternateBirthdays {
    if (_alternateBirthdays == nil) {
        _alternateBirthdays = [self _executeWithPersonBlock:^id(ABRecordRef personRef) {
            return ({
                ABMultiValueRef valueRef = ABRecordCopyValue(personRef, kABPersonAlternateBirthdayProperty);
                NSArray *retval = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(valueRef);
                
                if (valueRef != NULL) {
                    CFRelease(valueRef);
                }
                
                retval;
            });
        }];
    }
    return _alternateBirthdays;
}

- (id)_executeWithPersonBlock:(id(^)(ABRecordRef personRef))block; {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (addressBookRef == NULL) {
        return nil;
    }
    
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, self.recordID);
    id retval = nil;
    
    if (personRef != NULL) {
        retval = block(personRef);
    }
    
    CFRelease(addressBookRef);
    
    return retval;
}

@end
