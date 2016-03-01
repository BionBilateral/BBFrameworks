//
//  BBMediaViewerPagePDFToolbarContentView.m
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

#import "BBMediaViewerPagePDFToolbarContentView.h"
#import "BBMediaViewerPagePDFModel.h"
#import "BBMediaViewerPagePDFCollectionViewCell.h"

@interface BBMediaViewerPagePDFToolbarContentView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) BBMediaViewerPagePDFModel *model;
@end

@implementation BBMediaViewerPagePDFToolbarContentView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.numberOfPages;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBMediaViewerPagePDFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBMediaViewerPagePDFCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:[self.model pagePDFDetailForPage:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (instancetype)initWithModel:(BBMediaViewerPagePDFModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumInteritemSpacing:8.0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 8.0, 0, 8.0)];
    [layout setItemSize:CGSizeMake(60, 60)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[BBMediaViewerPagePDFCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BBMediaViewerPagePDFCollectionViewCell class])];
    [_collectionView setDataSource:self];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _collectionView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _collectionView}]];
    
    return self;
}

@end
