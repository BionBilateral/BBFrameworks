//
//  BBMediaPickerAssetCollectionThumbnailView.m
//  BBFrameworks
//
//  Created by William Towe on 11/14/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionThumbnailView.h"
#import "BBMediaPickerTheme.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionThumbnailView ()
@property (readwrite,strong,nonatomic) UIImageView *thumbnailImageView;
@end

@implementation BBMediaPickerAssetCollectionThumbnailView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBorderColor:[BBMediaPickerTheme defaultTheme].assetCollectionCellBackgroundColor];
    [self setBorderWidth:1.0];
    [self setBorderOptions:BBViewBorderOptionsTop];
    
    [self setThumbnailImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.thumbnailImageView setClipsToBounds:YES];
    [self addSubview:self.thumbnailImageView];
    
    BBWeakify(self);
    [[RACObserve(self, theme)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         BBMediaPickerTheme *theme = self.theme ?: [BBMediaPickerTheme defaultTheme];
         
         [self setBorderColor:theme.assetCollectionCellBackgroundColor];
     }];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.thumbnailImageView setFrame:CGRectMake(0, self.borderWidth, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.borderWidth)];
}

@end
