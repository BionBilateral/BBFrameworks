//
//  BBMediaViewerViewController.m
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

#import "BBMediaViewerViewController.h"
#import "BBMediaViewerTheme.h"
#import "BBMediaViewerContentViewController.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"
#import "UIView+BBKitExtensions.h"
#import "UIImage+BBKitExtensions.h"
#import "BBMediaViewerPageModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerViewController () <BBMediaViewerModelDataSource,BBMediaViewerModelDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
@property (strong,nonatomic) UIImageView *blurImageView;
@property (strong,nonatomic) BBMediaViewerContentViewController *contentVC;

@property (strong,nonatomic) BBMediaViewerModel *model;
@end

@implementation BBMediaViewerViewController
#pragma mark *** Subclass Overrides ***
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.delegate respondsToSelector:@selector(preferredStatusBarStyleForMediaViewerViewController:)]) {
        return [self.delegate preferredStatusBarStyleForMediaViewerViewController:self];
    }
    else {
        return UIStatusBarStyleDefault;
    }
}
- (BOOL)prefersStatusBarHidden {
    return self.contentVC.controlsHidden;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setTransitioningDelegate:self];
    
    _model = [[BBMediaViewerModel alloc] init];
    [_model setDataSource:self];
    [_model setDelegate:self];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setBlurImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.blurImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.blurImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.blurImageView setClipsToBounds:YES];
    [self.view addSubview:self.blurImageView];
    
    [self setContentVC:[[BBMediaViewerContentViewController alloc] initWithModel:self.model]];
    [self addChildViewController:self.contentVC];
    [self.contentVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.contentVC.view];
    [self.contentVC didMoveToParentViewController:self];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.blurImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.blurImageView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.contentVC.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.contentVC.view}]];
    
    BBWeakify(self);
    
    [[self.model.doneCommand.executionSignals
     concat]
     subscribeNext:^(id _) {
         BBStrongify(self);
         
         [self.delegate mediaViewerViewControllerDidFinish:self];
     }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
#pragma mark BBMediaViewerModelDataSource
- (NSInteger)numberOfMediaInMediaViewerModel:(BBMediaViewerModel *)model {
    return [self.dataSource numberOfMediaInMediaViewerViewController:self];
}
- (id<BBMediaViewerMedia>)mediaViewerModel:(BBMediaViewerModel *)model mediaAtIndex:(NSInteger)index {
    return [self.dataSource mediaViewerViewController:self mediaAtIndex:index];
}
#pragma mark BBMediaViewerModelDelegate
- (id<BBMediaViewerMedia>)initiallySelectedMediaForMediaViewerModel:(BBMediaViewerModel *)model {
    if ([self.delegate respondsToSelector:@selector(initiallySelectedMediaForMediaViewerViewController:)]) {
        return [self.delegate initiallySelectedMediaForMediaViewerViewController:self];
    }
    else {
        return [self.model mediaAtIndex:0];
    }
}

- (void)mediaViewerModel:(BBMediaViewerModel *)model didSelectMedia:(id<BBMediaViewerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:didSelectMedia:)]) {
        [self.delegate mediaViewerViewController:self didSelectMedia:media];
    }
}

- (NSURL *)mediaViewerModel:(BBMediaViewerModel *)model fileURLForMedia:(id<BBMediaViewerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:fileURLForMedia:)]) {
        return [self.delegate mediaViewerViewController:self fileURLForMedia:media];
    }
    return nil;
}
- (void)mediaViewerModel:(BBMediaViewerModel *)model downloadMedia:(id<BBMediaViewerMedia>)media completion:(BBMediaViewerDownloadCompletionBlock)completion {
    if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:downloadMedia:completion:)]) {
        [self.delegate mediaViewerViewController:self downloadMedia:media completion:completion];
    }
}

- (BOOL)mediaViewerModel:(BBMediaViewerModel *)model shouldRequestAssetForMedia:(id<BBMediaViewerMedia>)media {
    if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:shouldRequestAssetForMedia:)]) {
        return [self.delegate mediaViewerViewController:self shouldRequestAssetForMedia:media];
    }
    return NO;
}
- (AVAsset *)mediaViewerModel:(BBMediaViewerModel *)model assetForMedia:(id<BBMediaViewerMedia>)media {
    return [self.delegate mediaViewerViewController:self assetForMedia:media];
}
- (void)mediaViewerModel:(BBMediaViewerModel *)model createAssetForMedia:(id<BBMediaViewerMedia>)media completion:(BBMediaViewerCreateAssetCompletionBlock)completion {
    [self.delegate mediaViewerViewController:self createAssetForMedia:media completion:completion];
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
    return 0.4;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    BOOL isPresenting = [self.view isEqual:toView];
    
    if (isPresenting) {
        UIImage *blurImage = [[fromView BB_snapshotImageAfterScreenUpdates:YES] BB_imageByBlurringWithRadius:self.theme.transitionSnapshotBlurRadius];
        
        if (self.theme.transitionSnapshotTintColor != nil) {
            blurImage = [blurImage BB_imageByTintingWithColor:self.theme.transitionSnapshotTintColor];
        }
        
        [self.blurImageView setImage:blurImage];
        
        [containerView addSubview:toView];
        [toView setFrame:containerView.bounds];
    }
    else {
        [containerView insertSubview:toView atIndex:0];
        [toView setFrame:containerView.bounds];
    }
    
    if ([transitionContext isAnimated]) {
        [self.blurImageView setAlpha:0.0];
        
        CGRect finalFrame = CGRectZero;
        UIView *sourceView = nil;
        
        if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:frameForMedia:inSourceView:)]) {
            CGRect frame = [self.delegate mediaViewerViewController:self frameForMedia:self.model.selectedPageModel.media inSourceView:&sourceView];
            
            if (!CGRectIsEmpty(frame)) {
                if (sourceView != nil) {
                    frame = [sourceView.window convertRect:[sourceView convertRect:frame toView:nil] toWindow:nil];
                }
                
                finalFrame = [self.view convertRect:[self.view.window convertRect:frame fromWindow:nil] fromView:nil];
            }
        }
        
        UIView *snapshotView = [self.contentVC.view snapshotViewAfterScreenUpdates:YES];
        UIView *imageSnapshotView = nil;
        
        if ([self.delegate respondsToSelector:@selector(mediaViewerViewController:transitionViewForMedia:contentRect:)]) {
            CGRect contentRect = CGRectZero;
            UIView *transitionView = [self.delegate mediaViewerViewController:self transitionViewForMedia:self.model.selectedPageModel.media contentRect:&contentRect];
            
            if (CGRectIsEmpty(contentRect)) {
                imageSnapshotView = [transitionView snapshotViewAfterScreenUpdates:YES];
            }
            else {
                imageSnapshotView = [transitionView resizableSnapshotViewFromRect:contentRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
            }
        }
        
        [self.view addSubview:snapshotView];
        [snapshotView setFrame:isPresenting ? finalFrame : self.view.bounds];
        
        if (imageSnapshotView != nil) {
            [self.view addSubview:imageSnapshotView];
            [imageSnapshotView setFrame:isPresenting ? finalFrame : self.view.bounds];
        }
        
        if (isPresenting) {
            [snapshotView setAlpha:0.0];
            
            if (!CGRectIsEmpty(finalFrame)) {
                [snapshotView setFrame:finalFrame];
                [imageSnapshotView setFrame:finalFrame];
            }
        }
        else {
            [imageSnapshotView setAlpha:0.0];
        }
        
        if (!isPresenting) {
            [self.blurImageView setAlpha:1.0];
        }
        
        [self.contentVC.view setAlpha:0.0];
        
        BBWeakify(self);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            BBStrongify(self);
            [self.blurImageView setAlpha:isPresenting ? 1.0 : 0.0];
            [snapshotView setAlpha:isPresenting ? 1.0 : 0.0];
            [imageSnapshotView setAlpha:isPresenting ? 0.0 : 1.0];
            
            if (!CGRectIsEmpty(finalFrame)) {
                [snapshotView setFrame:isPresenting ? self.view.bounds : finalFrame];
                [imageSnapshotView setFrame:isPresenting ? self.view.bounds : finalFrame];
            }
        } completion:^(BOOL finished) {
            BBStrongify(self);
            if (isPresenting) {
                [self.contentVC.view setAlpha:1.0];
            }
            
            [snapshotView removeFromSuperview];
            [imageSnapshotView removeFromSuperview];
            
            if (!isPresenting) {
                [fromView removeFromSuperview];
            }
            
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [fromView removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }
}
#pragma mark *** Public Methods ***
- (void)reloadData; {
    [self.contentVC reloadData];
}
#pragma mark Properties
@dynamic theme;
- (BBMediaViewerTheme *)theme {
    return self.model.theme;
}
- (void)setTheme:(BBMediaViewerTheme *)theme {
    [self.model setTheme:theme];
}

@end
