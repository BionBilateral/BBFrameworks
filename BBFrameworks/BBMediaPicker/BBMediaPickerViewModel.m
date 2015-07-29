//
//  BBMediaPickerViewModel.m
//  BBFrameworks
//
//  Created by William Towe on 7/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerViewModel.h"
#import "BBFrameworksFunctions.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerAssetsGroupViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMediaPickerViewModel ()
@property (readwrite,copy,nonatomic) NSArray *assetsGroupViewModels;
@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;
@end

@implementation BBMediaPickerViewModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter]
     rac_addObserverForName:ALAssetsLibraryChangedNotification object:self.assetsLibrary]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *note) {
         
     }];
    
    [self setCancelCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
    [self.cancelBarButtonItem setRac_command:self.cancelCommand];
    
    return self;
}

+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return (BBMediaPickerAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
}

- (RACSignal *)requestAssetsLibraryAuthorization; {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            *stop = YES;
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        } failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }] doNext:^(id x) {
        if (!self.assetsGroupViewModels) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (group) {
                    [temp addObject:[[BBMediaPickerAssetsGroupViewModel alloc] initWithAssetsGroup:group]];
                }
                else {
                    [self setAssetsGroupViewModels:temp];
                }
            } failureBlock:^(NSError *error) {
                BBLogObject(error);
            }];
        }
    }];
}

@end
