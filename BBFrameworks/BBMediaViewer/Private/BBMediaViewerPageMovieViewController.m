//
//  BBMediaViewerPageMovieViewController.m
//  BBFrameworks
//
//  Created by William Towe on 2/29/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageMovieViewController.h"
#import "BBMediaViewerPageMovieModel.h"
#import "BBMediaViewerPageMovieView.h"
#import "BBMediaViewerPageMovieToolbarContentView.h"

@interface BBMediaViewerPageMovieViewController ()
@property (strong,nonatomic) BBMediaViewerPageMovieView *movieView;
@property (strong,nonatomic) BBMediaViewerPageMovieToolbarContentView *movieToolbarContentView;

@property (readwrite,strong,nonatomic) BBMediaViewerPageMovieModel *model;
@end

@implementation BBMediaViewerPageMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMovieView:[[BBMediaViewerPageMovieView alloc] initWithModel:self.model]];
    [self.movieView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.movieView];
    
    [self setMovieToolbarContentView:[[BBMediaViewerPageMovieToolbarContentView alloc] initWithModel:self.model]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.movieView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.movieView}]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.model setActive:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.model pause];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.model setActive:NO];
}

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    _model = [[BBMediaViewerPageMovieModel alloc] initWithMedia:media parentModel:parentModel];
    
    return self;
}

@synthesize model=_model;

- (UIView *)bottomToolbarContentView {
    return self.movieToolbarContentView;
}

@end
