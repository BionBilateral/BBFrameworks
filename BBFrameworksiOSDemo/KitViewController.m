//
//  KitViewController.m
//  BBFrameworks
//
//  Created by William Towe on 5/25/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KitViewController.h"

#import <BBFrameworks/BBKit.h>

@interface KitViewController ()
@property (strong,nonatomic) UIButton *presentButton;
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) UIButton *dismissRecursivelyButton;
@end

@implementation KitViewController

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:BBColorRandomRGB()];
    
    [self setPresentButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.presentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.presentButton setTitle:@"Present" forState:UIControlStateNormal];
    [self.presentButton addTarget:self action:@selector(_presentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.presentButton];
    
    [self setDismissButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(_dismissButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    [self setDismissRecursivelyButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.dismissRecursivelyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dismissRecursivelyButton setTitle:@"Dismiss Recursively" forState:UIControlStateNormal];
    [self.dismissRecursivelyButton addTarget:self action:@selector(_dismissRecursivelyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissRecursivelyButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.presentButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-[subview]" options:0 metrics:nil views:@{@"subview": self.dismissButton, @"view": self.presentButton}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissRecursivelyButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"subview": self.dismissButton, @"view": self.dismissRecursivelyButton}]];
}

+ (NSString *)rowClassTitle {
    return @"Kit";
}

- (IBAction)_presentButtonAction:(id)sender {
    [self presentViewController:[[KitViewController alloc] init] animated:YES completion:nil];
}
- (IBAction)_dismissButtonAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)_dismissRecursivelyButtonAction:(id)sender {
    [self.presentingViewController BB_recursivelyDismissViewControllerAnimated:YES completion:nil];
}

@end
