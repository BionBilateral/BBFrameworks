//
//  BBAssetsPickerViewController.m
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

#import "BBAssetsPickerViewController.h"
#import "BBAssetsPickerBackgroundView.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBAssetsPickerViewController ()
@property (strong,nonatomic) BBAssetsPickerBackgroundView *backgroundView;

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong,nonatomic) RACDisposable *assetsLibraryNotificationDisposable;
@end

@implementation BBAssetsPickerViewController

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackgroundView:[[BBAssetsPickerBackgroundView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.backgroundView];
}
- (void)viewDidLayoutSubviews {
    [self.backgroundView setFrame:self.view.bounds];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized) {
        @weakify(self);
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            @strongify(self);
            [self.backgroundView setAuthorizationStatus:ALAuthorizationStatusAuthorized];
        } failureBlock:^(NSError *error) {
            @strongify(self);
            [self.backgroundView setAuthorizationStatus:[ALAssetsLibrary authorizationStatus]];
        }];
    }
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
