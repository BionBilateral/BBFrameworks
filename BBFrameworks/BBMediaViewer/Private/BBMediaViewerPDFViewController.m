//
//  BBMediaViewerPDFViewController.m
//  BBFrameworks
//
//  Created by William Towe on 11/21/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPDFViewController.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBMediaViewerPDFPageViewController.h"
#import "BBMediaViewerPDFThumbnailContainerView.h"
#import "BBMediaViewerPDFPageIndicatorView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPDFViewController () <BBMediaViewerPDFThumbnailContainerViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) BBMediaViewerPDFThumbnailContainerView *PDFThumbnailContainerView;
@property (strong,nonatomic) BBMediaViewerPDFPageIndicatorView *pageIndicatorView;

- (void)_updateSelectedPageNumber;
- (void)_fadeOutPageIndicatorView;
@end

@implementation BBMediaViewerPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:@{UIPageViewControllerOptionInterPageSpacingKey: @8.0}]];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    
    [self setPageIndicatorView:[[BBMediaViewerPDFPageIndicatorView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.pageIndicatorView];
    
    [self setPDFThumbnailContainerView:[[BBMediaViewerPDFThumbnailContainerView alloc] initWithViewModel:self.viewModel]];
    [self.PDFThumbnailContainerView setDelegate:self];
    
    [self setBottomContentView:self.PDFThumbnailContainerView];
    
    @weakify(self);
    [self.pageViewController setViewControllers:@[[[BBMediaViewerPDFPageViewController alloc] initWithPDFPageRef:[self.viewModel PDFPageRefForPageNumber:1] pageNumber:1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        @strongify(self);
        [self _updateSelectedPageNumber];
    }];
}
- (void)viewWillLayoutSubviews {
    [self.pageViewController.view setFrame:self.view.bounds];
    
    CGSize size = [self.pageIndicatorView sizeThatFits:CGSizeZero];
    
    [self.pageIndicatorView setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 44.0 + 8.0, size.width, size.height)];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.isBeingPresented &&
        !self.isBeingDismissed) {
        
        // reset to first page
        @weakify(self);
        [self.pageViewController setViewControllers:@[[[BBMediaViewerPDFPageViewController alloc] initWithPDFPageRef:[self.viewModel PDFPageRefForPageNumber:1] pageNumber:1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            @strongify(self);
            [self _updateSelectedPageNumber];
        }];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    size_t pageNumber = [(BBMediaViewerPDFPageViewController *)viewController pageNumber];
    
    if ((++pageNumber) > self.viewModel.numberOfPDFPages) {
        return nil;
    }
    
    return [[BBMediaViewerPDFPageViewController alloc] initWithPDFPageRef:[self.viewModel PDFPageRefForPageNumber:pageNumber] pageNumber:pageNumber];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    size_t pageNumber = [(BBMediaViewerPDFPageViewController *)viewController pageNumber];
    
    if ((--pageNumber) == 0) {
        return nil;
    }
    
    return [[BBMediaViewerPDFPageViewController alloc] initWithPDFPageRef:[self.viewModel PDFPageRefForPageNumber:pageNumber] pageNumber:pageNumber];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.pageIndicatorView setAlpha:1.0];
    } completion:nil];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self _updateSelectedPageNumber];
}

- (void)PDFThumbnailContainerView:(BBMediaViewerPDFThumbnailContainerView *)view didSelectPage:(size_t)page {
    @weakify(self);
    [self.pageViewController setViewControllers:@[[[BBMediaViewerPDFPageViewController alloc] initWithPDFPageRef:[self.viewModel PDFPageRefForPageNumber:page] pageNumber:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        @strongify(self);
        [self _updateSelectedPageNumber];
    }];
}

- (void)_updateSelectedPageNumber; {
    size_t pageNumber = [(BBMediaViewerPDFPageViewController *)self.pageViewController.viewControllers.firstObject pageNumber];
    
    [self.PDFThumbnailContainerView updateSelectedPage:pageNumber];
    
    [self.pageIndicatorView setCurrentPage:pageNumber];
    [self.pageIndicatorView setNumberOfPages:self.viewModel.numberOfPDFPages];
    
    [self _fadeOutPageIndicatorView];
}
- (void)_fadeOutPageIndicatorView; {
    [UIView animateWithDuration:0.25 delay:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.pageIndicatorView setAlpha:0.0];
    } completion:nil];
}

@end
