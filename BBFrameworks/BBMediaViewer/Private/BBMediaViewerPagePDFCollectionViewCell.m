//
//  BBMediaViewerPagePDFCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 3/1/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPagePDFCollectionViewCell.h"
#import "BBMediaViewerPagePDFDetailModel.h"
#import "BBThumbnail.h"
#import "BBMediaViewerPagePDFModel.h"
#import "BBKitFunctions.h"
#import "BBFrameworksMacros.h"

@interface BBMediaViewerPagePDFCollectionViewCell ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;

@property (strong,nonatomic) id<BBThumbnailOperation> thumbnailOperation;
@end

@implementation BBMediaViewerPagePDFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_thumbnailImageView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _thumbnailImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _thumbnailImageView}]];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setThumbnailOperation:nil];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.thumbnailImageView setTransform:selected ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity];
}

- (void)setModel:(BBMediaViewerPagePDFDetailModel *)model {
    _model = model;
    
    [self.thumbnailImageView setImage:nil];
    
    BBWeakify(self);
    [_model.parentModel.thumbnailGenerator generateThumbnailForURL:_model.parentModel.URL size:BBCGSizeAdjustedForMainScreenScale(_model.parentModel.thumbnailSize) page:[_model.parentModel pageForPagePDFDetail:_model] completion:^(UIImage * _Nullable image, NSError * _Nullable error, BBThumbnailGeneratorCacheType cacheType, NSURL * _Nonnull URL, CGSize size, NSInteger page, NSTimeInterval time) {
        BBStrongify(self);
        [self.thumbnailImageView setImage:image];
    }];
}

- (void)setThumbnailOperation:(id<BBThumbnailOperation>)thumbnailOperation {
    [_thumbnailOperation cancel];
    
    _thumbnailOperation = thumbnailOperation;
}

@end
