//
//  BBWebKitViewController.m
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

#import "BBWebKitViewController.h"
#import "BBProgressNavigationBar.h"
#import "BBWebKitTitleView.h"
#import "UIImage+BBKitExtensions.h"
#import "UIBarButtonItem+BBKitExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <TUSafariActivity/TUSafariActivity.h>

#import <WebKit/WebKit.h>
#import <objc/runtime.h>

@interface BBWebKitViewController () <WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *webView;
@property (weak,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (copy,nonatomic) NSURLRequest *URLRequest;

@property (strong,nonatomic) RACDisposable *URLRequestDisposable;

+ (UIImage *)_defaultGoBackImage;
+ (UIImage *)_defaultGoForwardImage;
@end

@implementation BBWebKitViewController

#pragma mark ** Subclass Overrides **
+ (void)initialize {
    if (self == [BBWebKitViewController class]) {
        [self setGoBackImage:[self _defaultGoBackImage]];
        [self setGoForwardImage:[self _defaultGoForwardImage]];
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _showNavigationToolbar = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWebView:[[WKWebView alloc] initWithFrame:CGRectZero]];
    [self.webView setNavigationDelegate:self];
    [self.view addSubview:self.webView];
    
    @weakify(self);
    
    BBWebKitTitleView *titleView = [[BBWebKitTitleView alloc] initWithWebKitView:self.webView];
    
    [titleView sizeToFit];
    
    [self.navigationItem setTitleView:titleView];
    
    RACSignal *webViewLoadingSignal = RACObserve(self.webView, loading);
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:NULL];
    
    if ([self.navigationController BB_progressNavigationBar]) {
        [[[webViewLoadingSignal
           not]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSNumber *value) {
             @strongify(self);
             [[self.navigationController BB_progressNavigationBar] setProgressHidden:value.boolValue animated:YES];
         }];
        
        [[RACObserve(self.webView, estimatedProgress)
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSNumber *value) {
             @strongify(self);
             [[self.navigationController BB_progressNavigationBar] setProgress:value.doubleValue animated:YES];
         }];
        
        [self.navigationItem setRightBarButtonItems:@[shareItem]];
    }
    else {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [activityIndicatorView setHidesWhenStopped:YES];
        
        [[webViewLoadingSignal
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSNumber *value) {
             if (value.boolValue) {
                 [activityIndicatorView startAnimating];
             }
             else {
                 [activityIndicatorView stopAnimating];
             }
         }];
        
        [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView],shareItem]];
        
        [self setActivityIndicatorView:activityIndicatorView];
    }
    
    if (self.presentingViewController) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
        
        [doneItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:@YES];
        }]];
        
        [[[doneItem.rac_command.executionSignals
           concat]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);
             [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
         }];
        
        [self.navigationItem setLeftBarButtonItems:@[doneItem]];
    }
    
    UIBarButtonItem *goBackItem = [[UIBarButtonItem alloc] initWithImage:[self.class goBackImage] style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *goForwardItem = [[UIBarButtonItem alloc] initWithImage:[self.class goForwardImage] style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:NULL];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:NULL];
    
    [goBackItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.webView, canGoBack)] reduce:^id(NSNumber *value){
        return @(value.boolValue);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }]];
    
    [[[goBackItem.rac_command.executionSignals
       concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.webView goBack];
     }];
    
    [goForwardItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.webView, canGoForward)] reduce:^id(NSNumber *value){
        return @(value.boolValue);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }]];
    
    [[[goForwardItem.rac_command.executionSignals
       concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.webView goForward];
     }];
    
    [stopItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }]];
    
    [[[stopItem.rac_command.executionSignals
       concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.webView stopLoading];
     }];
    
    [refreshItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }]];
    
    [[[refreshItem.rac_command.executionSignals
       concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.webView reloadFromOrigin];
     }];
    
    [shareItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self.webView, URL)] reduce:^id(NSURL *value){
        return @(value != nil);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }]];
    
    [[[shareItem.rac_command.executionSignals
       concat]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         if (self.webView.URL.isFileURL) {
             UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:self.webView.URL];
             
             [controller presentOptionsMenuFromBarButtonItem:shareItem animated:YES];
         }
         else {
             UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.URL] applicationActivities:@[[[TUSafariActivity alloc] init]]];
             
             [self presentViewController:controller animated:YES completion:nil];
         }
     }];
    
    NSArray *refreshItemArray = @[goBackItem,
                                  [UIBarButtonItem BB_flexibleSpaceBarButtonItem],
                                  goForwardItem,
                                  [UIBarButtonItem BB_flexibleSpaceBarButtonItem],
                                  refreshItem];
    NSArray *stopItemArray = @[goBackItem,
                               [UIBarButtonItem BB_flexibleSpaceBarButtonItem],
                               goForwardItem,
                               [UIBarButtonItem BB_flexibleSpaceBarButtonItem],
                               stopItem];
    
    [self setToolbarItems:refreshItemArray];
    
    [[webViewLoadingSignal
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if (value.boolValue) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
             
             [self setToolbarItems:stopItemArray animated:YES];
         }
         else {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
             [self setToolbarItems:refreshItemArray animated:YES];
         }
     }];
}
- (void)viewDidLayoutSubviews {
    [self.webView setFrame:self.view.bounds];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:!self.showNavigationToolbar animated:animated];
    
    [self.activityIndicatorView setColor:self.navigationController.navigationBar.tintColor];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.URLRequestDisposable) {
        @weakify(self);
        [self setURLRequestDisposable:
         [[RACObserve(self, URLRequest)
           deliverOn:[RACScheduler mainThreadScheduler]]
          subscribeNext:^(NSURLRequest *value) {
              @strongify(self);
              [self.webView stopLoading];
              
              if (value) {
                  [self.webView loadRequest:value];
              }
          }]];
    }
}
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    void(^completionBlock)(BOOL) = ^(BOOL allow) {
        decisionHandler(allow ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
    };
    
    if ([self.delegate respondsToSelector:@selector(webKitViewController:shouldAllowNavigationAction:completionBlock:)]) {
        [self.delegate webKitViewController:self shouldAllowNavigationAction:navigationAction completionBlock:completionBlock];
    }
    else {
        completionBlock(YES);
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webKitViewController:didFinishNavigation:)]) {
        [self.delegate webKitViewController:self didFinishNavigation:navigation];
    }
}
#pragma mark ** Public Methods **
static void *kGoBackImageKey = &kGoBackImageKey;
+ (UIImage *)goBackImage; {
    return objc_getAssociatedObject(self, kGoBackImageKey);
}
+ (void)setGoBackImage:(UIImage *)image; {
    objc_setAssociatedObject(self, kGoBackImageKey, image ?: [self _defaultGoBackImage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void *kGoForwardImageKey = &kGoForwardImageKey;
+ (UIImage *)goForwardImage; {
    return objc_getAssociatedObject(self, kGoForwardImageKey);
}
+ (void)setGoForwardImage:(UIImage *)image; {
    objc_setAssociatedObject(self, kGoForwardImageKey, image ?: [self _defaultGoForwardImage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)loadURLString:(NSString *)URLString; {
    [self loadURL:[NSURL URLWithString:URLString]];
}
- (void)loadURL:(NSURL *)URL; {
    [self loadURLRequest:[NSURLRequest requestWithURL:URL]];
}
- (void)loadURLRequest:(NSURLRequest *)URLRequest {
    [self setURLRequest:URLRequest];
}
#pragma mark Properties
- (void)setShowNavigationToolbar:(BOOL)showNavigationToolbar {
    [self setShowNavigationToolbar:showNavigationToolbar animated:NO];
}
- (void)setShowNavigationToolbar:(BOOL)showNavigationToolbar animated:(BOOL)animated {
    [self willChangeValueForKey:@keypath(self,showNavigationToolbar)];
    _showNavigationToolbar = showNavigationToolbar;
    [self didChangeValueForKey:@keypath(self,showNavigationToolbar)];
    
    [self.navigationController setToolbarHidden:!_showNavigationToolbar animated:animated];
}
#pragma mark ** Private Methods **
+ (UIImage *)_defaultGoBackImage; {
    CGSize const kSize = CGSizeMake(22.0, 22.0);
    
    UIGraphicsBeginImageContextWithOptions(kSize, NO, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:2.0];
    
    [path moveToPoint:CGPointMake(kSize.width, 0)];
    [path addLineToPoint:CGPointMake(0, floor(kSize.height * 0.5))];
    [path addLineToPoint:CGPointMake(kSize.width, kSize.height)];
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}
+ (UIImage *)_defaultGoForwardImage; {
    CGSize const kSize = CGSizeMake(22.0, 22.0);
    
    UIGraphicsBeginImageContextWithOptions(kSize, NO, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:2.0];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(kSize.width, floor(kSize.height * 0.5))];
    [path addLineToPoint:CGPointMake(0, kSize.height)];
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}

@end

@implementation UIViewController (BBWebKitViewControllerExtensions)

- (void)BB_presentWebKitViewControllerForURLString:(NSString *)URLString; {
    [self BB_presentWebKitViewControllerForURL:[NSURL URLWithString:URLString]];
}
- (void)BB_presentWebKitViewControllerForURL:(NSURL *)URL; {
    [self BB_presentWebKitViewControllerForURLRequest:[NSURLRequest requestWithURL:URL]];
}
- (void)BB_presentWebKitViewControllerForURLRequest:(NSURLRequest *)URLRequest; {
    [self BB_presentWebKitViewControllerForURLRequest:URLRequest navigationControllerClass:[UINavigationController class]];
}

- (void)BB_presentWebKitViewControllerForURLString:(NSString *)URLString navigationControllerClass:(Class)navigationControllerClass; {
    [self BB_presentWebKitViewControllerForURL:[NSURL URLWithString:URLString] navigationControllerClass:navigationControllerClass];
}
- (void)BB_presentWebKitViewControllerForURL:(NSURL *)URL navigationControllerClass:(Class)navigationControllerClass; {
    [self BB_presentWebKitViewControllerForURLRequest:[NSURLRequest requestWithURL:URL] navigationControllerClass:navigationControllerClass];
}
- (void)BB_presentWebKitViewControllerForURLRequest:(NSURLRequest *)URLRequest navigationControllerClass:(Class)navigationControllerClass; {
    NSParameterAssert(URLRequest);
    NSParameterAssert(navigationControllerClass);
    
    BBWebKitViewController *viewController = [[BBWebKitViewController alloc] init];
    
    [viewController loadURLRequest:URLRequest];
    
    UINavigationController *navigationController = [[navigationControllerClass alloc] initWithNavigationBarClass:[BBProgressNavigationBar class] toolbarClass:Nil];
    
    [navigationController setViewControllers:@[viewController]];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end