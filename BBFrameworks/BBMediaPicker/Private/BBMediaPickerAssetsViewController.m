//
//  BBMediaPickerAssetsViewController.m
//  BBFrameworks
//
//  Created by William Towe on 11/13/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetsViewController.h"
#import "BBMediaPickerAssetsCollectionViewController.h"
#import "BBMediaPickerTheme.h"
#import "BBKeyValueObserving.h"
#import "BBFrameworksMacros.h"

@interface BBMediaPickerAssetsViewController ()
@property (strong,nonatomic) BBMediaPickerAssetsCollectionViewController *collectionViewController;

@property (strong,nonatomic) BBMediaPickerModel *model;
@end

@implementation BBMediaPickerAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCollectionViewController:[[BBMediaPickerAssetsCollectionViewController alloc] initWithModel:self.model]];
    [self addChildViewController:self.collectionViewController];
    [self.view addSubview:self.collectionViewController.view];
    [self.collectionViewController didMoveToParentViewController:self];
    
    BBWeakify(self);
    [self BB_addObserverForKeyPath:@BBKeypath(self.model,theme) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.view setBackgroundColor:self.model.theme.assetBackgroundColor];
    }];
}
- (void)viewDidLayoutSubviews {
    [self.collectionViewController.view setFrame:self.view.bounds];
}

- (instancetype)initWithModel:(BBMediaPickerModel *)model {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:model];
    
    return self;
}

@end
