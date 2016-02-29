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
#import <BBFrameworks/BBBlocks.h>

#import <QuickLook/QuickLook.h>

@interface MediaViewerViewController () <QLPreviewControllerDataSource,QLPreviewControllerDelegate,BBMediaViewerViewControllerDataSource,BBMediaViewerViewControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *systemButton;
@property (weak,nonatomic) IBOutlet UIButton *customButton;

@property (copy,nonatomic) NSArray *URLs;
@property (copy,nonatomic) NSArray *customURLs;
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
    
//    [temp insertObject:[NSURL URLWithString:@"http://www.thebounce.ca/files/gc-cat.png"] atIndex:0];
//    [temp insertObject:[NSURL URLWithString:@"http://sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4"] atIndex:0];
    
//    [self setCustomURLs:[temp BB_filter:^BOOL(NSURL *object, NSInteger index) {
//        return [object.lastPathComponent.pathExtension isEqualToString:@"mp4"];
//    }]];
    [self setCustomURLs:temp];
    
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

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view {
    *view = self.systemButton;
    return self.systemButton.bounds;
}
- (UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect {
    UIImage *retval = [UIImage imageNamed:@"optimus_prime"];
    *contentRect = CGRectMake(0, 0, ceil(retval.size.width * 0.5), retval.size.height);
    return retval;
}

- (void)mediaViewerViewControllerIsDone:(BBMediaViewerViewController *)viewController {
    [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_systemButtonAction:(id)sender {
    QLPreviewController *viewController = [[QLPreviewController alloc] init];
    
    [viewController setDataSource:self];
    [viewController setDelegate:self];
    [viewController setCurrentPreviewItemIndex:0];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)_customButtonAction:(id)sender {
    BBMediaViewerViewController *viewController = [[BBMediaViewerViewController alloc] init];
    
    [viewController setDataSource:self];
    [viewController setDelegate:self];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
