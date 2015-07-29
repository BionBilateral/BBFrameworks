//
//  BBMediaPickerAssetCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 7/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetViewModel.h"
#import "BBKitColorMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionViewCell ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@property (strong,nonatomic) UIView *selectedOverlayView;
@end

@implementation BBMediaPickerAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setThumbnailImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.thumbnailImageView];
    
    [self setSelectedOverlayView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.selectedOverlayView];
    
    RAC(self.thumbnailImageView,image) = RACObserve(self, viewModel.thumbnailImage);
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.thumbnailImageView setFrame:self.contentView.bounds];
    [self.selectedOverlayView setFrame:self.contentView.bounds];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.selectedOverlayView setBackgroundColor:selected ? BBColorWA(1.0, 0.5) : [UIColor clearColor]];
}

+ (CGSize)cellSize; {
    return CGSizeMake(78.0, 78.0);
}

@end
