//
//  MediaViewerViewController.m
//  BBFrameworks
//
//  Created by William Towe on 8/8/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "MediaViewerViewController.h"

#import <BBFrameworks/BBMediaViewer.h>

#import <QuickLook/QuickLook.h>

@interface MediaViewerViewController () <QLPreviewControllerDataSource,BBMediaViewerViewControllerDataSource>
@property (weak,nonatomic) IBOutlet UIButton *systemButton;
@property (weak,nonatomic) IBOutlet UIButton *customButton;

@property (copy,nonatomic) NSArray *URLs;
@end

@implementation MediaViewerViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSURL *URL in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[[NSBundle mainBundle] URLForResource:@"media" withExtension:@""] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
        [temp addObject:URL];
    }
    
    [self setURLs:temp];
    
    [self.systemButton addTarget:self action:@selector(_systemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customButton addTarget:self action:@selector(_customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

+ (NSString *)rowClassTitle {
    return @"Media Viewer";
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.URLs.count;
}
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.URLs[index];
}

- (NSInteger)numberOfMediaInMediaViewer:(BBMediaViewerViewController *)mediaViewer {
    return self.URLs.count;
}
- (id<BBMediaViewerMedia>)mediaViewer:(BBMediaViewerViewController *)mediaViewer mediaAtIndex:(NSInteger)index {
    return self.URLs[index];
}

- (IBAction)_systemButtonAction:(id)sender {
    QLPreviewController *viewController = [[QLPreviewController alloc] init];
    
    [viewController setDataSource:self];
    [viewController setCurrentPreviewItemIndex:0];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)_customButtonAction:(id)sender {
    BBMediaViewerViewController *viewController = [[BBMediaViewerViewController alloc] init];
    
    [viewController setDataSource:self];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
}

@end
