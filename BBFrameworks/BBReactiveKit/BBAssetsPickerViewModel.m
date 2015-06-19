//
//  BBAssetsPickerViewModel.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBAssetsPickerViewModel.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

NSString *const BBAssetsPickerViewModelErrorDomain = @"com.bionbilateral.bbframeworks.bbreactivekit.bbassetspickerviewmodel";
NSInteger const BBAssetsPickerViewModelErrorCodeAuthorizationStatus = 1;
NSString *const BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus = @"BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus";

@interface BBAssetsPickerViewModel ()
@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong,nonatomic) RACDisposable *assetsLibraryNotificationDisposable;
@end

@implementation BBAssetsPickerViewModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];
    
    @weakify(self);
    [self setCancelCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    return self;
}

- (RACSignal *)requestAssetsLibraryAuthorizationStatus; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            [subscriber sendNext:@(ALAuthorizationStatusAuthorized)];
            [subscriber sendCompleted];
        }
        else {
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                [subscriber sendNext:@(ALAuthorizationStatusAuthorized)];
                [subscriber sendCompleted];
            } failureBlock:^(NSError *error) {
                [subscriber sendError:[NSError errorWithDomain:BBAssetsPickerViewModelErrorDomain code:BBAssetsPickerViewModelErrorCodeAuthorizationStatus userInfo:@{BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus: @([ALAssetsLibrary authorizationStatus]), NSUnderlyingErrorKey: error}]];
            }];
        }
        return nil;
    }];
}

- (void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    [self setAssetsLibraryNotificationDisposable:nil];
    
    _assetsLibrary = assetsLibrary;
    
    if (_assetsLibrary) {
        [self setAssetsLibraryNotificationDisposable:
         [[[[NSNotificationCenter defaultCenter]
            rac_addObserverForName:ALAssetsLibraryChangedNotification object:_assetsLibrary]
           takeUntil:[self rac_willDeallocSignal]]
          subscribeNext:^(NSNotification *value) {
              BBLogObject(value);
          }]];
    }
}

- (void)setAssetsLibraryNotificationDisposable:(RACDisposable *)assetsLibraryNotificationDisposable {
    [_assetsLibraryNotificationDisposable dispose];
    
    _assetsLibraryNotificationDisposable = assetsLibraryNotificationDisposable;
}

@end
