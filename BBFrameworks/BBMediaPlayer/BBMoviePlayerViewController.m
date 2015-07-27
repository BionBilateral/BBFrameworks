//
//  BBMoviePlayerViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/26/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerViewController.h"
#import "BBMoviePlayerController.h"
#import "BBMoviePlayerView.h"
#import "BBFoundation.h"

static NSTimeInterval const kTransitionDuration = 1.0;

@interface BBMoviePlayerViewController () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
@property (readwrite,strong,nonatomic) BBMoviePlayerController *moviePlayerController;
@property (weak,nonatomic) BBMoviePlayerController *fromMoviePlayerController;
@property (strong,nonatomic) UIView *moviePlayerView;

- (void)_BBMoviePlayerViewControllerInit;
@end

@implementation BBMoviePlayerViewController
#pragma mark *** Subclass Overrides ***
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self _BBMoviePlayerViewControllerInit];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.fromMoviePlayerController) {
        [self setMoviePlayerView:[[BBMoviePlayerView alloc] initWithMoviePlayerController:self.moviePlayerController]];
    }
    else {
        [self setMoviePlayerView:self.moviePlayerController.view];
    }
    [self.view addSubview:self.moviePlayerView];
}
- (void)viewDidLayoutSubviews {
    if (self.isBeingDismissed ||
        self.isBeingPresented) {
        return;
    }
    
    [self.moviePlayerView setFrame:self.view.bounds];
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}
#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTransitionDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // presenting
    if (toView == self.view) {
        [containerView addSubview:toView];

        [toView setFrame:containerView.bounds];
        
        [self.moviePlayerView setFrame:[containerView convertRect:self.fromMoviePlayerController.view.bounds fromView:self.fromMoviePlayerController.view]];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.moviePlayerView setFrame:containerView.bounds];
            [self.view setBackgroundColor:[UIColor blackColor]];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    // dismissing
    else {
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        [toView setFrame:containerView.bounds];
        [fromView setFrame:containerView.bounds];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.moviePlayerView setFrame:[containerView convertRect:self.fromMoviePlayerController.view.bounds fromView:self.fromMoviePlayerController.view]];
            [self.view setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}
#pragma mark *** Private Methods ***
- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super init]))
        return nil;
    
    [self setFromMoviePlayerController:moviePlayerController];
    
    [self setTransitioningDelegate:self];
    
    [self _BBMoviePlayerViewControllerInit];
    
    return self;
}

- (void)_BBMoviePlayerViewControllerInit; {
    if (self.fromMoviePlayerController) {
        [self setMoviePlayerController:self.fromMoviePlayerController];
    }
    else {
        [self setMoviePlayerController:[[BBMoviePlayerController alloc] init]];
    }
}

@end
