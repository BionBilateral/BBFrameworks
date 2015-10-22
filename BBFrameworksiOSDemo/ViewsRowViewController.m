//
//  ViewController.m
//  BBFrameworksiOSDemo
//
//  Created by William Towe on 5/13/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewsRowViewController.h"
#import "TableViewController.h"

#import <BBFrameworks/BBKit.h>

@interface ViewsRowViewController ()
@property (strong,nonatomic) UIImageView *blurImageView;
@property (strong,nonatomic) UIImageView *tintImageView;
@property (strong,nonatomic) BBBadgeView *badgeView;
@property (strong,nonatomic) BBTextView *textView;
@property (readonly,nonatomic) BBView *backgroundView;
@property (strong,nonatomic) BBGradientView *gradientView;
@property (strong,nonatomic) BBLabel *label;
@end

@implementation ViewsRowViewController

+ (void)initialize {
    if (self == [ViewsRowViewController class]) {
        [[BBTextView appearance] setPlaceholderFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [[BBTextView appearance] setPlaceholderTextColor:[UIColor lightGrayColor]];
    }
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)loadView {
    [self setView:[[BBView alloc] initWithFrame:CGRectZero]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.backgroundView setBorderOptions:BBViewBorderOptionsAll];
    
    [self setBlurImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.blurImageView setImage:[[UIImage imageNamed:@"optimus_prime"] BB_imageByBlurringWithRadius:0.5]];
    [self.view addSubview:self.blurImageView];
    
    [self setTintImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.tintImageView setImage:[[UIImage imageNamed:@"optimus_prime"] BB_imageByAdjustingContrastBy:0.5]];
    [self.view addSubview:self.tintImageView];
    
    [self setBadgeView:[[BBBadgeView alloc] initWithFrame:CGRectZero]];
    [self.badgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.badgeView setBadge:@"1234"];
    [self.view addSubview:self.badgeView];
    
    [self setTextView:[[BBTextView alloc] initWithFrame:CGRectZero]];
    [self.textView setBackgroundColor:[UIColor blackColor]];
    [self.textView setTextContainerInset:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    [self.textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.textView setTintColor:[UIColor whiteColor]];
    [self.textView setPlaceholder:@"Type some text…"];
    [self.textView setInputAccessoryView:[BBNextPreviousInputAccessoryView nextPreviousInputAccessoryViewWithResponder:self.textView]];
    [self.view addSubview:self.textView];
    
    [self setGradientView:[[BBGradientView alloc] initWithFrame:CGRectZero]];
    [self.gradientView setColors:@[BBColorRandomRGB(),BBColorRandomRGB()]];
    [self.view addSubview:self.gradientView];
    
    [self setLabel:[[BBLabel alloc] initWithFrame:CGRectZero]];
    [self.label setEdgeInsets:UIEdgeInsetsMake(4.0, 8.0, 4.0, 8.0)];
    [self.label setTextColor:[UIColor whiteColor]];
    [self.label setBackgroundColor:[UIColor blackColor]];
    [self.label setText:@"Label"];
    [self.view addSubview:self.label];
}
- (void)viewDidLayoutSubviews {
    CGSize badgeViewSize = [self.badgeView sizeThatFits:CGSizeZero];
    
    [self.blurImageView setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 8.0, 100, 100)];
    [self.tintImageView setFrame:CGRectMake(CGRectGetMaxX(self.blurImageView.frame) + 8.0, CGRectGetMinY(self.blurImageView.frame), 100, 100)];
    [self.badgeView setFrame:CGRectMake(CGRectGetMaxX(self.tintImageView.frame) + 8.0, [self.topLayoutGuide length] + 8.0, badgeViewSize.width, badgeViewSize.height)];
    [self.textView setFrame:CGRectMake(8.0, CGRectGetMaxY(self.blurImageView.frame) + 8.0, 150, 150.0)];
    [self.gradientView setFrame:CGRectMake(CGRectGetMaxX(self.textView.frame) + 8.0, CGRectGetMinY(self.textView.frame), 100, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.textView.frame) - 16.0)];
    [self.label setFrame:CGRectMake(CGRectGetMaxX(self.gradientView.frame) + 8.0, CGRectGetMinY(self.gradientView.frame), [self.label sizeThatFits:CGSizeZero].width, [self.label sizeThatFits:CGSizeZero].height)];
}
- (void)viewWillLayoutSubviews {
    [self.backgroundView setBorderEdgeInsets:UIEdgeInsetsMake([self.topLayoutGuide length] + self.backgroundView.borderWidth, self.backgroundView.borderWidth, [self.bottomLayoutGuide length] + self.backgroundView.borderWidth, self.backgroundView.borderWidth)];
}

+ (NSString *)rowClassTitle {
    return @"Views";
}

- (BBView *)backgroundView {
    return (BBView *)self.view;
}

@end
