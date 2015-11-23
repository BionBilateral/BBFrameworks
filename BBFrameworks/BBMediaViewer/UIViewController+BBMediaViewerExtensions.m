//
//  UIViewController+BBMediaViewerExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 11/22/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIViewController+BBMediaViewerExtensions.h"
#import "BBMediaViewerViewController.h"
#import "NSObject+BBFoundationExtensions.h"

@interface _BBMediaViewerViewControllerDataSourceDelegate : NSObject <BBMediaViewerViewControllerDataSource,BBMediaViewerViewControllerDelegate>

@property (copy,nonatomic) NSArray<id<BBMediaViewerMedia>> *media;
@property (weak,nonatomic) UIView *fromView;
@property (weak,nonatomic) UIViewController *fromViewController;

- (instancetype)initWithMedia:(NSArray<id<BBMediaViewerMedia>> *)media fromView:(UIView *)fromView fromViewController:(UIViewController *)fromViewController;

- (void)presentMediaViewer;

@end

@implementation _BBMediaViewerViewControllerDataSourceDelegate

- (NSInteger)numberOfMediaInMediaViewer:(BBMediaViewerViewController *)mediaViewer {
    return self.media.count;
}
- (id<BBMediaViewerMedia>)mediaViewer:(BBMediaViewerViewController *)mediaViewer mediaAtIndex:(NSInteger)index {
    return self.media[index];
}

- (CGRect)mediaViewer:(BBMediaViewerViewController *)mediaViewer frameForMedia:(id<BBMediaViewerMedia>)media inSourceView:(UIView *__autoreleasing *)sourceView {
    if (self.fromView) {
        *sourceView = self.fromView;
        
        return self.fromView.bounds;
    }
    return CGRectZero;
}

- (void)mediaViewerDidDismiss:(BBMediaViewerViewController *)mediaViewer {
    [self.fromViewController setBB_associatedObject:nil];
}

- (instancetype)initWithMedia:(NSArray<id<BBMediaViewerMedia>> *)media fromView:(UIView *)fromView fromViewController:(UIViewController *)fromViewController; {
    if (!(self = [super init]))
        return nil;
    
    [self setMedia:media];
    [self setFromView:fromView];
    [self setFromViewController:fromViewController];
    
    return self;
}

- (void)presentMediaViewer; {
    [self.fromViewController setBB_associatedObject:self];
    
    BBMediaViewerViewController *viewController = [[BBMediaViewerViewController alloc] init];
    
    [viewController setDataSource:self];
    [viewController setDelegate:self];
    
    [self.fromViewController presentViewController:viewController animated:YES completion:nil];
}

@end

@implementation UIViewController (BBMediaViewerExtensions)

- (void)BB_presentMediaViewerViewControllerWithMedia:(NSArray<id<BBMediaViewerMedia>> *)media fromView:(nullable UIView *)fromView; {
    _BBMediaViewerViewControllerDataSourceDelegate *presenter = [[_BBMediaViewerViewControllerDataSourceDelegate alloc] initWithMedia:media fromView:fromView fromViewController:self];
    
    [presenter presentMediaViewer];
}

@end
