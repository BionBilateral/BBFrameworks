//
//  BBMediaPickerAssetCollectionsViewController.m
//  BBFrameworks
//
//  Created by William Towe on 11/13/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionsViewController.h"
#import "BBMediaPickerAssetCollectionsTableViewController.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerTheme.h"
#import "BBFoundationDebugging.h"
#import "BBMediaPickerAssetCollectionPopoverView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionsViewController () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIView *backgroundView;
@property (strong,nonatomic) BBMediaPickerAssetCollectionPopoverView *popoverView;
@property (strong,nonatomic) BBMediaPickerAssetCollectionsTableViewController *tableViewController;

@property (strong,nonatomic) BBMediaPickerModel *model;

@property (assign,nonatomic) BOOL didAnimatePresentingTransition;
@property (weak,nonatomic) UINavigationController *sourceNavigationController;
@end

@implementation BBMediaPickerAssetCollectionsViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSString *)title {
    return @"Album";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.backgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.backgroundView];
    
    [self setPopoverView:[[BBMediaPickerAssetCollectionPopoverView alloc] initWithFrame:CGRectZero]];
    [self.popoverView setTheme:self.model.theme];
    [self.view addSubview:self.popoverView];
    
    [self setTableViewController:[[BBMediaPickerAssetCollectionsTableViewController alloc] initWithModel:self.model]];
    [self addChildViewController:self.tableViewController];
    [self.popoverView setContentView:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
    
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
- (void)viewDidLayoutSubviews {
    [self.backgroundView setFrame:self.view.bounds];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !CGRectContainsPoint(self.popoverView.bounds, [touch locationInView:self.popoverView]);
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    [self setSourceNavigationController:source.navigationController];
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGFloat damping = 0.5;
    
    // presenting
    if ([toView isEqual:self.view]) {
        [containerView addSubview:toView];
        
        [toView setFrame:containerView.bounds];
        
        CGFloat availableHeight = CGRectGetHeight(toView.bounds) - CGRectGetHeight(self.sourceNavigationController.navigationBar.frame) - [self.topLayoutGuide length];
        CGFloat maximumPopoverHeight = ceil(availableHeight * 0.66);
        CGFloat popoverY = CGRectGetHeight(self.sourceNavigationController.navigationBar.frame) + [self.topLayoutGuide length];
        CGRect popoverRect = CGRectMake(0, popoverY, CGRectGetWidth(toView.bounds), [self.popoverView sizeThatFits:CGSizeMake(CGRectGetWidth(toView.bounds), maximumPopoverHeight)].height);
        
        [self.popoverView setFrame:popoverRect];
        [self.popoverView setAlpha:0.0];
        [self.popoverView setTransform:CGAffineTransformMakeScale(0.25, 0.25)];
        
        if ([transitionContext isAnimated]) {
            [self setDidAnimatePresentingTransition:YES];
            
            [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
                    [self.backgroundView setBackgroundColor:[self.model.theme.assetCollectionBackgroundColor colorWithAlphaComponent:0.33]];
                }];
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.popoverView setTransform:CGAffineTransformIdentity];
                    [self.popoverView setAlpha:1.0];
                } completion:nil];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext completeTransition:YES];
        }
    }
    // dismissing
    else {
        if ([transitionContext isAnimated]) {
            [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.backgroundView setBackgroundColor:[UIColor clearColor]];
                [self.popoverView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext completeTransition:YES];
        }
    }
}

- (instancetype)initWithModel:(BBMediaPickerModel *)model {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:model];
    [self setTransitioningDelegate:self];
    
    return self;
}

- (IBAction)_tapGestureRecognizerAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:self.didAnimatePresentingTransition completion:nil];
}

@end
