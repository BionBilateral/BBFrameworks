//
//  BBThumbnailAsyncOperation.m
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

#import "BBThumbnailAsyncOperation.h"
#import "BBFoundationDebugging.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation BBThumbnailAsyncOperation

- (void)start {
    if (self.isCancelled) {
        [self finishOperationWithImage:nil error:nil];
        return;
    }
    
    [self main];
}

- (void)main {
    [self setExecutingAndGenerateKVO:YES];
}

- (void)cancel {
    [super cancel];
    
    [self.task cancel];
}

- (BOOL)isAsynchronous {
    return YES;
}

@synthesize executing=_executing;
@synthesize finished=_finished;

- (void)setExecutingAndGenerateKVO:(BOOL)executing; {
    [self willChangeValueForKey:@keypath(self,isExecuting)];
    
    [self setExecuting:executing];
    
    [self didChangeValueForKey:@keypath(self,isExecuting)];
}
- (void)setFinishedAndGenerateKVO:(BOOL)finished; {
    [self willChangeValueForKey:@keypath(self,isFinished)];
    
    [self setFinished:finished];
    
    [self didChangeValueForKey:@keypath(self,isFinished)];
}

- (void)finishOperationWithImage:(BBThumbnailGeneratorImageClass *)image error:(NSError *)error; {
    self.operationCompletionBlock(image,error);
    
    [self setExecutingAndGenerateKVO:NO];
    [self setFinishedAndGenerateKVO:YES];
}

@end
