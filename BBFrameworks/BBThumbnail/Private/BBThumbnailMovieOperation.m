//
//  BBThumbnailMovieOperation.m
//  BBFrameworks
//
//  Created by William Towe on 5/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailMovieOperation.h"
#import "BBKitCGImageFunctions.h"

#import <AVFoundation/AVFoundation.h>

@interface BBThumbnailMovieOperation ()
@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@property (assign,nonatomic) NSTimeInterval time;
@property (copy,nonatomic) BBThumbnailOperationCompletionBlock operationCompletionBlock;
@end

@implementation BBThumbnailMovieOperation

- (void)main {
    if (self.isCancelled) {
        self.operationCompletionBlock(nil,nil);
        return;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:self.URL];
    AVAssetImageGenerator *assetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    [assetImageGenerator setAppliesPreferredTrackTransform:YES];
    
    NSError *outError;
    CGImageRef imageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(self.time, NSEC_PER_SEC) actualTime:NULL error:&outError];
    
    if (!imageRef) {
        self.operationCompletionBlock(nil,outError);
        return;
    }
    else if (self.isCancelled) {
        CGImageRelease(imageRef);
        self.operationCompletionBlock(nil,nil);
        return;
    }
    
#if (TARGET_OS_IPHONE)
    CGImageRef sourceImageRef = BBKitCGImageCreateThumbnailWithSize(imageRef, self.size);
    BBThumbnailGeneratorImageClass *retval = [[BBThumbnailGeneratorImageClass alloc] initWithCGImage:sourceImageRef];
#else
    CGImageRef sourceImageRef = BBKitCGImageCreateThumbnailWithSize(imageRef, NSSizeToCGSize(self.size));
    BBThumbnailGeneratorImageClass *retval = [[BBThumbnailGeneratorImageClass alloc] initWithCGImage:sourceImageRef size:NSZeroSize];
#endif
    
    CGImageRelease(imageRef);
    CGImageRelease(sourceImageRef);
    
    self.operationCompletionBlock(retval,nil);
}

- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setTime:time];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@end
