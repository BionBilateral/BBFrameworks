//
//  BBThumbnailGenerator.m
//  BBFrameworks
//
//  Created by William Towe on 5/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailGenerator.h"
#import "NSBundle+BBFoundationExtensions.h"
#import "BBFoundationDebugging.h"
#import "BBFoundationFunctions.h"

#if (TARGET_OS_IPHONE)
#import <UIKit/UIApplication.h>
#endif

static NSString *const kCacheDirectoryName = @"BBThumbnailGenerator";

static CGSize const kDefaultSize = {.width=175.0, .height=175.0};
static NSInteger const kDefaultPage = 1;
static NSTimeInterval const kDefaultTime = 1.0;

@interface BBThumbnailGenerator () <NSCacheDelegate>
@property (readwrite,copy,nonatomic) NSURL *fileCacheDirectoryURL;

@property (strong,nonatomic) dispatch_queue_t fileCacheQueue;
@property (strong,nonatomic) NSCache *memoryCache;
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@end

@implementation BBThumbnailGenerator
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setCacheOptions:BBThumbnailGeneratorCacheOptionsFile | BBThumbnailGeneratorCacheOptionsMemory];
    
    NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *fileCacheDirectoryURL = [cachesDirectoryURL URLByAppendingPathComponent:kCacheDirectoryName isDirectory:YES];
    
#if (!TARGET_OS_IPHONE)
    fileCacheDirectoryURL = [fileCacheDirectoryURL URLByAppendingPathComponent:[[NSBundle mainBundle] BB_bundleIdentifier] isDirectory:YES];
#endif
    
    [self setFileCacheDirectoryURL:fileCacheDirectoryURL];
    
    [self setDefaultSize:kDefaultSize];
    [self setDefaultPage:kDefaultPage];
    [self setDefaultTime:kDefaultTime];
    
    [self setMemoryCache:[[NSCache alloc] init]];
    [self.memoryCache setName:[NSString stringWithFormat:@"%@.%p",kCacheDirectoryName,self]];
    [self.memoryCache setDelegate:self];
    
    [self setFileCacheQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.filecache.%p",kCacheDirectoryName,self].UTF8String, DISPATCH_QUEUE_CONCURRENT)];
 
#if (TARGET_OS_IPHONE)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    
    return self;
}
#pragma mark *** Public Methods ***
- (void)clearFileCache; {
    
}
- (void)clearMemoryCache; {
    [self.memoryCache removeAllObjects];
}

- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL completion:(BBThumbnailCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:self.defaultSize page:self.defaultPage time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size completion:(BBThumbnailCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:self.defaultPage time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size page:(NSInteger)page completion:(BBThumbnailCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:page time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size time:(NSTimeInterval)time completion:(BBThumbnailCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:self.defaultPage time:time completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time completion:(BBThumbnailCompletionBlock)completion; {
    return nil;
}
#pragma mark *** Private Methods ***
#pragma mark Properties
- (void)setFileCacheDirectoryURL:(NSURL *)fileCacheDirectoryURL {
    _fileCacheDirectoryURL = fileCacheDirectoryURL;
    
    if (_fileCacheDirectoryURL) {
        if (![_fileCacheDirectoryURL checkResourceIsReachableAndReturnError:NULL]) {
            NSError *outError;
            if (![[NSFileManager defaultManager] createDirectoryAtURL:_fileCacheDirectoryURL withIntermediateDirectories:YES attributes:nil error:&outError]) {
                BBLogObject(outError);
            }
        }
    }
}
#pragma mark Notifications
- (void)_applicationDidReceiveMemoryWarning:(NSNotification *)note {
    [self clearMemoryCache];
}

@end
