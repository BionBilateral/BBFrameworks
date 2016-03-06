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

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerViewController () <BBMediaViewerModelDataSource,BBMediaViewerModelDelegate>
@property (strong,nonatomic) BBMediaViewerContentViewController *contentVC;

@property (strong,nonatomic) BBMediaViewerModel *model;
@end

@implementation BBMediaViewerViewController

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _model = [[BBMediaViewerModel alloc] init];
    [_model setDataSource:self];
    [_model setDelegate:self];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContentVC:[[BBMediaViewerContentViewController alloc] initWithModel:self.model]];
    [self addChildViewController:self.contentVC];
    [self.contentVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.contentVC.view];
    [self.contentVC didMoveToParentViewController:self];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.contentVC.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.contentVC.view}]];
    
    BBWeakify(self);
    
    [[RACObserve(self.model, theme.backgroundColor)
     deliverOnMainThread]
     subscribeNext:^(UIColor *value) {
         BBStrongify(self);
         [self.view setBackgroundColor:value];
     }];
    
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

- (NSInteger)numberOfMediaInMediaViewerModel:(BBMediaViewerModel *)model {
    return [self.dataSource numberOfMediaInMediaViewerViewController:self];
}
- (id<BBMediaViewerMedia>)mediaViewerModel:(BBMediaViewerModel *)model mediaAtIndex:(NSInteger)index {
    return [self.dataSource mediaViewerViewController:self mediaAtIndex:index];
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

@dynamic theme;
- (BBMediaViewerTheme *)theme {
    return self.model.theme;
}
- (void)setTheme:(BBMediaViewerTheme *)theme {
    [self.model setTheme:theme];
}

@end
