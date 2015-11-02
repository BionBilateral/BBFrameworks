//
//  BBProgressNavigationBar.m
//  BBFrameworks
//
//  Created by William Towe on 6/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBProgressNavigationBar.h"
#import "BBFrameworksMacros.h"

static NSString *const kProgressHiddenKeyPath = @"progressHidden";
static NSString *const kProgressKeyPath = @"progress";

@interface BBProgressNavigationBar ()
@property (strong,nonatomic) UIProgressView *progressView;

- (void)_BBProgressNavigationBarInit;
@end

@implementation BBProgressNavigationBar

#pragma mark ** Subclass Overrides **
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBProgressNavigationBarInit];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBProgressNavigationBarInit];
    
    return self;
}

- (void)didAddSubview:(UIView *)subview {
    [self bringSubviewToFront:self.progressView];
}
#pragma mark ** Public Methods **
#pragma mark Properties
@dynamic progressHidden;
- (BOOL)isProgressHidden {
    return self.progressView.alpha == 0.0;
}
- (void)setProgressHidden:(BOOL)progressHidden {
    [self setProgressHidden:progressHidden animated:NO];
}
- (void)setProgressHidden:(BOOL)progressHidden animated:(BOOL)animated {
    [self willChangeValueForKey:kProgressHiddenKeyPath];
    
    CGFloat const kAlpha = progressHidden ? 0.0 : 1.0;
    
    if (animated) {
        BBWeakify(self);
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            BBStrongify(self);
            [self.progressView setAlpha:kAlpha];
        } completion:nil];
    }
    else {
        [self.progressView setAlpha:kAlpha];
    }
    
    [self didChangeValueForKey:kProgressHiddenKeyPath];
}

@dynamic progress;
- (CGFloat)progress {
    return self.progressView.progress;
}
- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated; {
    [self willChangeValueForKey:kProgressKeyPath];
    
    [self.progressView setProgress:progress animated:animated];
    
    [self didChangeValueForKey:kProgressKeyPath];
}
#pragma mark ** Private Methods **
- (void)_BBProgressNavigationBarInit; {
    [self setProgressView:[[UIProgressView alloc] initWithFrame:CGRectZero]];
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.progressView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.progressView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|" options:0 metrics:nil views:@{@"view": self.progressView}]];
}

@end

@implementation UINavigationController (BBProgressNavigationBarExtensions)

- (BBProgressNavigationBar *)BB_progressNavigationBar; {
    return [self.navigationBar isKindOfClass:[BBProgressNavigationBar class]] ? (BBProgressNavigationBar *)self.navigationBar : nil;
}

@end
