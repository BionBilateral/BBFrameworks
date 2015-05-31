//
//  BBThumbnailGenerator+BBReactiveThumbnailExtensions.m
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

#import "BBThumbnailGenerator+BBReactiveThumbnailExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation BBThumbnailGenerator (BBReactiveThumbnailExtensions)

- (RACSignal *)BB_generateThumbnailForURL:(NSURL *)URL; {
    return [self BB_generateThumbnailForURL:URL size:self.defaultSize page:self.defaultPage time:self.defaultTime];
}
- (RACSignal *)BB_generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size; {
    return [self BB_generateThumbnailForURL:URL size:size page:self.defaultPage time:self.defaultTime];
}
- (RACSignal *)BB_generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page; {
    return [self BB_generateThumbnailForURL:URL size:size page:page time:self.defaultTime];
}
- (RACSignal *)BB_generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size time:(NSTimeInterval)time; {
    return [self BB_generateThumbnailForURL:URL size:size page:self.defaultPage time:time];
}
- (RACSignal *)BB_generateThumbnailForURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page time:(NSTimeInterval)time; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        id<BBThumbnailOperation> operation = [self generateThumbnailForURL:URL size:size page:page time:time completion:^(BBThumbnailGeneratorImageClass *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, BBThumbnailGeneratorSizeStruct size, NSInteger page, NSTimeInterval time) {
            if (image) {
#if (TARGET_OS_IPHONE)
                [subscriber sendNext:RACTuplePack(image,@(cacheType),URL,[NSValue valueWithCGSize:size],@(page),@(time))];
#else
                [subscriber sendNext:RACTuplePack(image,@(cacheType),URL,[NSValue valueWithSize:size],@(page),@(time))];
#endif
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

@end
