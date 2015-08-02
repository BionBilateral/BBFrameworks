//
//  BBThumbnailGenerator.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "BBThumbnailDefines.h"
#import "BBThumbnailOperation.h"

/**
 Enum describing the cache type that was used to access the thumbnail.
 */
typedef NS_ENUM(NSInteger, BBThumbnailGeneratorCacheType) {
    /**
     No cache was accessed, the thumbnail was generated for the first time.
     */
    BBThumbnailGeneratorCacheTypeNone,
    /**
     The file cache was accessed, the thumbnail was loaded from disk.
     */
    BBThumbnailGeneratorCacheTypeFile,
    /**
     The memory cache was accessed, the thumbnail was retrieved from the internal NSCache.
     */
    BBThumbnailGeneratorCacheTypeMemory
};

/**
 Flags describing the cache type that is used to store generated thumbnails.
 */
typedef NS_OPTIONS(NSInteger, BBThumbnailGeneratorCacheOptions) {
    /**
     Caching is not enabled, the thumbnail will be generated each time it is requested.
     */
    BBThumbnailGeneratorCacheOptionsNone = 0,
    /**
     File caching is enabled, the generated thumbnail will be stored on disk.
     */
    BBThumbnailGeneratorCacheOptionsFile = 1 << 0,
    /**
     Memory caching is enabled, the generated thumbnail will be stored in memory.
     */
    BBThumbnailGeneratorCacheOptionsMemory = 1 << 1
};

/**
 Block signature for thumbnail download progress callback.
 
 @param URL The url for which the thumbnail is being generated
 @param bytesWritten The bytes that were written
 @param totalBytesWritten The total bytes that have been written so far
 @param totalBytesExpectedToWrite The total expected bytes to write
 */
typedef void(^BBThumbnailGeneratorProgressBlock)(NSURL *URL, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
/**
 Block signature for thumbnail generation callback.
 
 @param image The generated thumbnail image or nil
 @param error The reason the thumbnail could not be generated or nil
 @param cacheType If image is non-nil, the cache type used to access the thumbnail image
 @param URL The original url used to generate the image
 @param size The size of the requested thumbnail
 @param page The page of the requested thumbnail, applicable for PDF thumbnails
 @param time The time of the requested thumbnail, applicable for movie thumbnails
 */
typedef void(^BBThumbnailGeneratorCompletionBlock)(BBThumbnailGeneratorImageClass *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, BBThumbnailGeneratorSizeStruct size, NSInteger page, NSTimeInterval time);

/**
 BBThumbnailGenerator is an NSObject subclass used for generating thumbnail images from various sources.
 */
@interface BBThumbnailGenerator : NSObject

/**
 Set and get the cache options for the receiver.
 
 The default is `BBThumbnailGeneratorCacheOptionsFile | BBThumbnailGeneratorCacheOptionsMemory`.
 */
@property (assign,nonatomic) BBThumbnailGeneratorCacheOptions cacheOptions;
/**
 Get whether file caching is enabled.
 */
@property (readonly,nonatomic,getter=isFileCachingEnabled) BOOL fileCachingEnabled;
/**
 Get whether memory caching is enabled.
 */
@property (readonly,nonatomic,getter=isMemoryCachingEnabled) BOOL memoryCachingEnabled;

/**
 Set and get the default thumbnail size. This is used for methods that do not contain an explicit size argument.
 
 The default is `CGSizeMake(175.0, 175.0)`.
 */
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct defaultSize;
/**
 Set and get the default thumbnail page. This is used for methods that do not contain an explicit page argument.
 
 The default is `1`.
 */
@property (assign,nonatomic) NSInteger defaultPage;
/**
 Set and get the default thumbnail time. This is used for methods that do not contain an explicit time argument.
 
 The default is `1.0`.
 */
@property (assign,nonatomic) NSTimeInterval defaultTime;

/**
 Set and get the operation queue used when invoking completion blocks.
 
 The default is `[NSOperationQueue mainQueue]`.
 */
@property (strong,nonatomic) NSOperationQueue *completionQueue;

/**
 Set and get the YouTube API key used by the receiver when making thumbnail requests to the YouTube APIs.
 
 The default is nil. Set this value when creating the thumbnail generator with your API key.
 */
@property (copy,nonatomic) NSString *youTubeAPIKey;

@property (copy,nonatomic) NSURLSessionConfiguration *URLSessionConfiguration;

/**
 Clears the on disk cache.
 */
- (void)clearFileCache;
/**
 Clears the internal memory cache.
 */
- (void)clearMemoryCache;

/**
 Returns the memory cache key for a given URL, size, page, and time.
 
 @param URL The URL to use when generating the thumbnail
 @param size The desired size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 @return The memory cache key
 */
- (NSString *)memoryCacheKeyForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time;

/**
 Returns the file cache URL for the provided memory cache key.
 
 @param key The memory cache key
 @return The file cache URL
 */
- (NSURL *)fileCacheURLForMemoryCacheKey:(NSString *)key;
/**
 Returns the file cache URL for the provided URL.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 */
- (NSURL *)fileCacheURLForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time;

/**
 Cancels all remaining thumbnail generation. Outstanding requests will have their completion blocks invoked with nil for image and error.
 */
- (void)cancelAllThumbnailGeneration;

- (NSString *)downloadCacheKeyForURL:(NSURL *)URL;
- (NSURL *)downloadCacheURLForDownloadCacheKey:(NSString *)key;
- (NSURL *)downloadCacheURLForURL:(NSURL *)URL;

/**
 Calls `-[generateThumbnailForURL:size:page:time:completion:]`, passing _URL_ and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:progress:completion:]`, passing _URL_, _progress_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param progress The progress block called while downloading files
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL progress:(BBThumbnailGeneratorProgressBlock)progress completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:completion:]`, passing _URL_, _size_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:progress:completion:]`, passing _URL_, _size_, _progress_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param progress The progress block called while downloading files
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size progress:(BBThumbnailGeneratorProgressBlock)progress completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:completion:]`, passing _URL_, _size_, _page_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:progress:completion:]`, passing _URL_, _size_, _page_, _progress_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param progress The progress block called while downloading files
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page progress:(BBThumbnailGeneratorProgressBlock)progress completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:completion:]`, passing _URL_, _size_, _time_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:progress:completion:]`, passing _URL_, _size_, _time_, _progress_, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 @param progress The progress block called while downloading files
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time progress:(BBThumbnailGeneratorProgressBlock)progress completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Calls `-[generateThumbnailForURL:size:page:time:progress:completion:]`, passing _URL_, _size_, _time_, nil, and _completion_ respectively.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion;
/**
 Generates a thumbnail, optionally accessing the memory or disk cache, and invokes the completion block once finished.
 
 @param URL The URL to use when generating the thumbnail
 @param size The size of the generated thumbnail
 @param page The page of the generated thumbnail, applicable to PDF thumbnails
 @param time The time of the generated thumbnail, applicable to movie thumbnails
 @param progress The progress block that is called during a file download
 @param completion The completion block to invoke upon completion
 @return An object that can be used to cancel the thumbnail generation
 */
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time progress:(BBThumbnailGeneratorProgressBlock)progress completion:(BBThumbnailGeneratorCompletionBlock)completion;

@end
