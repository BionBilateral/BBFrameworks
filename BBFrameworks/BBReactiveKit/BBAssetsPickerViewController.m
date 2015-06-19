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
#import "BBAssetsPickerViewModel.h"
#import "BBAssetsPickerAssetGroupTableViewController.h"
#import "BBAssetsPickerViewController+BBReactiveKitExtensionsPrivate.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBAssetsPickerViewController ()
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;

@property (strong,nonatomic) BBAssetsPickerBackgroundView *backgroundView;
@property (strong,nonatomic) BBAssetsPickerAssetGroupTableViewController *tableViewController;

@property (strong,nonatomic) BBAssetsPickerViewModel *viewModel;

@property (assign,nonatomic) BOOL hasRequestedAuthorization;
@end

@implementation BBAssetsPickerViewController
#pragma mark *** Subclass Overrides ***
- (NSString *)title {
    return NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_VIEW_CONTROLLER_TITLE", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"Photos", @"assets picker view controller title");
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:[[BBAssetsPickerViewModel alloc] init]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackgroundView:[[BBAssetsPickerBackgroundView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.backgroundView];
    
    if (self.presentingViewController) {
        [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
        
        [self.cancelBarButtonItem setRac_command:self.viewModel.cancelCommand];
        
        [self.navigationItem setRightBarButtonItems:@[self.cancelBarButtonItem]];
        
        @weakify(self);
        [[[self.viewModel.cancelCommand.executionSignals
           concat]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);
             [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                 @strongify(self);
                 if ([self.delegate respondsToSelector:@selector(assetsPickerViewControllerDidCancel:)]) {
                     [self.delegate assetsPickerViewControllerDidCancel:self];
                 }
             }];
         }];
    }
}
- (void)viewWillLayoutSubviews {
    [self.tableViewController.tableView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, [self.bottomLayoutGuide length], 0)];
}
- (void)viewDidLayoutSubviews {
    [self.backgroundView setFrame:self.view.bounds];
    [self.tableViewController.view setFrame:self.view.bounds];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.hasRequestedAuthorization) {
        [self setHasRequestedAuthorization:YES];
        
        @weakify(self);
        [[[self.viewModel requestAssetsLibraryAuthorizationStatus]
         deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
            [self.backgroundView setAuthorizationStatus:value.integerValue];
            [self setTableViewController:[[BBAssetsPickerAssetGroupTableViewController alloc] initWithViewModel:self.viewModel]];
        } error:^(NSError *error) {
            @strongify(self);
            [self.backgroundView setAuthorizationStatus:[error.userInfo[BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus] integerValue]];
        }];
    }
}

- (void)setTableViewController:(BBAssetsPickerAssetGroupTableViewController *)tableViewController {
    _tableViewController = tableViewController;
    
    if (_tableViewController) {
        [self addChildViewController:_tableViewController];
        [self.view addSubview:_tableViewController.view];
        [_tableViewController didMoveToParentViewController:self];
    }
}

@end

@implementation UIViewController (BBReactiveKitExtensionsPrivate)

- (BBAssetsPickerViewController *)BB_assetsPickerViewController {
    BBAssetsPickerViewController *retval = nil;
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[BBAssetsPickerViewController class]]) {
            retval = (BBAssetsPickerViewController *)viewController;
            break;
        }
    }
    
    return retval;
}

@end
