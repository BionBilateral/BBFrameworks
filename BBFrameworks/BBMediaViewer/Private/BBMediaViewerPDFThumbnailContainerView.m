//
//  BBMediaViewerPDFThumbnailContainerView.m
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

#import "BBMediaViewerPDFThumbnailContainerView.h"
#import "BBMediaViewerDetailViewModel.h"
#import "BBMediaViewerPDFThumbnailCollectionViewCell.h"
#import "BBFrameworksFunctions.h"

static CGFloat const kMarginY = 8.0;

@interface BBMediaViewerPDFThumbnailContainerView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) BBMediaViewerDetailViewModel *viewModel;
@end

@implementation BBMediaViewerPDFThumbnailContainerView

- (void)layoutSubviews {
    [self.collectionView setFrame:CGRectMake(0, kMarginY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kMarginY - kMarginY)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, kMarginY +[BBMediaViewerPDFThumbnailCollectionViewCell cellSize].height + kMarginY);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.numberOfPDFPages;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaViewerPDFThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBMediaViewerPDFThumbnailCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setPDFURL:self.viewModel.URL];
    [cell setPageNumber:indexPath.item + 1];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate PDFThumbnailContainerView:self didSelectPage:indexPath.item + 1];
}

- (instancetype)initWithViewModel:(BBMediaViewerDetailViewModel *)viewModel; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setViewModel:viewModel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0, 8.0, 0, 8.0)];
    [layout setMinimumInteritemSpacing:1.0];
    [layout setItemSize:[BBMediaViewerPDFThumbnailCollectionViewCell cellSize]];
    
    [self setCollectionView:[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout]];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BBMediaViewerPDFThumbnailCollectionViewCell class]) bundle:BBFrameworksResourcesBundle()] forCellWithReuseIdentifier:NSStringFromClass([BBMediaViewerPDFThumbnailCollectionViewCell class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self addSubview:self.collectionView];
    
    return self;
}

- (void)updateSelectedPage:(size_t)page; {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page - 1 inSection:0];
    
    if (![self.collectionView cellForItemAtIndexPath:indexPath]) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

@end
