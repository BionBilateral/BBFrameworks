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

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerContentViewController () <UINavigationBarDelegate,UIToolbarDelegate,UIPageViewControllerDataSource>
@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) UINavigationBar *navigationBar;
@property (strong,nonatomic) UIToolbar *toolbar;

@property (strong,nonatomic) BBMediaViewerModel *model;

- (NSInteger)_indexOfMedia:(id<BBMediaViewerMedia>)media;
@end

@implementation BBMediaViewerContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar:[[UINavigationBar alloc] initWithFrame:CGRectZero]];
    [self.navigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navigationBar setDelegate:self];
    [self.view addSubview:self.navigationBar];
    
    [self setToolbar:[[UIToolbar alloc] initWithFrame:CGRectZero]];
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.toolbar setDelegate:self];
    [self.view addSubview:self.toolbar];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.navigationBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][view]" options:0 metrics:nil views:@{@"top": self.topLayoutGuide, @"view": self.navigationBar}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.toolbar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view][bottom]" options:0 metrics:nil views:@{@"view": self.toolbar, @"bottom": self.bottomLayoutGuide}]];
    
    [self.navigationBar setItems:@[self.navigationItem]];
    
    BBWeakify(self);
    
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
         
         [self.navigationItem setRightBarButtonItems:@[value]];
     }];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return [bar isEqual:self.navigationBar] ? UIBarPositionTopAttached : UIBarPositionBottom;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (instancetype)initWithModel:(BBMediaViewerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    return self;
}

- (NSInteger)_indexOfMedia:(id<BBMediaViewerMedia>)media; {
    NSInteger retval = NSNotFound;
    
    
    return retval;
}

@end
