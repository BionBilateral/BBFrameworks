//
//  BBMediaViewerModel.m
//  BBFrameworks
//
//  Created by William Towe on 8/8/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerViewModel.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBFrameworksFunctions.h"
#import "UIViewController+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <UIKit/UIKit.h>

@interface BBMediaViewerViewModel () <UIPopoverControllerDelegate>
@property (readwrite,copy,nonatomic) NSString *title;

@property (readwrite,strong,nonatomic) RACCommand *doneCommand;
@property (readwrite,strong,nonatomic) RACCommand *actionCommand;

@property (strong,nonatomic) UIPopoverController *popoverController;
@property (copy,nonatomic) void(^popoverCompletionBlock)(void);
@end

@implementation BBMediaViewerViewModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    @weakify(self);
    
    RACSignal *currentViewModelSignal = RACObserve(self, currentViewModel);
    
    RAC(self,title) = [RACSignal combineLatest:@[currentViewModelSignal,RACObserve(self, numberOfViewModels)] reduce:^id(BBMediaViewerDetailViewModel *viewModel, NSNumber *numberOfViewModels){
        return [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"MEDIA_VIEWER_TITLE_FORMAT", @"MediaViewer", BBFrameworksResourcesBundle(), @"%@ of %@", @"media viewer title format"),@(viewModel.index + 1),numberOfViewModels];
    }];
    
    [self setDoneCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [self setActionCommand:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[currentViewModelSignal] reduce:^id(BBMediaViewerDetailViewModel *viewModel){
        return @(viewModel.activityItem != nil);
    }] signalBlock:^RACSignal *(UIBarButtonItem *input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self setPopoverCompletionBlock:^{
                @strongify(self);
                [subscriber sendNext:self];
                [subscriber sendCompleted];
                
                [self setPopoverCompletionBlock:nil];
            }];
            
            UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.currentViewModel.activityItem] applicationActivities:nil];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [[UIViewController BB_viewControllerForPresenting] presentViewController:viewController animated:YES completion:self.popoverCompletionBlock];
            }
            else {
                if ([viewController respondsToSelector:@selector(popoverPresentationController)]) {
                    [viewController.popoverPresentationController setBarButtonItem:input];
                    
                    [[UIViewController BB_viewControllerForPresenting] presentViewController:viewController animated:YES completion:self.popoverCompletionBlock];
                }
                else {
                    [self setPopoverController:[[UIPopoverController alloc] initWithContentViewController:viewController]];
                    [self.popoverController setDelegate:self];
                    
                    [self.popoverController presentPopoverFromBarButtonItem:input permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
            return nil;
        }];
    }]];
    
    return self;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self setPopoverController:nil];
    
    self.popoverCompletionBlock();
}

@end
