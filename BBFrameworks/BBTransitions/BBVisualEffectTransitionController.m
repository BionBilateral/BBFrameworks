//
//  BBVisualEffectTransitionController.m
//  BBFrameworks
//
//  Created by William Towe on 7/25/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBVisualEffectTransitionController.h"

@interface BBVisualEffectTransitionController ()
@property (readonly,nonatomic) UIVisualEffectView *blurVisualEffectView;
@property (strong,nonatomic) UIVisualEffectView *vibrancyVisualEffectView;

@property (strong,nonatomic) UIViewController *viewController;

@property (assign,nonatomic) UIBlurEffectStyle blurEffectStyle;
@end

@implementation BBVisualEffectTransitionController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}

- (void)loadView {
    [self setView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.blurEffectStyle]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVibrancyVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.blurVisualEffectView.effect]]];
    [self.blurVisualEffectView.contentView addSubview:self.vibrancyVisualEffectView];
    
    [self addChildViewController:self.viewController];
    [self.vibrancyVisualEffectView.contentView addSubview:self.viewController.view];
    [self.viewController didMoveToParentViewController:self];
}
- (void)viewDidLayoutSubviews {
    [self.vibrancyVisualEffectView setFrame:self.view.bounds];
    [self.viewController.view setFrame:self.view.bounds];
}

- (instancetype)initWithViewController:(UIViewController *)viewController blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(viewController);
    
    [self setViewController:viewController];
    [self setBlurEffectStyle:blurEffectStyle];
    
    return self;
}

- (UIVisualEffectView *)blurVisualEffectView {
    return (UIVisualEffectView *)self.view;
}

@end
