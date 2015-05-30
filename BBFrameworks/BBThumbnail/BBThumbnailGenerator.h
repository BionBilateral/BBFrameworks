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
#if (TARGET_OS_IPHONE)
#import <UIKit/UIImage.h>
#else
#import <AppKit/NSImage.h>
#endif
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

#if (TARGET_OS_IPHONE)
typedef void(^BBThumbnailCompletionBlock)(UIImage *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, CGSize size, NSInteger page, NSTimeInterval time);
#else
typedef void(^BBThumbnailCompletionBlock)(NSImage *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, NSSize size, NSInteger page, NSTimeInterval time);
#endif

@interface BBThumbnailGenerator : NSObject

@property (assign,nonatomic) BBThumbnailGeneratorCacheOptions cacheOptions;

@property (readonly,copy,nonatomic) NSURL *fileCacheDirectoryURL;

@property (assign,nonatomic) CGSize defaultSize;
@property (assign,nonatomic) NSInteger defaultPage;
@property (assign,nonatomic) NSTimeInterval defaultTime;

- (void)clearFileCache;
- (void)clearMemoryCache;

- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL completion:(BBThumbnailCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size completion:(BBThumbnailCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size page:(NSInteger)page completion:(BBThumbnailCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size time:(NSTimeInterval)time completion:(BBThumbnailCompletionBlock)completion;
- (id<BBThumbnailOperation>)generateThumbnailForURL:(NSURL *)URL size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time completion:(BBThumbnailCompletionBlock)completion;

@end
