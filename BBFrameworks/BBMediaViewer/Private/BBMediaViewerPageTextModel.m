//
//  BBMediaViewerPageTextModel.m
//  BBFrameworks
//
//  Created by William Towe on 3/2/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageTextModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"
#import "BBFoundationFunctions.h"
#import "UIAlertController+BBKitExtensions.h"

@interface BBMediaViewerPageTextModel ()
@property (readwrite,copy,nonatomic) NSString *text;
@end

@implementation BBMediaViewerPageTextModel

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    BBWeakify(self);
    void(^createImageBlock)(NSURL *) = ^(NSURL *URL){
        BBStrongify(self);
        [self setText:[[NSString alloc] initWithContentsOfURL:self.URL usedEncoding:NULL error:NULL]];
    };
    
    if (self.URL.isFileURL) {
        createImageBlock(self.URL);
    }
    else {
        NSURL *fileURL = [self.parentModel fileURLForMedia:self.media];
        
        if ([fileURL checkResourceIsReachableAndReturnError:NULL]) {
            createImageBlock(fileURL);
        }
        else {
            [self.parentModel downloadMedia:self.media completion:^(BOOL success, NSError *error){
                BBDispatchMainAsync(^{
                    if (success) {
                        createImageBlock(fileURL);
                    }
                    else if (error) {
                        [self.parentModel reportError:error];
                    }
                });
            }];
        }
    }
    
    return self;
}

- (id)activityItem {
    return self.text;
}

@end
