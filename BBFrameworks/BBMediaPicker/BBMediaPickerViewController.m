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

#import "BBMediaPickerViewController+BBReactiveKitExtensionsPrivate.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerViewModel.h"
#import "BBMediaPickerCollectionTableViewController.h"
#import "BBFrameworksFunctions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerViewController ()
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;

@property (strong,nonatomic) BBMediaPickerCollectionTableViewController *tableViewController;

@property (strong,nonatomic) BBMediaPickerViewModel *viewModel;

@property (assign,nonatomic) BOOL hasRequestedAuthorization;
@end

@implementation BBMediaPickerViewController
#pragma mark *** Subclass Overrides ***
- (NSString *)title {
    return NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_VIEW_CONTROLLER_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Photos", @"media picker view controller title");
}

- (instancetype)init {
    if (!(self = [super initWithNibName:nil bundle:nil]))
        return nil;
    
    [self setViewModel:[[BBMediaPickerViewModel alloc] init]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTableViewController:[[BBMediaPickerCollectionTableViewController alloc] initWithViewModel:self.viewModel]];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
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
    [self.tableViewController.view setFrame:self.view.bounds];
}
- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent) {
        [self.viewModel setActive:YES];
    }
    else {
        [self.viewModel setActive:NO];
    }
}

+ (BBMediaPickerViewControllerAuthorizationStatus)authorizationStatus; {
    return (BBMediaPickerViewControllerAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

@dynamic assetCollectionSubtypes;
- (NSArray *)assetCollectionSubtypes {
    return self.viewModel.assetCollectionSubtypes;
}
- (void)setAssetCollectionSubtypes:(NSArray *)assetCollectionSubtypes {
    [self.viewModel setAssetCollectionSubtypes:assetCollectionSubtypes];
}

@end

@implementation UIViewController (BBReactiveKitExtensionsPrivate)

- (BBMediaPickerViewController *)BB_mediaPickerViewController {
    BBMediaPickerViewController *retval = nil;
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[BBMediaPickerViewController class]]) {
            retval = (BBMediaPickerViewController *)viewController;
            break;
        }
    }
    
    return retval;
}

@end
