//
//  BBThumbnailDownloadOperation.m
//  BBFrameworks
//
//  Created by William Towe on 8/1/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailDownloadOperation.h"
#import "BBThumbnailGenerator+BBThumbnailExtensionsPrivate.h"
#import "BBThumbnailHTMLOperation.h"
#import "BBThumbnailOperationWrapper.h"
#import "BBFoundationDebugging.h"
#import "BBThumbnailImageOperation.h"
#import "BBThumbnailMovieOperation.h"
#import "BBThumbnailPDFOperation.h"

#if (TARGET_OS_IPHONE)
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@interface BBThumbnailDownloadOperation () <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property (copy,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@property (assign,nonatomic) NSInteger page;
@property (assign,nonatomic) NSTimeInterval time;
@property (weak,nonatomic) BBThumbnailOperationWrapper *thumbnailOperationWrapper;
@property (weak,nonatomic) BBThumbnailGenerator *thumbnailGenerator;
@property (copy,nonatomic) BBThumbnailOperationProgressBlock progressBlock;

@property (assign,nonatomic) BOOL shouldInvalidateSession;
@end

@implementation BBThumbnailDownloadOperation
#pragma mark *** Subclass Overrides ***
- (void)start {
    if (self.isCancelled) {
        [self finishOperationWithImage:nil error:nil];
        return;
    }
    
    [self performSelector:@selector(main) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

- (void)main {
    [super main];
    
    [self setTask:[[NSURLSession sessionWithConfiguration:self.thumbnailGenerator.URLSessionConfiguration ?: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil] dataTaskWithURL:self.URL]];
    [self.task resume];
}
#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (error) {
        BBLog(@"%@ %@",session,error);
        [self finishOperationWithImage:nil error:error];
    }
}
#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.shouldInvalidateSession) {
        [session invalidateAndCancel];
    }
    
    // only signal an error if our task was not cancelled
    if (error && error.code != NSURLErrorCancelled) {
        BBLog(@"%@ %@ %@",session,task,error);
        [self finishOperationWithImage:nil error:error];
    }
    else {
        [self setExecutingAndGenerateKVO:NO];
        [self setFinishedAndGenerateKVO:YES];
    }
}
#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)response.MIMEType, NULL);
    
    // if HTML, cancel our task and have the HTML operation handle it
    if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeHTML)) {
        [self.thumbnailOperationWrapper setOperation:[[BBThumbnailHTMLOperation alloc] initWithURL:self.URL size:self.size completion:self.operationCompletionBlock]];
        [self.thumbnailGenerator.webViewOperationQueue addOperation:self.thumbnailOperationWrapper.operation];
        
        [self setShouldInvalidateSession:YES];
        
        completionHandler(NSURLSessionResponseCancel);
    }
    // if movie, cancel our task and have the movie operation handle it
    else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie)) {
        [self.thumbnailOperationWrapper setOperation:[[BBThumbnailMovieOperation alloc] initWithURL:self.URL size:self.size time:self.time completion:self.operationCompletionBlock]];
        [self.thumbnailGenerator.operationQueue addOperation:self.thumbnailOperationWrapper.operation];
        
        [self setShouldInvalidateSession:YES];
        
        completionHandler(NSURLSessionResponseCancel);
    }
    // if image or pdf, change our data task to a download task to download the file
    else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage) ||
             UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypePDF)) {
        
        [self setShouldInvalidateSession:NO];
        
        completionHandler(NSURLSessionResponseBecomeDownload);
    }
    // otherwise the UTI is not supported, cancel our task
    else {
        [self setShouldInvalidateSession:YES];
        
        completionHandler(NSURLSessionResponseCancel);
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self setShouldInvalidateSession:YES];
}
#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progressBlock) {
        self.progressBlock(self.URL,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSURL *URL = [self.thumbnailGenerator downloadCacheURLForURL:downloadTask.originalRequest.URL];
    
    // first remove any file that exists at URL
    [[NSFileManager defaultManager] removeItemAtURL:URL error:NULL];
    
    // move the file from location to URL
    NSError *outError;
    if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:URL error:&outError]) {
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)downloadTask.response.MIMEType, NULL);
        NSOperation<BBThumbnailOperation> *thumbnailOperation = nil;
        
        // if the UTI is supported, create the appropriate thumbnail operation to read from URL
        if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage)) {
            thumbnailOperation = [[BBThumbnailImageOperation alloc] initWithURL:URL size:self.size completion:self.operationCompletionBlock];
        }
        else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypePDF)) {
            thumbnailOperation = [[BBThumbnailPDFOperation alloc] initWithURL:URL size:self.size page:self.page completion:self.operationCompletionBlock];
        }
        
        if (thumbnailOperation) {
            [self.thumbnailOperationWrapper setOperation:thumbnailOperation];
            [self.thumbnailGenerator.operationQueue addOperation:thumbnailOperation];
        }
        
        [self setExecutingAndGenerateKVO:NO];
        [self setFinishedAndGenerateKVO:YES];
    }
    else {
        [self finishOperationWithImage:nil error:outError];
    }
}
#pragma mark *** Public Methods ***
- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time thumbnailOperationWrapper:(BBThumbnailOperationWrapper *)thumbnailOperationWrapper thumbnailGenerator:(BBThumbnailGenerator *)thumbnailGenerator progress:(BBThumbnailOperationProgressBlock)progress completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setPage:page];
    [self setTime:time];
    [self setThumbnailOperationWrapper:thumbnailOperationWrapper];
    [self setThumbnailGenerator:thumbnailGenerator];
    [self setProgressBlock:progress];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@end
