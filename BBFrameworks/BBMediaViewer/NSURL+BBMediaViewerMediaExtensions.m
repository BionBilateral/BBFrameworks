//
//  NSURL+BBMediaViewerMediaExtensions.m
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

#import "NSURL+BBMediaViewerMediaExtensions.h"
#import "NSURL+BBKitExtensions.h"
#import "BBFoundationFunctions.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

@interface NSURL (BBMediaViewerMediaExtensionsPrivate)
@property (strong,nonatomic) id BB_downloadedMedia;
@end

@implementation NSURL (BBMediaViewerMediaExtensions)

- (NSURL *)mediaURL {
    return self;
}

- (NSString *)mediaTitle {
    return self.lastPathComponent;
}

- (UIImage *)mediaImage {
    NSString *UTI = self.isFileURL ? [self BB_typeIdentifier] : (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)self.lastPathComponent.pathExtension, NULL);
    
    if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage)) {
        if (self.isFileURL) {
            return [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:self]];
        }
        else {
            return self.BB_downloadedMedia;
        }
    }
    return nil;
}
- (UIImage *)mediaPlaceholderImage {
    return [UIImage imageNamed:@"optimus_prime"];
}

- (void)downloadMediaImageWithCompletion:(void (^)(BOOL, NSError *))completion {
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:self completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            [self setBB_downloadedMedia:nil];
        }
        else {
            [self setBB_downloadedMedia:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:location]]];
        }
        BBDispatchMainSyncSafe(^{
            completion(error != nil,error);
        });
    }];
    
    [task resume];
}

@end

@implementation NSURL (BBMediaViewerMediaExtensionsPrivate)

static void *kBB_downloadedImageKey = &kBB_downloadedImageKey;

- (id)BB_downloadedMedia {
    return objc_getAssociatedObject(self, kBB_downloadedImageKey);
}
- (void)setBB_downloadedMedia:(id)BB_downloadedImage {
    objc_setAssociatedObject(self, kBB_downloadedImageKey, BB_downloadedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
