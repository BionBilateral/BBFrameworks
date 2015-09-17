//
//  BBAddressBookGroup.m
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

#import "BBAddressBookGroup.h"
#import "BBAddressBookPerson.h"
#import "BBBlocks.h"

#import <AddressBook/AddressBook.h>

@interface BBAddressBookGroup ()
@property (readwrite,assign,nonatomic) ABRecordRef group;
@end

@implementation BBAddressBookGroup
- (instancetype)init {
    return [self initWithGroup:NULL];
}

#pragma mark *** Public Methods ***
- (instancetype)initWithGroup:(ABRecordRef)group {
    if (!(self = [super init]))
        return nil;
    
    [self setGroup:group];
    
    return self;
}

- (NSArray *)sortedPeopleWithSortDescriptors:(NSArray *)sortDescriptors; {
    NSArray *retval = [[(__bridge_transfer NSArray *)ABGroupCopyArrayOfAllMembers(self.group) BB_map:^id(id object, NSInteger index) {
        return [[BBAddressBookPerson alloc] initWithPerson:(__bridge ABRecordRef)object];
    }] BB_filter:^BOOL(BBAddressBookPerson *object, NSInteger index) {
        return object.fullName.length > 0;
    }];
    
    if (sortDescriptors.count > 0) {
        retval = [retval sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    return retval;
}
#pragma mark Properties
- (ABRecordID)recordID {
    return ABRecordGetRecordID(self.group);
}

- (NSString *)name {
    return (__bridge_transfer NSString *)ABRecordCopyValue(self.group, kABGroupNameProperty);
}
- (NSArray *)people {
    return [self sortedPeopleWithSortDescriptors:nil];
}

@end
