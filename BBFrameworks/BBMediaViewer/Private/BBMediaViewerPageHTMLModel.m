//
//  BBMediaViewerPageHTMLModel.m
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

#import "BBMediaViewerPageHTMLModel.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPageHTMLModel ()
@property (readwrite,copy,nonatomic) NSString *title;
@property (readwrite,copy,nonatomic) NSURLRequest *URLRequest;
@property (readwrite,assign,nonatomic,getter=isLoading) BOOL loading;
@property (readwrite,assign,nonatomic) double estimatedProgress;

@property (weak,nonatomic) WKWebView *webView;

@property (readwrite,strong,nonatomic) RACCommand *goBackCommand;
@end

@implementation BBMediaViewerPageHTMLModel

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel webView:(WKWebView *)webView; {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    _webView = webView;
    
    _URLRequest = [NSURLRequest requestWithURL:self.URL];
    
    BBWeakify(self);
    
    _goBackCommand =
    [[RACCommand alloc] initWithEnabled:RACObserve(self.webView, canGoBack) signalBlock:^RACSignal *(id input) {
        BBStrongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.webView goBack];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    RAC(self,title) =
    RACObserve(self.webView, title);
    
    RAC(self,loading) =
    RACObserve(self.webView, loading);
    
    RAC(self,estimatedProgress) =
    RACObserve(self.webView, estimatedProgress);
    
    return self;
}

@synthesize title=_title;

@end
