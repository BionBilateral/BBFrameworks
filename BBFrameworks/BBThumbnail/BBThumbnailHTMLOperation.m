//
//  BBThumbnailHTMLOperation.m
//  BBFrameworks
//
//  Created by William Towe on 6/21/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailHTMLOperation.h"
#import "BBFoundationDebugging.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#else
#import "NSImage+BBKitExtensions.h"
#endif

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WebKit/WebKit.h>

@interface BBThumbnailHTMLOperation () <WKNavigationDelegate>
@property (readwrite,assign,getter=isExecuting) BOOL executing;
@property (readwrite,assign,getter=isFinished) BOOL finished;

@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@property (copy,nonatomic) BBThumbnailOperationCompletionBlock operationCompletionBlock;

@property (strong,nonatomic) WKWebView *webView;
@end

@implementation BBThumbnailHTMLOperation

- (void)start {
    if (self.isCancelled) {
        [self finishOperationWithImage:nil error:nil];
        return;
    }
    
    [self performSelector:@selector(main) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

- (void)main {
    [self setExecuting:YES];
    
#if (TARGET_OS_IPHONE)
    [self setWebView:[[WKWebView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]];
    [self.webView setUserInteractionEnabled:NO];
    
    [[UIApplication sharedApplication].keyWindow insertSubview:self.webView atIndex:0];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
    @weakify(self);
    [[[[[[RACObserve(self.webView, loading)
          distinctUntilChanged]
     combinePreviousWithStart:@NO reduce:^id(id previous, id current) {
         return RACTuplePack(previous,current);
     }]
        filter:^BOOL(RACTuple *value) {
            RACTupleUnpack(NSNumber *previous, NSNumber *current) = value;
            
            return previous.boolValue && !current.boolValue;
        }]
     take:1]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         UIGraphicsBeginImageContextWithOptions(self.webView.frame.size, YES, 0);
         
         [self.webView drawViewHierarchyInRect:self.webView.bounds afterScreenUpdates:YES];
         
         UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
         
         UIGraphicsEndImageContext();
         
         [self.webView removeFromSuperview];
         
         @weakify(self);
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
             @strongify(self);
             UIImage *retval = [image BB_imageByResizingToSize:self.size];
             
             [self finishOperationWithImage:retval error:nil];
         });
     }];
#else
    [self finishOperationWithImage:nil error:nil];
#endif
}

- (BOOL)isAsynchronous {
    return YES;
}

- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

- (void)finishOperationWithImage:(BBThumbnailGeneratorImageClass *)image error:(NSError *)error; {
    self.operationCompletionBlock(image,error);
    
    [self setExecuting:NO];
    [self setFinished:YES];
}

@synthesize executing=_executing;
@synthesize finished=_finished;

@end
