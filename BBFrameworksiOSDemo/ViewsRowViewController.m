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
#import <BBFrameworks/BBReactiveKit.h>

@interface ViewsRowViewController ()
@property (strong,nonatomic) BBBadgeView *badgeView;
@property (strong,nonatomic) BBTextView *textView;
@property (readonly,nonatomic) BBView *backgroundView;
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
    [self.view addSubview:self.textView];
}
- (void)viewDidLayoutSubviews {
    CGSize badgeViewSize = [self.badgeView sizeThatFits:CGSizeZero];
    
    [self.badgeView setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 8.0, badgeViewSize.width, badgeViewSize.height)];
    [self.textView setFrame:CGRectMake(CGRectGetMaxX(self.badgeView.frame) + 8.0, [self.topLayoutGuide length] + 8.0, CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(self.badgeView.frame) - 16.0, 150.0)];
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
