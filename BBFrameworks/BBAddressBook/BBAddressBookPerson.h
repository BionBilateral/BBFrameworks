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

@interface BBAddressBookPerson : NSObject

@property (readonly,assign,nonatomic) ABRecordRef person;

@property (readonly,nonatomic) UIImage *image;
@property (readonly,nonatomic) UIImage *thumbnailImage;

@property (readonly,nonatomic) NSString *prefix;
@property (readonly,nonatomic) NSString *firstName;
@property (readonly,nonatomic) NSString *middleName;
@property (readonly,nonatomic) NSString *lastName;
@property (readonly,nonatomic) NSString *suffix;
@property (readonly,nonatomic) NSString *fullName;
@property (readonly,nonatomic) NSString *nickname;
@property (readonly,nonatomic) NSString *organization;
@property (readonly,nonatomic) NSString *jobTitle;
@property (readonly,nonatomic) NSString *department;
@property (readonly,nonatomic) NSArray *emails;
@property (readonly,nonatomic) NSDate *birthday;
@property (readonly,nonatomic) NSString *note;
@property (readonly,nonatomic) NSDate *creationDate;
@property (readonly,nonatomic) NSDate *modificationDate;
@property (readonly,nonatomic) NSArray *phoneNumbers;

- (instancetype)initWithPerson:(ABRecordRef)person NS_DESIGNATED_INITIALIZER;

@end
