//
//  BBMediaViewerPagePDFViewController.m
//  BBFrameworks
//
//  Created by William Towe on 3/1/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPagePDFViewController.h"
#import "BBMediaViewerPagePDFModel.h"
#import "BBMediaViewerPagePDFDetailViewController.h"
#import "BBMediaViewerPagePDFToolbarContentView.h"
#import "BBMediaViewerPagePDFDetailModel.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPagePDFViewController () <BBMediaViewerPagePDFModelDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) BBMediaViewerPagePDFToolbarContentView *PDFToolbarContentView;

@property (readwrite,strong,nonatomic) BBMediaViewerPagePDFModel *model;
@end

@implementation BBMediaViewerPagePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:@{UIPageViewControllerOptionInterPageSpacingKey: @8.0}]];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
    [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    [self.activityIndicatorView setColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.activityIndicatorView];
    
    [self setPDFToolbarContentView:[[BBMediaViewerPagePDFToolbarContentView alloc] initWithModel:self.model]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.pageViewController.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.pageViewController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.activityIndicatorView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.activityIndicatorView}]];
    
    [self.activityIndicatorView startAnimating];
    
    BBWeakify(self);
    [[[RACObserve(self.model, numberOfPages)
     filter:^BOOL(NSNumber *value) {
         return value.longValue > 0;
     }]
      deliverOnMainThread]
     subscribeNext:^(id _) {
         BBStrongify(self);
         [self.pageViewController setViewControllers:@[[[BBMediaViewerPagePDFDetailViewController alloc] initWithModel:[self.model pagePDFDetailForPage:0]]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         
         [self.activityIndicatorView stopAnimating];
     }];
}

- (void)mediaViewerPagePDFModel:(BBMediaViewerPagePDFModel *)model didSelectPage:(size_t)page {
    BBMediaViewerPagePDFDetailViewController *pageVC = self.pageViewController.viewControllers.firstObject;
    
    [self.pageViewController setViewControllers:@[[[BBMediaViewerPagePDFDetailViewController alloc] initWithModel:[self.model pagePDFDetailForPage:page]]] direction:page < pageVC.model.page ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BBMediaViewerPagePDFDetailViewController *pageVC = (BBMediaViewerPagePDFDetailViewController *)viewController;
    long page = pageVC.model.page;
    
    if ((++page) == self.model.numberOfPages) {
        return nil;
    }
    
    return [[BBMediaViewerPagePDFDetailViewController alloc] initWithModel:[self.model pagePDFDetailForPage:page]];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BBMediaViewerPagePDFDetailViewController *pageVC = (BBMediaViewerPagePDFDetailViewController *)viewController;
    long page = pageVC.model.page;
    
    if ((--page) < 0) {
        return nil;
    }
    
    return [[BBMediaViewerPagePDFDetailViewController alloc] initWithModel:[self.model pagePDFDetailForPage:page]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        BBMediaViewerPagePDFDetailViewController *pageVC = pageViewController.viewControllers.firstObject;
        
        [self.model selectPagePDFDetail:pageVC.model notifyDelegate:NO];
    }
}

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    _model = [[BBMediaViewerPagePDFModel alloc] initWithMedia:media parentModel:parentModel];
    [_model setDelegate:self];
    
    return self;
}

@synthesize model=_model;

- (UIView *)bottomToolbarContentView {
    return self.PDFToolbarContentView;
}

@end
