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
#import "BBFrameworksFunctions.h"
#import "BBBlocks.h"
#import "BBMediaPickerAssetViewModel.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerAssetCollectionViewController+BBMediaPickerExtensionsPrivate.h"
#import "BBMediaPickerAssetsGroupViewController.h"
#import "BBFoundationFunctions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerViewController () <BBMediaPickerViewModelDelegate>
@property (strong,nonatomic) BBMediaPickerViewModel *viewModel;

@property (strong,nonatomic) BBMediaPickerAssetsGroupViewController *assetsGroupViewController;
@end

@implementation BBMediaPickerViewController
#pragma mark *** Subclass Overrides ***
- (NSString *)title {
    NSString *retval = NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_VIEW_CONTROLLER_TITLE", @"MediaPicker", BBFrameworksResourcesBundle(), @"Photos", @"Media picker view controller title");
    
    return self.titleTransformBlock ? self.titleTransformBlock(retval) : retval;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:[[BBMediaPickerViewModel alloc] initWithViewController:self]];
    [self.viewModel setDelegate:self];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.shouldShowCancelAndDoneBarButtonItems) {
        [self.navigationItem setRightBarButtonItems:@[self.viewModel.cancelBarButtonItem]];
    }
    
    [self setAssetsGroupViewController:[[BBMediaPickerAssetsGroupViewController alloc] initWithViewModel:self.viewModel]];
    [self addChildViewController:self.assetsGroupViewController];
    [self.view addSubview:self.assetsGroupViewController.view];
    [self.assetsGroupViewController didMoveToParentViewController:self];
    
    @weakify(self);
    [[self.viewModel.cancelCommand.executionSignals
     concat]
     subscribeNext:^(id _) {
         @strongify(self);
         void(^completionBlock)(void) = ^{
             @strongify(self);
             [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                 @strongify(self);
                 if ([self.delegate respondsToSelector:@selector(mediaPickerViewControllerDidCancel:)]) {
                     [self.delegate mediaPickerViewControllerDidCancel:self];
                 }
             }];
         };
         
         if (self.cancelConfirmBlock) {
             self.cancelConfirmBlock(self,^(BOOL confirm){
                 if (confirm) {
                     completionBlock();
                 }
             });
         }
         else {
             completionBlock();
         }
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
    [self.assetsGroupViewController.view setFrame:self.view.bounds];
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
#pragma mark BBMediaPickerViewModelDelegate
- (void)mediaPickerViewModel:(BBMediaPickerViewModel *)viewModel didSelectMedia:(id<BBMediaPickerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didSelectMedia:)]) {
        [self.delegate mediaPickerViewController:self didSelectMedia:media];
    }
}
- (void)mediaPickerViewModel:(BBMediaPickerViewModel *)viewModel didDeselectMedia:(id<BBMediaPickerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didDeselectMedia:)]) {
        [self.delegate mediaPickerViewController:self didDeselectMedia:media];
    }
}
#pragma mark *** Public Methods ***
+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return [BBMediaPickerViewModel authorizationStatus];
}
+ (void)requestAuthorizationWithCompletion:(BBMediaPickerAuthorizationCompletionBlock)completion {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block BOOL hasInvokedCompletionBlock = NO;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        *stop = YES;
        
        if (!hasInvokedCompletionBlock) {
            hasInvokedCompletionBlock = YES;
            
            if (completion) {
                BBDispatchMainSyncSafe(^{
                    completion(YES,nil);
                });
            }
        }
    } failureBlock:^(NSError *error) {
        if (!hasInvokedCompletionBlock) {
            hasInvokedCompletionBlock = YES;
            
            if (completion) {
                BBDispatchMainSyncSafe(^{
                    completion(NO,error);
                });
            }
        }
    }];
}

- (NSInteger)countOfMedia; {
    return [self BB_mediaPickerAssetCollectionViewController].assetViewModels.count;
}
- (NSInteger)indexOfMedia:(id<BBMediaPickerMedia>)media; {
    BBMediaPickerAssetCollectionViewController *viewController = [self BB_mediaPickerAssetCollectionViewController];
    NSInteger retval = NSNotFound;
    
    if (viewController) {
        retval = [viewController.assetViewModels indexOfObject:media];
    }
    
    return retval;
}
- (id<BBMediaPickerMedia>)mediaAtIndex:(NSInteger)index; {
    BBMediaPickerAssetCollectionViewController *viewController = [self BB_mediaPickerAssetCollectionViewController];
    id<BBMediaPickerMedia> retval = nil;
    
    if (index < [self countOfMedia]) {
        retval = viewController.assetViewModels[index];
    }
    
    return retval;
}

- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media; {
    [[self BB_mediaPickerAssetCollectionViewController] scrollMediaToVisible:media];
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
@dynamic automaticallyDismissForSingleSelection;
- (BOOL)automaticallyDismissForSingleSelection {
    return self.viewModel.automaticallyDismissForSingleSelection;
}
- (void)setAutomaticallyDismissForSingleSelection:(BOOL)automaticallyDismissForSingleSelection {
    [self.viewModel setAutomaticallyDismissForSingleSelection:automaticallyDismissForSingleSelection];
}

@dynamic titleTransformBlock;
- (BBMediaPickerTitleTransformBlock)titleTransformBlock {
    return self.viewModel.titleTransformBlock;
}
- (void)setTitleTransformBlock:(BBMediaPickerTitleTransformBlock)titleTransformBlock {
    [self.viewModel setTitleTransformBlock:titleTransformBlock];
}

@dynamic shouldShowCancelAndDoneBarButtonItems;
- (BOOL)shouldShowCancelAndDoneBarButtonItems {
    return self.viewModel.shouldShowCancelAndDoneBarButtonItems;
}
- (void)setShouldShowCancelAndDoneBarButtonItems:(BOOL)shouldShowCancelAndDoneBarButtonItems {
    [self.viewModel setShouldShowCancelAndDoneBarButtonItems:shouldShowCancelAndDoneBarButtonItems];
}
@dynamic cancelBarButtonItemTitle;
- (NSString *)cancelBarButtonItemTitle {
    return self.viewModel.cancelBarButtonItemTitle;
}
- (void)setCancelBarButtonItemTitle:(NSString *)cancelBarButtonItemTitle {
    [self.viewModel setCancelBarButtonItemTitle:cancelBarButtonItemTitle];
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

@dynamic bottomAccessoryViewClass;
- (Class)bottomAccessoryViewClass {
    return self.viewModel.bottomAccessoryViewClass;
}
- (void)setBottomAccessoryViewClass:(Class)bottomAccessoryViewClass {
    [self.viewModel setBottomAccessoryViewClass:bottomAccessoryViewClass];
}

@end

@implementation UIViewController (BBMediaPickerViewControllerExtensions)

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
