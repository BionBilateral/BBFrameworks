//
//  BBMoviePlayerEmbeddedBottomView.m
//  BBFrameworks
//
//  Created by William Towe on 6/25/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMoviePlayerEmbeddedBottomView.h"
#import "BBMoviePlayerController.h"

CGFloat const BBMoviePlayerEmbeddedBottomViewHeight = 44.0;

@interface BBMoviePlayerEmbeddedBottomView ()
@property (strong,nonatomic) UIVisualEffectView *visualEffectView;

@property (weak,nonatomic) BBMoviePlayerController *moviePlayerController;
@end

@implementation BBMoviePlayerEmbeddedBottomView

- (instancetype)initWithMoviePlayerController:(BBMoviePlayerController *)moviePlayerController; {
    if (!(self = [super init]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setMoviePlayerController:moviePlayerController];
    
    [self setVisualEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]];
    [self.visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.visualEffectView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.visualEffectView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.visualEffectView}]];
    
    return self;
}

@end
