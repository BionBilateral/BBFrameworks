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
#import "BBAssetsPickerAssetGroupViewModel.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BlocksKit/BlocksKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

NSString *const BBAssetsPickerViewModelErrorDomain = @"com.bionbilateral.bbframeworks.bbreactivekit.bbassetspickerviewmodel";
NSInteger const BBAssetsPickerViewModelErrorCodeAuthorizationStatus = 1;
NSString *const BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus = @"BBAssetsPickerViewModelErrorUserInfoKeyAuthorizationStatus";

@interface BBAssetsPickerViewModel ()
@property (readwrite,copy,nonatomic) NSArray *assetGroupViewModels;
@property (readwrite,strong,nonatomic) RACCommand *cancelCommand;

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong,nonatomic) RACDisposable *assetsLibraryNotificationDisposable;

- (void)_reloadAssetGroupViewModels;
@end

@implementation BBAssetsPickerViewModel
#pragma mark *** Subclass Overrides ***
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
#pragma mark *** Public Methods ***
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

- (NSArray *)assetGroupViewModels {
    if (!_assetGroupViewModels) {
        [self _reloadAssetGroupViewModels];
    }
    return _assetGroupViewModels;
}
#pragma mark *** Private Methods ***
- (void)_reloadAssetGroupViewModels; {
    NSMutableArray *assetGroupViewModels = [[NSMutableArray alloc] init];
    
    @weakify(self);
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        @strongify(self);
        if (group) {
            [assetGroupViewModels addObject:[[BBAssetsPickerAssetGroupViewModel alloc] initWithAssetsGroup:group]];
        }
        else {
            [self setAssetGroupViewModels:assetGroupViewModels];
        }
    } failureBlock:^(NSError *error) {
        @strongify(self);
        [self setAssetGroupViewModels:nil];
    }];
}
#pragma mark Properties
- (void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    [self setAssetsLibraryNotificationDisposable:nil];
    
    _assetsLibrary = assetsLibrary;
    
    if (_assetsLibrary) {
        @weakify(self);
        [self setAssetsLibraryNotificationDisposable:
         [[[[[NSNotificationCenter defaultCenter]
            rac_addObserverForName:ALAssetsLibraryChangedNotification object:_assetsLibrary]
           takeUntil:[self rac_willDeallocSignal]]
           deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]]
          subscribeNext:^(NSNotification *value) {
              @strongify(self);
              if (value.userInfo.count > 0) {
                  // one or more asset groups were inserted, create new view models for each group
                  if (value.userInfo[ALAssetLibraryInsertedAssetGroupsKey]) {
                      NSMutableArray *assetGroupViewModels = [self.assetGroupViewModels mutableCopy];
                      
                      for (NSURL *assetGroupURL in value.userInfo[ALAssetLibraryInsertedAssetGroupsKey]) {
                          dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                          
                          void(^signalSemaphoreBlock)(dispatch_semaphore_t) = ^(dispatch_semaphore_t semaphore){
                              dispatch_semaphore_signal(semaphore);
                          };
                          
                          __block BBAssetsPickerAssetGroupViewModel *viewModel = nil;
                          
                          [self.assetsLibrary groupForURL:assetGroupURL resultBlock:^(ALAssetsGroup *group) {
                              viewModel = [[BBAssetsPickerAssetGroupViewModel alloc] initWithAssetsGroup:group];
                              signalSemaphoreBlock(semaphore);
                          } failureBlock:^(NSError *error) {
                              signalSemaphoreBlock(semaphore);
                          }];
                          
                          dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                          
                          if (viewModel) {
                              [assetGroupViewModels addObject:viewModel];
                          }
                      }
                      
                      [self setAssetGroupViewModels:assetGroupViewModels];
                  }
                  
                  // one or more asset groups were deleted, find the corresponding view models and remove them
                  if (value.userInfo[ALAssetLibraryDeletedAssetGroupsKey]) {
                      NSMutableArray *assetGroupViewModels = [self.assetGroupViewModels mutableCopy];
                      
                      for (NSURL *assetGroupURL in value.userInfo[ALAssetLibraryDeletedAssetGroupsKey]) {
                          BBAssetsPickerAssetGroupViewModel *viewModel = [assetGroupViewModels bk_match:^BOOL(BBAssetsPickerAssetGroupViewModel *obj) {
                              return [assetGroupURL isEqual:obj.URL];
                          }];
                          
                          if (viewModel) {
                              [viewModel setDeleted:YES];
                              
                              [assetGroupViewModels removeObject:viewModel];
                          }
                      }
                      
                      [self setAssetGroupViewModels:assetGroupViewModels];
                  }
                  
                  // an asset group was updated, reload only that group (e.g. the Camera Roll group updates when the user takes a new camera photo)
                  if (value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                      // loop through each updated asset group url and see if the asset library will return a valid group for it, if not, it was deleted and we need to mark the corresponding view model as such
                      for (NSURL *assetGroupURL in value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                          dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                          
                          void(^signalSemaphoreBlock)(dispatch_semaphore_t) = ^(dispatch_semaphore_t semaphore){
                              dispatch_semaphore_signal(semaphore);
                          };
                          
                          void(^markViewModelWithURLDeletedBlock)(NSURL *) = ^(NSURL *URL){
                              BBAssetsPickerAssetGroupViewModel *viewModel = [self.assetGroupViewModels bk_match:^BOOL(BBAssetsPickerAssetGroupViewModel *obj) {
                                  return [URL isEqual:obj.URL];
                              }];
                              
                              [viewModel setDeleted:YES];
                          };
                          
                          [self.assetsLibrary groupForURL:assetGroupURL resultBlock:^(ALAssetsGroup *group) {
                              if (!group) {
                                  markViewModelWithURLDeletedBlock(assetGroupURL);
                              }
                              signalSemaphoreBlock(semaphore);
                          } failureBlock:^(NSError *error) {
                              markViewModelWithURLDeletedBlock(assetGroupURL);
                              signalSemaphoreBlock(semaphore);
                          }];
                          
                          dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                      }
                      
                      // if any of our asset group view models are marked as deleted, filter the entire array for the non deleted view models
                      if ([self.assetGroupViewModels bk_any:^BOOL(BBAssetsPickerAssetGroupViewModel *obj) {
                          return obj.isDeleted;
                      }]) {
                          [self setAssetGroupViewModels:[self.assetGroupViewModels bk_select:^BOOL(BBAssetsPickerAssetGroupViewModel *obj) {
                              return !obj.isDeleted;
                          }]];
                      }
                      
                      // for every asset group url, if the corresponding view model is still in our array, reload the assets for that view model
                      for (NSURL *assetGroupURL in value.userInfo[ALAssetLibraryUpdatedAssetGroupsKey]) {
                          for (BBAssetsPickerAssetGroupViewModel *viewModel in self.assetGroupViewModels) {
                              if ([viewModel.URL isEqual:assetGroupURL]) {
                                  [viewModel reloadAssetViewModels];
                              }
                          }
                      }
                  }
              }
              // reload everything
              else if (!value.userInfo) {
                  [self _reloadAssetGroupViewModels];
              }
          }]];
    }
}

- (void)setAssetsLibraryNotificationDisposable:(RACDisposable *)assetsLibraryNotificationDisposable {
    [_assetsLibraryNotificationDisposable dispose];
    
    _assetsLibraryNotificationDisposable = assetsLibraryNotificationDisposable;
}

@end
