//
//  SecondViewController.m
//  BBFrameworks
//
//  Created by William Towe on 5/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SecondViewController.h"

#import <BBFrameworks/BBThumbnail.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface ThumbnailCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) id<BBThumbnailOperation> operation;

@end

@implementation ThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.contentView addSubview:self.imageView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setFrame:self.contentView.bounds];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.operation cancel];
}

@end

@interface SecondViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) BBThumbnailGenerator *thumbnailGenerator;

@property (copy,nonatomic) NSArray *thumbnailURLs;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSURL *URL in [[NSFileManager defaultManager] enumeratorAtURL:[[NSBundle mainBundle] URLForResource:@"docs" withExtension:@""] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants errorHandler:nil]) {
        [temp addObject:URL];
    }
    
    [self setThumbnailURLs:temp];
    
    [self setThumbnailGenerator:[[BBThumbnailGenerator alloc] init]];
    
    [self.collectionView registerClass:[ThumbnailCell class] forCellWithReuseIdentifier:NSStringFromClass([ThumbnailCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.thumbnailURLs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ThumbnailCell class]) forIndexPath:indexPath];
    
    @weakify(cell);
    [cell setOperation:[self.thumbnailGenerator generateThumbnailForURL:self.thumbnailURLs[indexPath.row] completion:^(UIImage *image, NSError *error, BBThumbnailGeneratorCacheType cacheType, NSURL *URL, CGSize size, NSInteger page, NSTimeInterval time) {
        @strongify(cell);
        
        [cell.imageView setImage:image];
    }]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.thumbnailGenerator.defaultSize;
}

@end
