//
//  BBMediaViewerMovieViewController.m
//  BBFrameworks
//
//  Created by William Towe on 8/10/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerMovieViewController.h"
#import "BBMediaViewerMovieView.h"
#import "BBMediaViewerDetailViewModel.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIBarButtonItem+BBKitExtensions.h"
#import "UIImage+BBKitExtensions.h"
#import "BBKitColorMacros.h"
#import "BBFoundationDebugging.h"
#import "BBMediaViewerMovieSliderContainerView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

@interface BBMediaViewerMovieViewController ()
@property (strong,nonatomic) BBMediaViewerMovieView *movieView;
@property (strong,nonatomic) BBMediaViewerMovieSliderContainerView *slider;

@property (strong,nonatomic) id timeObserver;
@end

@implementation BBMediaViewerMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMovieView:[[BBMediaViewerMovieView alloc] initWithViewModel:self.viewModel]];
    [self.view addSubview:self.movieView];
    
    UIButton *playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [playPauseButton setAdjustsImageWhenHighlighted:NO];
    
    [playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_play"] BB_imageByTintingWithColor:BBColorWA(0.0, 0.33)] forState:UIControlStateNormal|UIControlStateHighlighted];
    [playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [playPauseButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_pause"] BB_imageByTintingWithColor:BBColorWA(0.0, 0.33)] forState:UIControlStateSelected|UIControlStateHighlighted];
    [playPauseButton sizeToFit];
    
    [playPauseButton setRac_command:self.viewModel.playPauseCommand];
    
    RAC(playPauseButton,selected) = [RACObserve(self.viewModel.player, rate)
                                     map:^id(NSNumber *value) {
                                         return @(value.floatValue != 0.0);
                                     }];
    
    [self setSlider:[[BBMediaViewerMovieSliderContainerView alloc] initWithViewModel:self.viewModel]];
    [self.view addSubview:self.slider];
    
    [self setAdditionalToolbarItems:@[[[UIBarButtonItem alloc] initWithCustomView:playPauseButton]]];
}
- (void)viewWillLayoutSubviews {
    [self.movieView setFrame:self.view.bounds];
    [self.slider setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - [self.slider sizeThatFits:CGSizeZero].height - [self.bottomLayoutGuide length] - 8.0, CGRectGetWidth(self.view.bounds), [self.slider sizeThatFits:CGSizeZero].height)];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.navigationController.isBeingPresented &&
        !self.navigationController.isBeingDismissed) {
        
        [self.viewModel stop];
    }
}

@end
