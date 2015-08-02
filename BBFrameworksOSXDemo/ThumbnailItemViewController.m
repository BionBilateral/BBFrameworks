//
//  ThumbnailItemViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/24/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ThumbnailItemViewController.h"
#import "BBBlocks.h"

#import <BBFrameworks/BBReactiveThumbnail.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ThumbnailItemViewController ()
@property (readonly,nonatomic) NSImageView *thumbnailImageView;

@property (readonly,nonatomic) BBThumbnailGenerator *thumbnailGenerator;
@property (readonly,nonatomic) NSURL *thumbnailURL;
@end

@implementation ThumbnailItemViewController

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    @weakify(self);
    [[[self.thumbnailGenerator BB_generateThumbnailForURL:self.thumbnailURL]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *value) {
         @strongify(self);
         [self.thumbnailImageView setImage:value.first];
     } error:^(NSError *error) {
         @strongify(self);
         [self.thumbnailImageView setImage:nil];
     }];
}

- (NSImageView *)thumbnailImageView {
    return [self.view.subviews BB_find:^BOOL(id obj, NSInteger idx) {
        return [obj isKindOfClass:[NSImageView class]];
    }];
}
- (BBThumbnailGenerator *)thumbnailGenerator {
    return self.representedObject[1];
}
- (NSURL *)thumbnailURL {
    return self.representedObject[0];
}

@end
