//
//  BBMediaViewerPDFThumbnailCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 11/21/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPDFThumbnailCollectionViewCell.h"
#import "BBThumbnail.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPDFThumbnailCollectionViewCell ()
@property (weak,nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (strong,nonatomic) id<BBThumbnailOperation> thumbnailOperation;
@end

@implementation BBMediaViewerPDFThumbnailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [self.thumbnailImageView.layer setBorderColor:self.tintColor.CGColor];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_thumbnailOperation cancel];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.thumbnailImageView.layer setBorderWidth:selected ? 1.0 : 0.0];
}

- (void)setPageNumber:(size_t)pageNumber {
    _pageNumber = pageNumber;
    
    @weakify(self);
    _thumbnailOperation = [[BBThumbnailGenerator defaultGenerator] generateThumbnailForURL:self.PDFURL size:[self.class cellSize] page:_pageNumber completion:^(UIImage * _Nullable image, NSError * _Nullable error, BBThumbnailGeneratorCacheType cacheType, NSURL * _Nonnull URL, CGSize size, NSInteger page, NSTimeInterval time) {
        @strongify(self);
        [self.thumbnailImageView setImage:image];
    }];
}

+ (CGSize)cellSize; {
    return CGSizeMake(44, 44);
}

@end
