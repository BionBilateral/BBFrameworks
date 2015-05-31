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

typedef NS_ENUM(NSInteger, BBThumbnailGeneratorCacheType) {
    BBThumbnailGeneratorCacheTypeNone,
    BBThumbnailGeneratorCacheTypeFile,
    BBThumbnailGeneratorCacheTypeMemory
};

typedef NS_OPTIONS(NSInteger, BBThumbnailGeneratorCacheOptions) {
    BBThumbnailGeneratorCacheOptionsNone = 0,
    BBThumbnailGeneratorCacheOptionsFile = 1 << 0,
    BBThumbnailGeneratorCacheOptionsMemory = 1 << 1
};

typedef void(^BBThumbnailGeneratorCompletionBlock)(BBThumbnailGeneratorImageClass *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, BBThumbnailGeneratorSizeStruct size, NSInteger page, NSTimeInterval time);

@interface BBThumbnailGenerator : NSObject

@property (assign,nonatomic) BBThumbnailGeneratorCacheOptions cacheOptions;
@property (readonly,nonatomic,getter=isFileCachingEnabled) BOOL fileCachingEnabled;
@property (readonly,nonatomic,getter=isMemoryCachingEnabled) BOOL memoryCachingEnabled;

@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct defaultSize;
@property (assign,nonatomic) NSInteger defaultPage;
@property (assign,nonatomic) NSTimeInterval defaultTime;

- (void)clearFileCache;
- (void)clearMemoryCache;

- (NSString *)memoryCacheKeyForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time;

- (NSURL *)fileCacheURLForMemoryCacheKey:(NSString *)key;
- (NSURL *)fileCacheURLForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time;

- (void)cancelAllThumbnailGeneration;

- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL completion:(BBThumbnailGeneratorCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailGeneratorCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page completion:(BBThumbnailGeneratorCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time completion:(BBThumbnailGeneratorCompletionBlock)completion;

@end
