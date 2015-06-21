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

#import "ThumbnailsRowViewController.h"

#import <BBFrameworks/BBReactiveThumbnail.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ThumbnailCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) RACDisposable *disposable;

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
    
    [self.disposable dispose];
}

@end

@interface ThumbnailsRowViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) BBThumbnailGenerator *thumbnailGenerator;

@property (copy,nonatomic) NSArray *thumbnailURLs;
@end

@implementation ThumbnailsRowViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumInteritemSpacing:8.0];
    [layout setMinimumLineSpacing:8.0];
    [layout setSectionInset:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    
    if (!(self = [super initWithCollectionViewLayout:layout]))
        return nil;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItems:@[self.splitViewController.displayModeButtonItem]];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSURL *URL in [[NSFileManager defaultManager] enumeratorAtURL:[[NSBundle mainBundle] URLForResource:@"docs" withExtension:@""] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants errorHandler:nil]) {
        [temp addObject:URL];
    }
    
    [temp insertObject:[NSURL URLWithString:@"https://www.youtube.com/watch?v=dQw4w9WgXcQ"] atIndex:0];
    [temp insertObject:[NSURL URLWithString:@"https://vimeo.com/38195013"] atIndex:0];
    
    [self setThumbnailURLs:temp];
    
    [self setThumbnailGenerator:[[BBThumbnailGenerator alloc] init]];
    
    NSDictionary *APIKeys = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"]];
    
    [self.thumbnailGenerator setYouTubeAPIKey:APIKeys[@"thumbnail_youtube_api_key"]];
    
    [self.collectionView registerClass:[ThumbnailCell class] forCellWithReuseIdentifier:NSStringFromClass([ThumbnailCell class])];
}

+ (NSString *)rowClassTitle {
    return @"Thumbnails";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.thumbnailURLs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ThumbnailCell class]) forIndexPath:indexPath];
    
    @weakify(cell);
    [cell setDisposable:[[[self.thumbnailGenerator BB_generateThumbnailForURL:self.thumbnailURLs[indexPath.row]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *value) {
        @strongify(cell);
        [cell.imageView setImage:value.first];
    } error:^(NSError *error) {
        [cell.imageView setImage:nil];
    }]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.thumbnailGenerator.defaultSize;
}

@end
