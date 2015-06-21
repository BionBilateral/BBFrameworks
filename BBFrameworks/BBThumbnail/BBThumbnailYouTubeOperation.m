//
//  BBThumbnailYouTubeOperation.m
//  BBFrameworks
//
//  Created by William Towe on 6/20/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailYouTubeOperation.h"
#import "NSURL+BBFoundationExtensions.h"
#import "BBFoundationDebugging.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#else
#import "NSImage+BBKitExtensions.h"
#endif

NSString *const BBThumbnailYouTubeOperationErrorDomain = @"com.bionbilateral.bbthumbnail.operation.youtube";

@interface BBThumbnailYouTubeOperation ()
@property (readwrite,assign,getter=isExecuting) BOOL executing;
@property (readwrite,assign,getter=isFinished) BOOL finished;

@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@property (copy,nonatomic) NSString *APIKey;
@property (copy,nonatomic) BBThumbnailOperationCompletionBlock operationCompletionBlock;

@property (strong) NSURLSessionDataTask *task;
@end

@implementation BBThumbnailYouTubeOperation

- (void)start {
    if (self.isCancelled) {
        self.operationCompletionBlock(nil,nil);
        [self setFinished:YES];
        return;
    }
    
    [self main];
}

- (void)main {
    [self setExecuting:YES];
    
    NSString *URLString = self.URL.absoluteString;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"v=([A-Za-z0-9]+)" options:0 error:NULL];
    NSTextCheckingResult *result = [regex firstMatchInString:URLString options:0 range:NSMakeRange(0, URLString.length)];
    
    if (!result) {
        self.operationCompletionBlock(nil,nil);
        [self setExecuting:NO];
        [self setFinished:YES];
        return;
    }
    
    NSString *videoID = [URLString substringWithRange:[result rangeAtIndex:1]];
    NSURL *requestURL = [NSURL BB_URLWithBaseString:@"https://www.googleapis.com/youtube/v3/videos" parameters:@{@"part": @"snippet", @"id": videoID, @"key": self.APIKey}];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data &&
            [(NSHTTPURLResponse *)response statusCode] == 200) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            if ([json[@"items"] count] > 0 &&
                [json[@"items"][0][@"snippet"][@"thumbnails"] count] > 0) {
                
                NSDictionary *thumbnailsDict = json[@"items"][0][@"snippet"][@"thumbnails"];
                __block NSDictionary *thumbnailDict = nil;
                
                [thumbnailsDict enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *dict, BOOL *stop) {
                    if ([dict[@"width"] floatValue] > [thumbnailDict[@"width"] floatValue] ||
                        [dict[@"height"] floatValue] > [thumbnailDict[@"height"] floatValue]) {
                        
                        thumbnailDict = dict;
                    }
                }];
                
                NSURL *thumbnailRequestURL = [NSURL URLWithString:thumbnailDict[@"url"]];
                NSURLSessionDataTask *thumbnailTask = [[NSURLSession sharedSession] dataTaskWithURL:thumbnailRequestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data) {
                        BBThumbnailGeneratorImageClass *image = [[BBThumbnailGeneratorImageClass alloc] initWithData:data];
                        BBThumbnailGeneratorImageClass *retval = [image BB_imageByResizingToSize:self.size];
                        
                        self.operationCompletionBlock(retval,nil);
                    }
                    else {
                        self.operationCompletionBlock(nil,error);
                    }
                }];
                
                [self setTask:thumbnailTask];
                [self.task resume];
            }
            else {
                self.operationCompletionBlock(nil,error);
            }
        }
        else {
            self.operationCompletionBlock(nil,[NSError errorWithDomain:BBThumbnailYouTubeOperationErrorDomain code:[(NSHTTPURLResponse *)response statusCode] userInfo:@{NSLocalizedDescriptionKey: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]}]);
        }
        
        [self setExecuting:NO];
        [self setFinished:YES];
    }];
    
    [self setTask:task];
    [self.task resume];
}

- (void)cancel {
    [super cancel];
    
    [self.task cancel];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size APIKey:(NSString *)APIKey completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setAPIKey:APIKey];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@synthesize executing=_executing;
@synthesize finished=_finished;

@end
