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
#import "NSArray+BBFoundationExtensions.h"
#import "BBBlocks.h"
#import "BBMediaPickerViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMediaPickerViewModel ()
@property (readwrite,copy,nonatomic) NSArray *assetsGroupViewModels;
@property (readwrite,copy,nonatomic) NSOrderedSet *selectedAssetViewModels;
@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;
@property (readwrite,strong,nonatomic) RACCommand *doneCommand;
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (readwrite,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;

@property (readwrite,weak,nonatomic) BBMediaPickerViewController *mediaPickerViewController;

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;

- (void)_refreshAssetsGroupViewModels;
@end

@implementation BBMediaPickerViewModel
#pragma mark *** Public Methods ***
- (instancetype)initWithViewController:(BBMediaPickerViewController *)viewController {
    if (!(self = [super init]))
        return nil;
    
    [self setMediaPickerViewController:viewController];
    
    _automaticallyDismissForSingleSelection = YES;
    _mediaTypes = BBMediaPickerMediaTypesAll;
    
    [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];
    
    @weakify(self);
    [[[[[NSNotificationCenter defaultCenter]
        rac_addObserverForName:ALAssetsLibraryChangedNotification object:self.assetsLibrary]
       takeUntil:[self rac_willDeallocSignal]]
      deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
     subscribeNext:^(NSNotification *value) {
         @strongify(self);
         BBLogObject(value);
         // if userInfo is nil, reload everything
         if (value.userInfo == nil) {
             [self _refreshAssetsGroupViewModels];
         }
         else {
             // if there are inserted assets group, create a new view model for each one and add them to the end of the array
             if (value.userInfo[ALAssetLibraryInsertedAssetGroupsKey]) {
                 NSMutableArray *assetsGroupViewModels = [NSMutableArray arrayWithArray:self.assetsGroupViewModels];
                 
                 for (NSURL *assetsGroupURL in value.userInfo[ALAssetLibraryInsertedAssetGroupsKey]) {
                     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                     
                     __block BBMediaPickerAssetsGroupViewModel *viewModel = nil;
                     
                     [self.assetsLibrary groupForURL:assetsGroupURL resultBlock:^(ALAssetsGroup *group) {
                         viewModel = [[BBMediaPickerAssetsGroupViewModel alloc] initWithAssetsGroup:group parentViewModel:self];
                         
                         dispatch_semaphore_signal(semaphore);
                     } failureBlock:^(NSError *error) {
                         dispatch_semaphore_signal(semaphore);
                     }];
                     
                     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                     
                     if (viewModel) {
                         [assetsGroupViewModels addObject:viewModel];
                     }
                 }
                 
                 [self setAssetsGroupViewModels:assetsGroupViewModels];
             }
             
             // if there are deleted assets group, find the matching view model and mark it as deleted
             if (value.userInfo[ALAssetLibraryDeletedAssetGroupsKey]) {
                 NSMutableArray *assetsGroupViewModels = [NSMutableArray arrayWithArray:self.assetsGroupViewModels];
                 
                 for (NSURL *assetsGroupURL in value.userInfo[ALAssetLibraryDeletedAssetGroupsKey]) {
                     BBMediaPickerAssetsGroupViewModel *viewModel = [assetsGroupViewModels BB_find:^BOOL(BBMediaPickerAssetsGroupViewModel *object, NSInteger index) {
                         return [assetsGroupURL isEqual:object.URL];
                     }];
                     
                     if (viewModel) {
                         [viewModel setDeleted:YES];
                         
                         [assetsGroupViewModels removeObject:viewModel];
                     }
                 }
                 
                 [self setAssetsGroupViewModels:assetsGroupViewModels];
             }
             
             // if there are updated assets group, find the matching view model and mark it as deleted, but only if the corresponding group no longer exists
             if (value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                 for (NSURL *assetsGroupURL in value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                     
                     void(^markViewModelWithURLAsDeletedBlock)(void) = ^{
                         BBMediaPickerAssetsGroupViewModel *viewModel = [self.assetsGroupViewModels BB_find:^BOOL(BBMediaPickerAssetsGroupViewModel *object, NSInteger index) {
                             return [assetsGroupURL isEqual:object.URL];
                         }];
                         
                         [viewModel setDeleted:YES];
                     };
                     
                     [self.assetsLibrary groupForURL:assetsGroupURL resultBlock:^(ALAssetsGroup *group) {
                         if (!group) {
                             markViewModelWithURLAsDeletedBlock();
                         }
                         
                         dispatch_semaphore_signal(semaphore);
                     } failureBlock:^(NSError *error) {
                         markViewModelWithURLAsDeletedBlock();
                         
                         dispatch_semaphore_signal(semaphore);
                     }];
                     
                     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                 }
                 
                 // if any view models were marked as deleted, filter them out of the resulting view models array
                 if ([self.assetsGroupViewModels BB_any:^BOOL(BBMediaPickerAssetsGroupViewModel *object, NSInteger index) {
                     return object.isDeleted;
                 }]) {
                     [self setAssetsGroupViewModels:[self.assetsGroupViewModels BB_filter:^BOOL(BBMediaPickerAssetsGroupViewModel *object, NSInteger index) {
                         return !object.isDeleted;
                     }]];
                 }
                 
                 // for all view models that remain in the array, refresh their asset view models which will also refresh their name and count
                 for (NSURL *assetsGroupURL in value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                     BBMediaPickerAssetsGroupViewModel *viewModel = [self.assetsGroupViewModels BB_find:^BOOL(BBMediaPickerAssetsGroupViewModel *object, NSInteger index) {
                         return [assetsGroupURL isEqual:object.URL];
                     }];
                     
                     [viewModel refreshAssetViewModels];
                 }
             }
         }
     }];
    
    [self setCancelCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self setDoneCommand:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self, selectedAssetViewModels)] reduce:^id(NSOrderedSet *value){
        return @(value.count > 0);
    }] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self setCancelBarButtonItemTitle:nil];
    
    [self setDoneBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL]];
    [self.doneBarButtonItem setRac_command:self.doneCommand];
    
    [[[RACSignal combineLatest:@[RACObserve(self, automaticallyDismissForSingleSelection),
                                 RACObserve(self, allowsMultipleSelection),
                                 RACObserve(self, selectedAssetViewModels)] reduce:^id(NSNumber *dismiss,NSNumber *flag, NSOrderedSet *value){
                                     return @(dismiss.boolValue && !flag.boolValue && value.count > 0);
                                 }]
      ignore:@NO]
     subscribeNext:^(id _) {
         @strongify(self);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             @strongify(self);
             [self.doneCommand execute:nil];
         });
     }];
    
    return self;
}

+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return (BBMediaPickerAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
}

- (void)selectAssetViewModel:(BBMediaPickerAssetViewModel *)viewModel; {
    if (self.allowsMultipleSelection) {
        NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetViewModels];
        
        [temp addObject:viewModel];
        
        [self setSelectedAssetViewModels:temp];
    }
    else {
        [self setSelectedAssetViewModels:[NSOrderedSet orderedSetWithObject:viewModel]];
    }
}
- (void)deselectAssetViewModel:(BBMediaPickerAssetViewModel *)viewModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetViewModels];
    
    [temp removeObject:viewModel];
    
    [self setSelectedAssetViewModels:temp];
}

- (RACSignal *)requestAssetsLibraryAuthorization; {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            *stop = YES;
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        } failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }] doNext:^(id x) {
        [self _refreshAssetsGroupViewModels];
    }];
}

- (void)setCancelBarButtonItemTitle:(NSString *)cancelBarButtonItemTitle {
    _cancelBarButtonItemTitle = cancelBarButtonItemTitle;
    
    if (_cancelBarButtonItemTitle) {
        [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:_cancelBarButtonItemTitle style:UIBarButtonItemStylePlain target:nil action:NULL]];
    }
    else {
        [self setCancelBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL]];
    }
    
    [self.cancelBarButtonItem setRac_command:self.cancelCommand];
}

- (void)_refreshAssetsGroupViewModels; {
    [self setSelectedAssetViewModels:nil];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            BBMediaPickerAssetsGroupViewModel *viewModel = [[BBMediaPickerAssetsGroupViewModel alloc] initWithAssetsGroup:group parentViewModel:self];
            
            if (viewModel.count == 0 &&
                self.hidesEmptyMediaGroups) {
                
                return;
            }
            
            [temp addObject:viewModel];
        }
        else {
            [self setAssetsGroupViewModels:temp];
        }
    } failureBlock:^(NSError *error) {
        BBLogObject(error);
    }];
}

@end
