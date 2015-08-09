//
//  BBMediaBrowserViewController.m
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

#import "BBMediaViewerViewController.h"
#import "BBMediaViewerDetailViewController.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBMediaViewerViewModel.h"
#import "UIBarButtonItem+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIPageViewController *pageViewController;

@property (strong,nonatomic) BBMediaViewerViewModel *viewModel;

@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation BBMediaViewerViewController

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewModel:[[BBMediaViewerViewModel alloc] init]];
    
    RAC(self,title) = RACObserve(self.viewModel, title);
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @20.0}]];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.pageViewController.view setBackgroundColor:[UIColor blackColor]];
    
    [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL]];
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.tapGestureRecognizer setDelegate:self];
    [self.pageViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    
    id<BBMediaViewerMedia> media = nil;
    NSInteger index = 0;
    
    if ([self.dataSource respondsToSelector:@selector(initialMediaForMediaViewer:)]) {
        media = [self.dataSource initialMediaForMediaViewer:self];
        
        for (NSInteger i=0; i<[self.dataSource numberOfMediaInMediaViewer:self]; i++) {
            id<BBMediaViewerMedia> m = [self.dataSource mediaViewer:self mediaAtIndex:i];
            
            if ([m isEqual:media]) {
                index = i;
                break;
            }
        }
    }
    else {
        media = [self.dataSource mediaViewer:self mediaAtIndex:0];
    }
    
    @weakify(self);
    [self.pageViewController setViewControllers:@[[[BBMediaViewerDetailViewController alloc] initWithViewModel:[[BBMediaViewerDetailViewModel alloc] initWithMedia:media index:index]]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        @strongify(self);
        
        BBMediaViewerDetailViewController *viewController = self.pageViewController.viewControllers.firstObject;
        
        [self.viewModel setCurrentViewModel:viewController.viewModel];
    }];
    
    [[self.tapGestureRecognizer
      rac_gestureSignal]
    subscribeNext:^(id _) {
        @strongify(self);
        [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
        [self.navigationController setToolbarHidden:!self.navigationController.isToolbarHidden animated:YES];
    }];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    
    [doneItem setRac_command:self.viewModel.doneCommand];
    
    [self.navigationItem setRightBarButtonItems:@[doneItem]];
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:NULL];
    
    [actionItem setRac_command:self.viewModel.actionCommand];
    
    [self setToolbarItems:@[[UIBarButtonItem BB_flexibleSpaceBarButtonItem],actionItem]];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [[[self.viewModel.doneCommand.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         if ([self.delegate respondsToSelector:@selector(mediaViewerWillDismiss:)]) {
             [self.delegate mediaViewerWillDismiss:self];
         }
         
         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
             @strongify(self);
             if ([self.delegate respondsToSelector:@selector(mediaViewerDidDismiss:)]) {
                 [self.delegate mediaViewerDidDismiss:self];
             }
         }];
     }];
}
- (void)viewWillLayoutSubviews {
    [self.pageViewController.view setFrame:self.view.bounds];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
            [(UITapGestureRecognizer *)otherGestureRecognizer numberOfTapsRequired] == 2);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BBMediaViewerDetailViewModel *viewModel = [(BBMediaViewerDetailViewController *)viewController viewModel];
    NSInteger index = viewModel.index;
    
    if ((++index) == [self.dataSource numberOfMediaInMediaViewer:self]) {
        return nil;
    }
    
    id<BBMediaViewerMedia> media = [self.dataSource mediaViewer:self mediaAtIndex:index];
    
    return [[BBMediaViewerDetailViewController alloc] initWithViewModel:[[BBMediaViewerDetailViewModel alloc] initWithMedia:media index:index]];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BBMediaViewerDetailViewModel *viewModel = [(BBMediaViewerDetailViewController *)viewController viewModel];
    NSInteger index = viewModel.index;
    
    if ((--index) < 0) {
        return nil;
    }
    
    id<BBMediaViewerMedia> media = [self.dataSource mediaViewer:self mediaAtIndex:index];
    
    return [[BBMediaViewerDetailViewController alloc] initWithViewModel:[[BBMediaViewerDetailViewModel alloc] initWithMedia:media index:index]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        BBMediaViewerDetailViewController *viewController = pageViewController.viewControllers.firstObject;
        
        [self.viewModel setCurrentViewModel:viewController.viewModel];
    }
}

- (void)setDataSource:(id<BBMediaViewerViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (_dataSource) {
        [self.viewModel setNumberOfViewModels:[_dataSource numberOfMediaInMediaViewer:self]];
    }
}

@end
