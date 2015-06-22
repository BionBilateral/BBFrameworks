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
#import "NSString+BBFoundationExtensions.h"
#import "BBThumbnailOperationWrapper.h"
#import "BBThumbnailImageOperation.h"
#import "BBThumbnailMovieOperation.h"
#import "BBThumbnailPDFOperation.h"
#import "BBThumbnailRTFOperation.h"
#import "BBThumbnailTextOperation.h"
#import "BBThumbnailYouTubeOperation.h"
#import "BBThumbnailVimeoOperation.h"
#import "BBThumbnailHTMLOperation.h"
#import "BBThumbnailDocumentOperation.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#endif

#import <ReactiveCocoa/RACEXTScope.h>
#if (TARGET_OS_IPHONE)
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIApplication.h>
#endif

static NSString *const kCacheDirectoryName = @"BBThumbnailGenerator";
static NSString *const kThumbnailCacheDirectoryName = @"thumbnails";

static CGSize const kDefaultSize = {.width=175.0, .height=175.0};
static NSInteger const kDefaultPage = 1;
static NSTimeInterval const kDefaultTime = 1.0;

@interface BBThumbnailGenerator () <NSCacheDelegate>
@property (copy,nonatomic) NSURL *fileCacheDirectoryURL;

@property (strong,nonatomic) dispatch_queue_t fileCacheQueue;
@property (strong,nonatomic) NSCache *memoryCache;
@property (strong,nonatomic) NSOperationQueue *operationQueue;

@property (strong,nonatomic) NSOperationQueue *webViewOperationQueue;

+ (NSOperationQueue *)_defaultCompletionQueue;
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
    
    NSURL *thumbnailFileCacheDirectoryURL = [fileCacheDirectoryURL URLByAppendingPathComponent:kThumbnailCacheDirectoryName isDirectory:YES];
    
    [self setFileCacheDirectoryURL:thumbnailFileCacheDirectoryURL];
    
    [self setDefaultSize:kDefaultSize];
    [self setDefaultPage:kDefaultPage];
    [self setDefaultTime:kDefaultTime];
    
    [self setCompletionQueue:[self.class _defaultCompletionQueue]];
    
    [self setMemoryCache:[[NSCache alloc] init]];
    [self.memoryCache setName:[NSString stringWithFormat:@"%@.%p",kCacheDirectoryName,self]];
    [self.memoryCache setDelegate:self];
    
    [self setFileCacheQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.filecache.%p",kCacheDirectoryName,self].UTF8String, DISPATCH_QUEUE_CONCURRENT)];
    
    [self setOperationQueue:[[NSOperationQueue alloc] init]];
    [self.operationQueue setName:[NSString stringWithFormat:@"%@.operationqueue.%p",kCacheDirectoryName,self]];
    [self.operationQueue setQualityOfService:NSQualityOfServiceBackground];
    
    [self setWebViewOperationQueue:[[NSOperationQueue alloc] init]];
    [self.operationQueue setName:[NSString stringWithFormat:@"%@.operationqueue.webview.%p",kCacheDirectoryName,self]];
    [self.webViewOperationQueue setQualityOfService:NSQualityOfServiceUtility];
    [self.webViewOperationQueue setMaxConcurrentOperationCount:[NSProcessInfo processInfo].activeProcessorCount];
 
#if (TARGET_OS_IPHONE)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    
    return self;
}
#pragma mark NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    BBLog(@"%@ %@",cache.name,obj);
}
#pragma mark *** Public Methods ***
- (void)clearFileCache; {
    NSError *outError;
    if ([[NSFileManager defaultManager] removeItemAtURL:self.fileCacheDirectoryURL error:&outError]) {
        [self setFileCacheDirectoryURL:self.fileCacheDirectoryURL];
    }
    else {
        BBLogObject(outError);
    }
}
- (void)clearMemoryCache; {
    [self.memoryCache removeAllObjects];
}

- (NSString *)memoryCacheKeyForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time; {
#if (TARGET_OS_IPHONE)
    return [NSString stringWithFormat:@"%@%@%@%@",[URL.absoluteString BB_MD5String],NSStringFromCGSize(size),@(page),@(time)];
#else
    return [NSString stringWithFormat:@"%@%@%@%@",[URL.absoluteString BB_MD5String],NSStringFromSize(NSSizeFromCGSize(size)),@(page),@(time)];
#endif
}

- (NSURL *)fileCacheURLForMemoryCacheKey:(NSString *)key; {
    return [self.fileCacheDirectoryURL URLByAppendingPathComponent:key isDirectory:NO];
}
- (NSURL *)fileCacheURLForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time; {
    return [self fileCacheURLForMemoryCacheKey:[self memoryCacheKeyForURL:URL size:size page:page time:time]];
}

- (void)cancelAllThumbnailGeneration; {
    [self.operationQueue cancelAllOperations];
}

- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL completion:(BBThumbnailGeneratorCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:self.defaultSize page:self.defaultPage time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailGeneratorCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:self.defaultPage time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page completion:(BBThumbnailGeneratorCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:page time:self.defaultTime completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion; {
    return [self generateThumbnailForURL:URL size:size page:self.defaultPage time:time completion:completion];
}
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion; {
    BBThumbnailOperationWrapper *retval = [[BBThumbnailOperationWrapper alloc] init];
    
    @weakify(self);
    [self.operationQueue addOperationWithBlock:^{
        @strongify(self);
        
        NSString *key = [self memoryCacheKeyForURL:URL size:size page:page time:time];
        NSURL *fileCacheURL = [self fileCacheURLForMemoryCacheKey:key];
        
        void(^cacheImageBlock)(BBThumbnailGeneratorImageClass *image, NSError *error, BBThumbnailGeneratorCacheType cacheType) = ^(BBThumbnailGeneratorImageClass *image, NSError *error, BBThumbnailGeneratorCacheType cacheType){
            @strongify(self);
            
            if (image) {
                switch (cacheType) {
                    case BBThumbnailGeneratorCacheTypeNone: {
                        if (self.isFileCachingEnabled) {
                            dispatch_async(self.fileCacheQueue, ^{
#if (TARGET_OS_IPHONE)
                                NSData *data = [image BB_hasAlpha] ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 1.0);
#else
                                CGImageRef imageRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
                                CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
                                NSData *data = (__bridge_transfer NSData *)CGDataProviderCopyData(dataProviderRef);
#endif
                                
                                NSError *outError;
                                if (![data writeToURL:fileCacheURL options:0 error:&outError]) {
                                    BBLogObject(outError);
                                }
                            });
                        }
                    }
                    case BBThumbnailGeneratorCacheTypeFile:
                        if (self.isMemoryCachingEnabled) {
#if (TARGET_OS_IPHONE)
                            [self.memoryCache setObject:image forKey:key cost:image.size.width * image.size.height * image.scale];
#else
                            [self.memoryCache setObject:image forKey:key cost:image.size.width * image.size.height];
#endif
                        }
                        break;
                    default:
                        break;
                }
            }
            
            [self.completionQueue addOperationWithBlock:^{
                completion(image,error,cacheType,URL,size,page,time);
            }];
        };
        
        if (self.isMemoryCachingEnabled) {
            BBThumbnailGeneratorImageClass *retval = [self.memoryCache objectForKey:key];
            
            if (retval) {
                cacheImageBlock(retval,nil,BBThumbnailGeneratorCacheTypeMemory);
                return;
            }
        }
        
        if (self.isFileCachingEnabled) {
            if ([fileCacheURL checkResourceIsReachableAndReturnError:NULL]) {
                BBThumbnailGeneratorImageClass *retval = [[BBThumbnailGeneratorImageClass alloc] initWithContentsOfFile:fileCacheURL.path];
                
                if (retval) {
                    cacheImageBlock(retval,nil,BBThumbnailGeneratorCacheTypeFile);
                    return;
                }
            }
        }
        
        void(^operationCompletionBlock)(BBThumbnailGeneratorImageClass *image, NSError *error) = ^(BBThumbnailGeneratorImageClass *image, NSError *error){
            cacheImageBlock(image,error,BBThumbnailGeneratorCacheTypeNone);
        };
        
        if (URL.isFileURL) {
            NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)URL.lastPathComponent.pathExtension, NULL);
            
            if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeImage)) {
                [retval setOperation:[[BBThumbnailImageOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
            else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie)) {
                [retval setOperation:[[BBThumbnailMovieOperation alloc] initWithURL:URL size:size time:time completion:operationCompletionBlock]];
            }
            else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypePDF)) {
                [retval setOperation:[[BBThumbnailPDFOperation alloc] initWithURL:URL size:size page:page completion:operationCompletionBlock]];
            }
            else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeRTF) ||
                     UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeRTFD)) {
                [retval setOperation:[[BBThumbnailRTFOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
            else if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypePlainText)) {
                [retval setOperation:[[BBThumbnailTextOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
            else if ([@[@"doc",@"docx"] containsObject:URL.lastPathComponent.pathExtension.lowercaseString]) {
                [retval setOperation:[[BBThumbnailDocumentOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
            else {
                cacheImageBlock(nil,nil,BBThumbnailGeneratorCacheTypeNone);
            }
        }
        else {
            if ([URL.host isEqualToString:@"www.youtube.com"] &&
                self.youTubeAPIKey.length > 0) {
                
                [retval setOperation:[[BBThumbnailYouTubeOperation alloc] initWithURL:URL size:size APIKey:self.youTubeAPIKey completion:operationCompletionBlock]];
            }
            else if ([URL.host isEqualToString:@"vimeo.com"]) {
                [retval setOperation:[[BBThumbnailVimeoOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
            else {
                [retval setOperation:[[BBThumbnailHTMLOperation alloc] initWithURL:URL size:size completion:operationCompletionBlock]];
            }
        }
        
        if (retval.operation) {
            [self.operationQueue addOperation:retval.operation];
        }
    }];
    
    return retval;
}
#pragma mark Properties
- (BOOL)isFileCachingEnabled {
    return (self.cacheOptions & BBThumbnailGeneratorCacheOptionsFile) != 0;
}
- (BOOL)isMemoryCachingEnabled {
    return (self.cacheOptions & BBThumbnailGeneratorCacheOptionsMemory) != 0;
}

- (void)setCompletionQueue:(NSOperationQueue *)completionQueue {
    _completionQueue = completionQueue ?: [self.class _defaultCompletionQueue];
}
#pragma mark *** Private Methods ***
+ (NSOperationQueue *)_defaultCompletionQueue; {
    return [NSOperationQueue mainQueue];
}
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
