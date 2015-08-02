//
//  BBThumbnailVimeoOperation.m
//  BBFrameworks
//
//  Created by William Towe on 6/21/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailVimeoOperation.h"
#import "BBFoundationDebugging.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#else
#import "NSImage+BBKitExtensions.h"
#endif

@interface BBThumbnailVimeoOperation ()
@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@end

@implementation BBThumbnailVimeoOperation

- (void)main {
    [super main];
    
    NSArray *pathComps = self.URL.pathComponents;
    
    if ((pathComps.count > 1 &&
        [pathComps.firstObject isEqualToString:@"/"]) ||
        pathComps.count > 0) {
        
        if ([pathComps.firstObject isEqualToString:@"/"]) {
            pathComps = [pathComps subarrayWithRange:NSMakeRange(1, pathComps.count - 1)];
        }
        
        NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://vimeo.com/api/v2/video/%@.json",pathComps.firstObject]];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data &&
                [(NSHTTPURLResponse *)response statusCode] == 200) {
                
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                
                if (json.count > 0) {
                    NSDictionary *thumbnailDict = json.firstObject;
                    NSString *thumbnailLink = ({
                        NSString *retval = thumbnailDict[@"thumbnail_small"];
                        
                        if (thumbnailDict[@"thumbnail_large"]) {
                            retval = thumbnailDict[@"thumbnail_large"];
                        }
                        else if (thumbnailDict[@"thumbnail_medium"]) {
                            retval = thumbnailDict[@"thumbnail_medium"];
                        }
                        
                        retval;
                    });
                    NSURL *thumbnailRequestURL = [NSURL URLWithString:thumbnailLink];
                    NSURLSessionDataTask *thumbnailTask = [[NSURLSession sharedSession] dataTaskWithURL:thumbnailRequestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (data) {
                            BBThumbnailGeneratorImageClass *image = [[BBThumbnailGeneratorImageClass alloc] initWithData:data];
                            BBThumbnailGeneratorImageClass *retval = [image BB_imageByResizingToSize:self.size];
                            
                            [self finishOperationWithImage:retval error:nil];
                        }
                        else {
                            [self finishOperationWithImage:nil error:error];
                        }
                    }];
                    
                    [self setTask:thumbnailTask];
                    [self.task resume];
                }
                else {
                    [self finishOperationWithImage:nil error:nil];
                }
            }
            else {
                [self finishOperationWithImage:nil error:error];
            }
        }];
        
        [self setTask:task];
        [self.task resume];
    }
    else {
        [self finishOperationWithImage:nil error:nil];
    }
}

- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@end
