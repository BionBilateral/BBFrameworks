//
//  BBMediaViewerModel.m
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerModel.h"
#import "BBMediaViewerTheme.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerModel ()
@property (readwrite,strong,nonatomic) RACCommand *doneCommand;
@end

@implementation BBMediaViewerModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _theme = [BBMediaViewerTheme defaultTheme];
    
    BBWeakify(self);
    
    _doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        BBStrongify(self);
        return [RACSignal return:self];
    }];
    
    return self;
}

- (NSInteger)numberOfMedia; {
    return [self.dataSource numberOfMediaInMediaViewerModel:self];
}
- (id<BBMediaViewerMedia>)mediaAtIndex:(NSInteger)index; {
    return [self.dataSource mediaViewerModel:self mediaAtIndex:index];
}
- (NSInteger)indexOfMedia:(id<BBMediaViewerMedia>)media; {
    NSInteger retval = NSNotFound;
    
    for (NSInteger i=0; i<[self numberOfMedia]; i++) {
        id<BBMediaViewerMedia> m = [self mediaAtIndex:i];
        
        if ([m isEqual:media]) {
            retval = i;
            break;
        }
    }
    
    return retval;
}

- (NSURL *)fileURLForMedia:(id<BBMediaViewerMedia>)media; {
    return [self.delegate mediaViewerModel:self fileURLForMedia:media];
}
- (void)downloadForMedia:(id<BBMediaViewerMedia>)media completion:(BBMediaViewerDownloadCompletionBlock)completion; {
    [self.delegate mediaViewerModel:self downloadForMedia:media completion:completion];
}

- (void)setTheme:(BBMediaViewerTheme *)theme {
    _theme = theme ?: [BBMediaViewerTheme defaultTheme];
}

@end
