//
//  BBMediaViewerModel.m
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerModel.h"
#import "BBMediaViewerTheme.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerPageModel.h"
#import "BBFrameworksFunctions.h"
#import "UIViewController+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerModel ()
@property (readwrite,copy,nonatomic) NSString *title;
@property (readwrite,strong,nonatomic) RACCommand *doneCommand;
@property (readwrite,strong,nonatomic) RACCommand *actionCommand;

@property (readwrite,strong,nonatomic) BBMediaViewerPageModel *selectedPageModel;
@end

@implementation BBMediaViewerModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _theme = [BBMediaViewerTheme defaultTheme];
    
    BBWeakify(self);
    
    _doneCommand =
    [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        BBStrongify(self);
        return [RACSignal return:self];
    }];
    
    _actionCommand =
    [[RACCommand alloc] initWithEnabled:[RACObserve(self, selectedPageModel) map:^id(BBMediaViewerPageModel *value) {
        return @(value.activityItem != nil);
    }] signalBlock:^RACSignal *(id input) {
        BBStrongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.selectedPageModel.activityItem] applicationActivities:nil];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [[UIViewController BB_viewControllerForPresenting] presentViewController:viewController animated:YES completion:nil];
            }
            else {
                [viewController.popoverPresentationController setBarButtonItem:input];
                
                [[UIViewController BB_viewControllerForPresenting] presentViewController:viewController animated:YES completion:nil];
            }
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    RAC(self,title) =
    [[[RACSignal combineLatest:@[[RACObserve(self, selectedPageModel) ignore:nil],
                                 [RACObserve(self, selectedPageModel.title) ignore:nil]]]
      ignore:nil]
     map:^id(RACTuple *value) {
         BBStrongify(self);
         RACTupleUnpack(BBMediaViewerPageModel *model, NSString *title) = value;
         return [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MEDIA_VIEWER_TITLE_FORMAT", @"MediaViewer", BBFrameworksResourcesBundle(), @"%@ (%@ of %@)", @"media viewer title format"),title,[NSNumberFormatter localizedStringFromNumber:@([self indexOfMedia:model.media] + 1) numberStyle:NSNumberFormatterDecimalStyle],[NSNumberFormatter localizedStringFromNumber:@(self.numberOfMedia) numberStyle:NSNumberFormatterDecimalStyle]];
     }];
    
    return self;
}

- (NSInteger)numberOfMedia; {
    return [self.dataSource numberOfMediaInMediaViewerModel:self];
}
- (id<BBMediaViewerMedia>)mediaAtIndex:(NSInteger)index; {
    return [self.dataSource mediaViewerModel:self mediaAtIndex:index];
}
- (NSInteger)indexOfMedia:(id<BBMediaViewerMedia>)media; {
    NSInteger retval = NSNotFound;
    
    for (NSInteger i=0; i<[self numberOfMedia]; i++) {
        id<BBMediaViewerMedia> m = [self mediaAtIndex:i];
        
        if ([m isEqual:media]) {
            retval = i;
            break;
        }
    }
    
    return retval;
}

- (NSURL *)fileURLForMedia:(id<BBMediaViewerMedia>)media; {
    return [self.delegate mediaViewerModel:self fileURLForMedia:media];
}
- (void)downloadMedia:(id<BBMediaViewerMedia>)media completion:(BBMediaViewerDownloadCompletionBlock)completion; {
    [self.delegate mediaViewerModel:self downloadMedia:media completion:completion];
}

- (void)selectPageModel:(BBMediaViewerPageModel *)pageModel; {
    [self setSelectedPageModel:pageModel];
}

- (void)setTheme:(BBMediaViewerTheme *)theme {
    _theme = theme ?: [BBMediaViewerTheme defaultTheme];
}

@end
