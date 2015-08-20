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
#import "BBMediaPickerAssetsGroupViewModel.h"
#import "BBMediaPickerViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetViewController ()
@property (strong,nonatomic) BBMediaPickerAssetCollectionViewController *collectionViewController;

@property (strong,nonatomic) UIView *assetBottomAccessoryView;

@property (strong,nonatomic) BBMediaPickerAssetsGroupViewModel *viewModel;
@end

@implementation BBMediaPickerAssetViewController
#pragma mark *** Subclass Overrides ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCollectionViewController:[[BBMediaPickerAssetCollectionViewController alloc] initWithViewModel:self.viewModel]];
    [self addChildViewController:self.collectionViewController];
    [self.view addSubview:self.collectionViewController.view];
    [self.collectionViewController didMoveToParentViewController:self];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, deleted)
       ignore:@NO]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.navigationController popToRootViewControllerAnimated:YES];
     }];
    
    if (self.viewModel.parentViewModel.allowsMultipleSelection) {
        RAC(self,title) = [RACSignal combineLatest:@[RACObserve(self.viewModel, name),RACObserve(self.viewModel.parentViewModel, selectedAssetString)] reduce:^id(NSString *name, NSString *selected){
            return selected.length > 0 ? selected : name;
        }];
    }
    else {
        RAC(self,title) = RACObserve(self.viewModel, name);
    }
    
    if ([self BB_mediaPickerViewController].assetBottomAccessoryView) {
        [self setAssetBottomAccessoryView:[self BB_mediaPickerViewController].assetBottomAccessoryView];
        [self.view addSubview:self.assetBottomAccessoryView];
        
        if ([self.assetBottomAccessoryView respondsToSelector:@selector(setRac_command:)]) {
            [(id)self.assetBottomAccessoryView setRac_command:self.viewModel.parentViewModel.doneCommand];
        }
        else if ([self.assetBottomAccessoryView respondsToSelector:@selector(setEnabled:)]) {
            [self.viewModel.parentViewModel.doneCommand.enabled
             subscribeNext:^(NSNumber *value) {
                 @strongify(self);
                 [(id)self.assetBottomAccessoryView setEnabled:value.boolValue];
             }];
        }
    }
    
    if (!self.assetBottomAccessoryView) {
        if (self.viewModel.parentViewModel.allowsMultipleSelection) {
            [self.navigationItem setRightBarButtonItems:@[self.viewModel.parentViewModel.doneBarButtonItem]];
        }
        else {
            [self.navigationItem setRightBarButtonItems:@[self.viewModel.parentViewModel.cancelBarButtonItem]];
        }
    }
}
- (void)viewWillLayoutSubviews {
    if (self.assetBottomAccessoryView) {
        CGFloat height = [self.assetBottomAccessoryView sizeThatFits:CGSizeZero].height;
        
        [self.assetBottomAccessoryView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - height, CGRectGetWidth(self.view.bounds), height)];
        [self.collectionViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.assetBottomAccessoryView.frame))];
    }
    else {
        [self.collectionViewController.view setFrame:self.view.bounds];
    }
}
#pragma mark *** Public Methods ***
- (instancetype)initWithViewModel:(BBMediaPickerAssetsGroupViewModel *)viewModel; {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:viewModel];
    
    return self;
}

- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media; {
    [self.collectionViewController scrollMediaToVisible:media];
}

@end
