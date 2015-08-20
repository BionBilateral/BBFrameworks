//
//  BBMediaPickerAssetViewController.m
//  BBFrameworks
//
//  Created by William Towe on 8/20/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetViewController.h"
#import "BBMediaPickerAssetCollectionViewController.h"
#import "BBMediaPickerViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetViewController ()
@property (strong,nonatomic) BBMediaPickerAssetCollectionViewController *collectionViewController;
@end

@implementation BBMediaPickerAssetViewController
#pragma mark *** Subclass Overrides ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.collectionViewController];
    [self.view addSubview:self.collectionViewController.view];
    [self.collectionViewController didMoveToParentViewController:self];
    
    RAC(self,title) = RACObserve(self.collectionViewController, title);
    
    [self.navigationItem setRightBarButtonItems:self.collectionViewController.navigationItem.rightBarButtonItems];
}
- (void)viewWillLayoutSubviews {
    [self.collectionViewController.view setFrame:self.view.bounds];
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBMediaPickerAssetsGroupViewModel *)viewModel; {
    if (!(self = [super init]))
        return nil;
    
    [self setCollectionViewController:[[BBMediaPickerAssetCollectionViewController alloc] initWithViewModel:viewModel]];
    
    return self;
}

- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media; {
    [self.collectionViewController scrollMediaToVisible:media];
}

@end
