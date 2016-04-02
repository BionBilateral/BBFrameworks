//
//  BBMediaViewerPageMovieView.m
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

#import "BBMediaViewerPageMovieView.h"
#import "BBMediaViewerPageMovieModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"
#import "BBMediaViewerTheme.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <AVFoundation/AVFoundation.h>

@interface BBMediaViewerPageMovieView ()
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (readonly,nonatomic) AVPlayerLayer *layer;

@property (strong,nonatomic) BBMediaViewerPageMovieModel *model;
@end

@implementation BBMediaViewerPageMovieView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@dynamic layer;

- (instancetype)initWithModel:(BBMediaViewerPageMovieModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.layer setPlayer:_model.player];
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
    [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.activityIndicatorView setColor:self.model.parentModel.theme.foregroundColor];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    [self addSubview:self.activityIndicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    BBWeakify(self);
    [[self.model.enabledSignal
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         if (value.boolValue) {
             [self.activityIndicatorView stopAnimating];
         }
         else {
             [self.activityIndicatorView startAnimating];
         }
     }];
    
    return self;
}

@end
