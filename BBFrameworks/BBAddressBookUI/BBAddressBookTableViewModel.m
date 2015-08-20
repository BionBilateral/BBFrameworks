//
//  BBAddressBookTableViewModel.m
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

#import "BBAddressBookTableViewModel.h"
#import "BBAddressBookManager.h"
#import "BBAddressBookPerson.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAddressBookTableViewModel ()
@property (readwrite,copy,nonatomic) NSArray *people;

@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;

@property (strong,nonatomic) BBAddressBookManager *addressBookManager;
@end

@implementation BBAddressBookTableViewModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAddressBookManager:[[BBAddressBookManager alloc] init]];
    
    @weakify(self);
    [self setCancelCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self.didBecomeActiveSignal
     subscribeNext:^(BBAddressBookTableViewModel *value) {
         @strongify(self);
         if (self.people.count == 0) {
             [self.addressBookManager requestAllPeopleWithSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(BBAddressBookPerson.new,lastName) ascending:YES selector:@selector(localizedStandardCompare:)]] completion:^(NSArray *people, NSError *error) {
                 @strongify(self);
                 [self setPeople:people];
             }];
         }
     }];
    
    [[[[NSNotificationCenter defaultCenter]
     rac_addObserverForName:BBAddressBookManagerNotificationNameExternalChange object:self.addressBookManager]
     takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.addressBookManager requestAllPeopleWithSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(BBAddressBookPerson.new,lastName) ascending:YES selector:@selector(localizedStandardCompare:)]] completion:^(NSArray *people, NSError *error) {
             @strongify(self);
             [self setPeople:people];
         }];
     }];
    
    return self;
}

@end
