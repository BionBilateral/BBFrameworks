//
//  BBMediaViewerTextViewController.m
//  BBFrameworks
//
//  Created by William Towe on 8/12/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerTextViewController.h"
#import "BBMediaViewerDetailViewModel.h"

@interface BBMediaViewerTextViewController ()
@property (strong,nonatomic) UITextView *textView;
@end

@implementation BBMediaViewerTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextView:[[UITextView alloc] initWithFrame:CGRectZero]];
    [self.textView setTextContainerInset:UIEdgeInsetsZero];
    [self.textView setEditable:NO];
    [self.textView setSelectable:YES];
    [self.view addSubview:self.textView];
    
    if (self.viewModel.type == BBMediaViewerDetailViewModelTypePlainText) {
        [self.textView setText:self.viewModel.text];
    }
}
- (void)viewWillLayoutSubviews {
    [self.textView setFrame:self.view.bounds];
}
- (void)viewDidLayoutSubviews {
    [self.textView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, [self.bottomLayoutGuide length], 0)];
}

@end
