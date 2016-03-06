//
//  BBMediaViewerContentViewController.m
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

#import "BBMediaViewerContentViewController.h"
#import "BBMediaViewerTheme.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"
#import "BBMediaViewerPageViewController.h"
#import "BBMediaViewerPageModel.h"
#import "BBMediaViewerBottomToolbar.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerContentViewController () <UINavigationBarDelegate,UIToolbarDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) UINavigationBar *navigationBar;
@property (strong,nonatomic) BBMediaViewerBottomToolbar *toolbar;

@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong,nonatomic) BBMediaViewerModel *model;

- (void)_setControlsHidden:(BOOL)controlsHidden animated:(BOOL)animated;
- (void)_setBottomToolbarHidden:(BOOL)bottomToolbarHidden animated:(BOOL)animated;
@end

@implementation BBMediaViewerContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar:[[UINavigationBar alloc] initWithFrame:CGRectZero]];
    [self.navigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navigationBar setDelegate:self];
    [self.view addSubview:self.navigationBar];
    
    [self setToolbar:[[BBMediaViewerBottomToolbar alloc] initWithFrame:CGRectZero]];
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.toolbar];
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @8.0}]];
    
    id<BBMediaViewerMedia> firstMedia = [self.model mediaAtIndex:0];
    BBMediaViewerPageViewController *firstPageVC = [[BBMediaViewerPageViewController alloc] initWithMedia:firstMedia parentModel:self.model];
    
    [self.model selectPageModel:firstPageVC.model notifyDelegate:NO];
    
    BBWeakify(self);
    [self.pageViewController setViewControllers:@[firstPageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.pageViewController.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.pageViewController.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.navigationBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][view]" options:0 metrics:nil views:@{@"top": self.topLayoutGuide, @"view": self.navigationBar}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.toolbar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view][bottom]" options:0 metrics:nil views:@{@"view": self.toolbar, @"bottom": self.bottomLayoutGuide}]];
    
    [self.toolbar setContentView:firstPageVC.bottomToolbarContentView];
    
    [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL]];
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    RAC(self,title) =
    [RACObserve(self.model, title)
     deliverOnMainThread];
    
    [self.navigationBar setItems:@[self.navigationItem]];
    
    [[[RACObserve(self.model, theme.backgroundColor)
     ignore:nil]
     deliverOnMainThread]
     subscribeNext:^(UIColor *value) {
         BBStrongify(self);
         [self.view setBackgroundColor:value];
     }];
    
    [[[RACObserve(self.model, theme.doneBarButtonItem)
     ignore:nil]
     deliverOnMainThread]
     subscribeNext:^(UIBarButtonItem *value) {
         BBStrongify(self);
         
         [value setRac_command:self.model.doneCommand];
         
         [self.navigationItem setLeftBarButtonItems:@[value]];
     }];
    
    [[[RACObserve(self.model, theme.actionBarButtonItem)
     ignore:nil]
     deliverOnMainThread]
     subscribeNext:^(UIBarButtonItem *value) {
         BBStrongify(self);
         
         [value setRac_command:self.model.actionCommand];
         
         [self.navigationItem setRightBarButtonItems:@[value]];
     }];
    
    [[self.tapGestureRecognizer
      rac_gestureSignal]
     subscribeNext:^(id _) {
         BBStrongify(self);
         BOOL isHidden = self.navigationBar.alpha == 0.0;
         
         [self _setControlsHidden:!isHidden animated:YES];
     }];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (!CGRectContainsPoint(self.navigationBar.bounds, [touch locationInView:self.navigationBar]) &&
            !CGRectContainsPoint(self.toolbar.bounds, [touch locationInView:self.toolbar]));
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
            [(UITapGestureRecognizer *)otherGestureRecognizer numberOfTapsRequired] == 2);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BBMediaViewerPageViewController *pageVC = (BBMediaViewerPageViewController *)viewController;
    NSInteger index = [self.model indexOfMedia:pageVC.model.media];
    
    if ((++index) == [self.model numberOfMedia]) {
        return nil;
    }
    
    return [[BBMediaViewerPageViewController alloc] initWithMedia:[self.model mediaAtIndex:index] parentModel:self.model];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BBMediaViewerPageViewController *pageVC = (BBMediaViewerPageViewController *)viewController;
    NSInteger index = [self.model indexOfMedia:pageVC.model.media];
    
    if ((--index) < 0) {
        return nil;
    }
    
    return [[BBMediaViewerPageViewController alloc] initWithMedia:[self.model mediaAtIndex:index] parentModel:self.model];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [self _setBottomToolbarHidden:YES animated:YES];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self _setBottomToolbarHidden:NO animated:YES];
    
    if (completed) {
        BBMediaViewerPageViewController *pageVC = pageViewController.viewControllers.firstObject;
        
        [self.model selectPageModel:pageVC.model];
        
        [self.toolbar setContentView:pageVC.bottomToolbarContentView];
    }
}

- (instancetype)initWithModel:(BBMediaViewerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    return self;
}

- (void)_setControlsHidden:(BOOL)controlsHidden animated:(BOOL)animated; {
    void(^block)(void) = ^{
        [self.navigationBar setAlpha:controlsHidden ? 0.0 : 1.0];
        [self _setBottomToolbarHidden:controlsHidden animated:NO];
    };
    
    if (animated) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:block completion:nil];
    }
    else {
        block();
    }
}
- (void)_setBottomToolbarHidden:(BOOL)bottomToolbarHidden animated:(BOOL)animated; {
    void(^block)(void) = ^{
        [self.toolbar setAlpha:bottomToolbarHidden ? 0.0 : 1.0];
    };
    
    if (animated) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:block completion:nil];
    }
    else {
        block();
    }
}

@end
