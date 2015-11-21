//
//  ThumbnailsViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/24/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ThumbnailsViewController.h"

#import <BBFrameworks/BBBlocks.h>

#import <BBFrameworks/BBThumbnail.h>
#import <BBFrameworks/BBBlocks.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ThumbnailsViewController ()
@property (weak,nonatomic) IBOutlet NSCollectionView *collectionView;

@property (strong,nonatomic) BBThumbnailGenerator *thumbnailGenerator;
@property (copy,nonatomic) NSArray *thumbnailURLs;
@end

@implementation ThumbnailsViewController

- (NSString *)title {
    return @"Thumbnails";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setThumbnailGenerator:[[BBThumbnailGenerator alloc] init]];
    
    NSDictionary *APIKeys = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"]];
    
    [self.thumbnailGenerator setYouTubeAPIKey:APIKeys[@"thumbnail_youtube_api_key"]];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [temp addObjectsFromArray:[[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RemoteURLs" withExtension:@"plist"]] BB_map:^id(id object, NSInteger index) {
        return [NSURL URLWithString:object];
    }]];
    
    for (NSURL *URL in [[NSFileManager defaultManager] enumeratorAtURL:[[NSBundle mainBundle] URLForResource:@"media" withExtension:@""] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants errorHandler:nil]) {
        [temp addObject:URL];
    }
    
    [self setThumbnailURLs:[temp BB_map:^id(id obj, NSInteger idx) {
        return RACTuplePack(obj,self.thumbnailGenerator);
    }]];
}

@end
