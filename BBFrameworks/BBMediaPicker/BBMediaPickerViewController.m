//
//  BBMediaPickerViewController.m
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

#import "BBMediaPickerViewController.h"
#import "BBMediaPickerViewModel.h"
#import "BBMediaPickerAssetsGroupTableViewController.h"
#import "BBFrameworksFunctions.h"
#import "BBBlocks.h"
#import "BBMediaPickerAssetViewModel.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerViewController ()
@property (strong,nonatomic) BBMediaPickerViewModel *viewModel;

@property (strong,nonatomic) BBMediaPickerAssetsGroupTableViewController *tableViewController;
@end

@implementation BBMediaPickerViewController

- (NSString *)title {
    return NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_VIEW_CONTROLLER_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Photos", @"Media picker view controller title");
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:[[BBMediaPickerViewModel alloc] init]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setRightBarButtonItems:@[self.viewModel.cancelBarButtonItem]];
    
    [self setTableViewController:[[BBMediaPickerAssetsGroupTableViewController alloc] initWithViewModel:self.viewModel]];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
    @weakify(self);
    [[self.viewModel.cancelCommand.executionSignals
     concat]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
             @strongify(self);
             if ([self.delegate respondsToSelector:@selector(mediaPickerViewControllerDidCancel:)]) {
                 [self.delegate mediaPickerViewControllerDidCancel:self];
             }
         }];
     }];
    
    [[self.viewModel.doneCommand.executionSignals
     concat]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
             @strongify(self);
             if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didFinishPickingMedia:)]) {
                 [self.delegate mediaPickerViewController:self didFinishPickingMedia:self.viewModel.selectedAssetViewModels.array];
             }
         }];
     }];
}
- (void)viewDidLayoutSubviews {
    [self.tableViewController.view setFrame:self.view.bounds];
}
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (parent) {
        [[self.viewModel requestAssetsLibraryAuthorization]
         subscribeError:^(NSError *error) {
             // TODO: display error to the user
         }];
    }
}
#pragma mark *** Public Methods ***
+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return [BBMediaPickerViewModel authorizationStatus];
}
#pragma mark Properties
@dynamic allowsMultipleSelection;
- (BOOL)allowsMultipleSelection {
    return self.viewModel.allowsMultipleSelection;
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    [self.viewModel setAllowsMultipleSelection:allowsMultipleSelection];
}
@dynamic hidesEmptyMediaGroups;
- (BOOL)hidesEmptyMediaGroups {
    return self.viewModel.hidesEmptyMediaGroups;
}
- (void)setHidesEmptyMediaGroups:(BOOL)hidesEmptyMediaGroups {
    [self.viewModel setHidesEmptyMediaGroups:hidesEmptyMediaGroups];
}

@dynamic mediaTypes;
- (BBMediaPickerMediaTypes)mediaTypes {
    return self.viewModel.mediaTypes;
}
- (void)setMediaTypes:(BBMediaPickerMediaTypes)mediaTypes {
    [self.viewModel setMediaTypes:mediaTypes];
}
@dynamic mediaFilterBlock;
- (BBMediaPickerMediaFilterBlock)mediaFilterBlock {
    return self.viewModel.mediaFilterBlock;
}
- (void)setMediaFilterBlock:(BBMediaPickerMediaFilterBlock)mediaFilterBlock {
    [self.viewModel setMediaFilterBlock:mediaFilterBlock];
}

@end
