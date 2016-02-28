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
#import "BBWebKitTitleView+BBWebKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"
#import "UIBarButtonItem+BBKitExtensions.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBNetworkActivityIndicatorManager.h"
#import "BBWebKitTheme.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <TUSafariActivity/TUSafariActivity.h>
#import <ARChromeActivity/ARChromeActivity.h>

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
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _showNavigationToolbar = YES;
    _showShareBarButtonItem = YES;
    _theme = [BBWebKitTheme defaultTheme];
    
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
    
    RAC(titleView,customTitle) = RACObserve(self, customTitle);
    
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
        
        if (self.showShareBarButtonItem) {
            if (self.presentingViewController) {
                [self.navigationItem setLeftBarButtonItems:@[shareItem]];
            }
            else {
                [self.navigationItem setRightBarButtonItems:@[shareItem]];
            }
        }
        else {
            UIBarButtonItem *spaceItem = [UIBarButtonItem BB_fixedSpaceBarButtonItemWithWidth:32.0];
            
            if (self.presentingViewController) {
                [self.navigationItem setLeftBarButtonItems:@[spaceItem]];
            }
            else {
                [self.navigationItem setRightBarButtonItems:@[spaceItem]];
            }
        }
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
        
        if (self.showShareBarButtonItem) {
            [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView],shareItem]];
        }
        else {
            [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView]]];
        }
        
        [self setActivityIndicatorView:activityIndicatorView];
    }
    
    if (self.presentingViewController) {
        UIBarButtonItem *doneItem = self.theme.doneBarButtonItem;
        
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
        
        if ([self.navigationController BB_progressNavigationBar]) {
            [self.navigationItem setRightBarButtonItems:@[doneItem]];
        }
        else {
            [self.navigationItem setLeftBarButtonItems:@[doneItem]];
        }
    }
    
    UIBarButtonItem *goBackItem = [[UIBarButtonItem alloc] initWithImage:self.theme.goBackImage style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *goForwardItem = [[UIBarButtonItem alloc] initWithImage:self.theme.goForwardImage style:UIBarButtonItemStylePlain target:nil action:NULL];
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
             UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.URL] applicationActivities:@[[[TUSafariActivity alloc] init],[[ARChromeActivity alloc] init]]];
             
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
             if ([BBNetworkActivityIndicatorManager sharedManager].isEnabled) {
                 [[BBNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
             }
             else {
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
             }
             
             [self setToolbarItems:stopItemArray animated:YES];
         }
         else {
             if ([BBNetworkActivityIndicatorManager sharedManager].isEnabled) {
                 [[BBNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
             }
             else {
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             }
             
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self.navigationController BB_progressNavigationBar] setProgressHidden:YES animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[self.navigationController BB_progressNavigationBar] setProgress:0.0];
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
- (void)setTheme:(BBWebKitTheme *)theme {
    _theme = theme ?: [BBWebKitTheme defaultTheme];
}
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
    return [UIImage BB_imageInResourcesBundleNamed:@"web_kit_go_back"];
}
+ (UIImage *)_defaultGoForwardImage; {
    return [UIImage BB_imageInResourcesBundleNamed:@"web_kit_go_forward"];
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