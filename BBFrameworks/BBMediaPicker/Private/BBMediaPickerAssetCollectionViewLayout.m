//
//  BBMediaPickerAssetCollectionViewLayout.m
//  BBFrameworks
//
//  Created by William Towe on 11/13/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionViewLayout.h"

@implementation BBMediaPickerAssetCollectionViewLayout

#pragma mark *** Subclass Overrides ***
- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _numberOfColumns = 4;
    
    [self setSectionInset:UIEdgeInsetsZero];
    [self setMinimumInteritemSpacing:1.0];
    [self setMinimumLineSpacing:1.0];
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat availableWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.left - self.sectionInset.right - (self.minimumInteritemSpacing * (self.numberOfColumns - 1));
    CGFloat itemWidth = floor(availableWidth / (CGFloat)self.numberOfColumns);
    
    [self setItemSize:CGSizeMake(itemWidth, itemWidth)];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setNumberOfColumns:(NSInteger)numberOfColumns {
    if (_numberOfColumns == numberOfColumns) {
        return;
    }
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}

@end
