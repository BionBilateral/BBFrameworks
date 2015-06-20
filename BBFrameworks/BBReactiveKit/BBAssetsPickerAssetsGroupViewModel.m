//
//  BBAssetsPickerAssetGroupViewModel.m
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

#import "BBAssetsPickerAssetsGroupViewModel.h"
#import "BBAssetsPickerAssetViewModel.h"
#import "BBAssetsPickerViewModel.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <Photos/Photos.h>

@interface BBAssetsPickerAssetsGroupViewModel ()
@property (readwrite,copy,nonatomic) NSArray *assetViewModels;
@property (readwrite,copy,nonatomic) NSArray *selectedAssetViewModels;

@property (readwrite,strong,nonatomic) RACCommand *doneCommand;

@property (strong,nonatomic) PHCollection *assetsGroup;
@property (weak,nonatomic) BBAssetsPickerViewModel *viewModel;
@end

@implementation BBAssetsPickerAssetsGroupViewModel
#pragma mark *** Public Methods ***
- (instancetype)initWithAssetsGroup:(PHCollection *)assetsGroup viewModel:(BBAssetsPickerViewModel *)viewModel; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(assetsGroup);
    NSParameterAssert(viewModel);
    
    [self setAssetsGroup:assetsGroup];
    [self setViewModel:viewModel];
    
    @weakify(self);
    [self setDoneCommand:[[RACCommand alloc] initWithEnabled:[RACObserve(self, selectedAssetViewModels) map:^id(NSArray *value) {
        return @(value.count > 0);
    }] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    return self;
}

- (void)reloadAssetViewModels; {
    NSMutableArray *assetViewModels = [[NSMutableArray alloc] init];
    
    if ([self.assetsGroup isKindOfClass:[PHAssetCollection class]]) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)self.assetsGroup options:nil];
        
        for (PHAsset *asset in result) {
            [assetViewModels addObject:[[BBAssetsPickerAssetViewModel alloc] initWithAsset:asset assetsGroupViewModel:self]];
        }
    }
    
    [self setAssetViewModels:assetViewModels.count > 0 ? assetViewModels : nil];
    
    [self setSelectedAssetViewModels:nil];
}

- (void)selectAssetViewModel:(BBAssetsPickerAssetViewModel *)viewModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithArray:self.selectedAssetViewModels];
    
    [temp addObject:viewModel];
    
    [self setSelectedAssetViewModels:temp.array];
}
- (void)deselectAssetViewModel:(BBAssetsPickerAssetViewModel *)viewModel; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithArray:self.selectedAssetViewModels];
    
    [temp removeObject:viewModel];
    
    [self setSelectedAssetViewModels:temp.array];
}

- (RACSignal *)requestThumbnailImageWithSize:(CGSize)size; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        PHAsset *asset = nil;
        
        if ([self.assetsGroup isKindOfClass:[PHAssetCollection class]]) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            
            [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(PHAsset.new,creationDate) ascending:NO]]];
            
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)self.assetsGroup options:options];
            
            asset = result.firstObject;
        }
        
        if (asset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            
            [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
            [options setNetworkAccessAllowed:YES];
            
            PHImageRequestID requestID = [self.viewModel.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }];
            
            return [RACDisposable disposableWithBlock:^{
                @strongify(self);
                [self.viewModel.imageManager cancelImageRequest:requestID];
            }];
        }
        else {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }
    }];
}
#pragma mark Properties
- (NSString *)name {
    return self.assetsGroup.localizedTitle;
}
- (NSString *)estimatedAssetCountString {
    NSString *retval = nil;
    
    if ([self.assetsGroup isKindOfClass:[PHAssetCollection class]]) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)self.assetsGroup options:nil];
        NSUInteger count = result.count;
        
        retval = [NSString stringWithFormat:count == 1 ? NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_ASSETS_GROUP_VIEW_MODEL_ESTIMATED_ASSET_COUNT_FORMAT_SINGLE", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"%@ asset", @"assets picker assets group view model estimated asset count single") : NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_ASSETS_GROUP_VIEW_MODEL_ESTIMATED_ASSET_COUNT_FORMAT_MULTIPLE", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"%@ assets", @"assets picker assets group view model estimated asset count multiple"),@(count)];
    }
    
    return retval;
}

- (NSArray *)assetViewModels {
    if (!_assetViewModels) {
        [self reloadAssetViewModels];
    }
    return _assetViewModels;
}

@end
