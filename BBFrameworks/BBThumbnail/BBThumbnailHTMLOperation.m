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
#import "BBFrameworksMacros.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#else
#import "NSImage+BBKitExtensions.h"
#endif

#import <WebKit/WebKit.h>

@interface BBThumbnailHTMLOperation () <WKNavigationDelegate>
@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;

@property (strong,nonatomic) WKWebView *webView;

#if (!TARGET_OS_IPHONE)
@property (strong,nonatomic) NSWindow *window;
#endif
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
    [super main];
    
#if (TARGET_OS_IPHONE)
    [self setWebView:[[WKWebView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]];
    [self.webView setUserInteractionEnabled:NO];
    
    [[UIApplication sharedApplication].keyWindow insertSubview:self.webView atIndex:0];
#else
    NSSize windowSize = NSMakeSize(1024, 768);
    
    [self setWindow:[[NSWindow alloc] initWithContentRect:NSMakeRect(-windowSize.width, -windowSize.height, windowSize.width, windowSize.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreNonretained defer:NO]];
    
    [self setWebView:[[WKWebView alloc] initWithFrame:NSMakeRect(0, 0, windowSize.width, windowSize.height)]];
    
    [self.window setContentView:self.webView];
#endif
    
    [self.webView setNavigationDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)cancel {
    [super cancel];
    
    [self.webView stopLoading];
    
#if (TARGET_OS_IPHONE)
    [self.webView removeFromSuperview];
#endif
}

- (BOOL)wantsWebViewOperationQueue {
    return YES;
}
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    BBThumbnailGeneratorImageClass *image;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(self.webView.frame.size, YES, 0);
    
    [self.webView drawViewHierarchyInRect:self.webView.bounds afterScreenUpdates:YES];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.webView removeFromSuperview];
#else
    NSDisableScreenUpdates();
    
    [self.window orderFront:nil];
    
    CGImageRef imageRef = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, (CGWindowID)self.window.windowNumber, kCGWindowImageBoundsIgnoreFraming);
    
    [self.window orderOut:nil];
    
    NSEnableScreenUpdates();
    
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    image = [[NSImage alloc] initWithSize:NSMakeSize(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef))];
    
    [image addRepresentation:bitmap];
#endif
    
    BBWeakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BBStrongify(self);
        
        BBThumbnailGeneratorImageClass *retval = [image BB_imageByResizingToSize:self.size];
        
        [self finishOperationWithImage:retval error:nil];
    });
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
#if (TARGET_OS_IPHONE)
    [self.webView removeFromSuperview];
#endif
    
    [self finishOperationWithImage:nil error:error];
}
#pragma mark *** Public Methods ***
- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@end
