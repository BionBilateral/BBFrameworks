//
//  BBMoviePlayerView.m
//  BBFrameworks
//
//  Created by William Towe on 6/24/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerView.h"
#import "BBMoviePlayerController.h"
#import "BBMoviePlayerContentView.h"
#import "BBMoviePlayerEmbeddedBottomView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMoviePlayerView ()
@property (readwrite,strong,nonatomic) UIView *backgroundView;
@property (readwrite,strong,nonatomic) BBMoviePlayerContentView *contentView;
@property (strong,nonatomic) BBMoviePlayerEmbeddedBottomView *embeddedBottomView;

@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerView

- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setMoviePlayerController:moviePlayerController];
    
    [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backgroundView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.backgroundView];
    
    [self setContentView:[[BBMoviePlayerContentView alloc] initWithMoviePlayerController:self.moviePlayerController]];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.contentView];
    
    [self setEmbeddedBottomView:[[BBMoviePlayerEmbeddedBottomView alloc] initWithMoviePlayerController:self.moviePlayerController]];
    [self.embeddedBottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.embeddedBottomView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.contentView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.contentView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.embeddedBottomView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|" options:0 metrics:nil views:@{@"view": self.embeddedBottomView}]];
    
    [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    @weakify(self);
    [[[self.tapGestureRecognizer
     rac_gestureSignal]
      deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(id _) {
          @strongify(self);
          [self.embeddedBottomView setHidden:!self.embeddedBottomView.isHidden];
      }];
    
    return self;
}

@end
