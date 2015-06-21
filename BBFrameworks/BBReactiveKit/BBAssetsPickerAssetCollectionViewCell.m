//
//  BBAssetsPickerAssetCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBAssetsPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAssetsPickerAssetCollectionViewCell ()
@property (weak,nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (strong,nonatomic) RACDisposable *requestThumbnailDisposable;
@end

@implementation BBAssetsPickerAssetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.thumbnailImageView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)tintColorDidChange {
    [self.thumbnailImageView.layer setBorderColor:self.tintColor.CGColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setRequestThumbnailDisposable:nil];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.thumbnailImageView.layer setBorderWidth:selected ? 4.0 : 0.0];
}

- (void)setViewModel:(BBMediaPickerAssetViewModel *)viewModel {
    _viewModel = viewModel;
    
    if (_viewModel) {
        @weakify(self);
        [self setRequestThumbnailDisposable:
         [[[_viewModel
            requestThumbnailImageWithSize:CGSizeMake(CGRectGetWidth(self.thumbnailImageView.frame), CGRectGetHeight(self.thumbnailImageView.frame))]
           deliverOn:[RACScheduler mainThreadScheduler]]
          subscribeNext:^(UIImage *value) {
              @strongify(self);
              [self.thumbnailImageView setImage:value];
          }]];
    }
    else {
        [self setRequestThumbnailDisposable:nil];
    }
}

- (void)setRequestThumbnailDisposable:(RACDisposable *)requestThumbnailDisposable {
    [_requestThumbnailDisposable dispose];
    
    _requestThumbnailDisposable = requestThumbnailDisposable;
}

+ (CGSize)defaultCellSize; {
    return CGSizeMake(100.0, 100.0);
}

@end
