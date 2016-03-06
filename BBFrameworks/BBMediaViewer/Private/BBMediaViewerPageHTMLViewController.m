//
//  BBMediaViewerPageHTMLViewController.m
//  BBFrameworks
//
//  Created by William Towe on 3/2/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageHTMLViewController.h"
#import "BBMediaViewerPageHTMLModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerPageHTMLToolbarContentView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WebKit/WebKit.h>

@interface BBMediaViewerPageHTMLViewController ()
@property (strong,nonatomic) WKWebView *webView;
@property (strong,nonatomic) BBMediaViewerPageHTMLToolbarContentView *HTMLToolbarContentView;

@property (readwrite,strong,nonatomic) BBMediaViewerPageHTMLModel *model;
@end

@implementation BBMediaViewerPageHTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    [self setHTMLToolbarContentView:[[BBMediaViewerPageHTMLToolbarContentView alloc] initWithModel:self.model]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    
    BBWeakify(self);
    [[[RACObserve(self.model, URLRequest)
     ignore:nil]
     deliverOnMainThread]
     subscribeNext:^(NSURLRequest *value) {
         BBStrongify(self);
         if (self.webView.isLoading) {
             [self.webView stopLoading];
         }
         
         [self.webView loadRequest:value];
     }];
}

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _model = [[BBMediaViewerPageHTMLModel alloc] initWithMedia:media parentModel:parentModel webView:_webView];
    
    return self;
}

@synthesize model=_model;

- (UIView *)bottomToolbarContentView {
    return self.HTMLToolbarContentView;
}

@end
