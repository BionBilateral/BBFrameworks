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
#import "BBMediaViewerPagePDFModel.h"
#import "BBKitFunctions.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPagePDFCollectionViewCell ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong,nonatomic) RACDisposable *thumbnailDisposable;
@end

@implementation BBMediaViewerPagePDFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setBackgroundColor:[UIColor whiteColor]];
    [_thumbnailImageView.layer setBorderColor:self.tintColor.CGColor];
    [self.contentView addSubview:_thumbnailImageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_activityIndicatorView setHidesWhenStopped:YES];
    [self.contentView addSubview:_activityIndicatorView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setThumbnailDisposable:nil];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.thumbnailImageView.layer setBorderWidth:selected ? 1.0 / [UIScreen mainScreen].scale : 0.0];
    [self.thumbnailImageView setTransform:selected ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity];
}

- (void)setModel:(BBMediaViewerPagePDFDetailModel *)model {
    _model = model;
    
    NSURL *URL = _model.parentModel.URL;
    
    if (!URL.isFileURL) {
        URL = [_model.parentModel.parentModel fileURLForMedia:_model.parentModel.media];
    }
    
    if (![URL checkResourceIsReachableAndReturnError:NULL]) {
        return;
    }
    
    [self.thumbnailImageView setImage:nil];
    [self.activityIndicatorView startAnimating];
    
    BBWeakify(self);
    [self setThumbnailDisposable:
     [[[_model requestThumbnailOfSize:BBCGSizeAdjustedForMainScreenScale(_model.parentModel.thumbnailSize)]
     deliverOnMainThread]
     subscribeNext:^(UIImage *value) {
         BBStrongify(self);
         [self.thumbnailImageView setImage:value];
         [self.activityIndicatorView stopAnimating];
     }]];
}

- (void)setThumbnailDisposable:(RACDisposable *)thumbnailDisposable {
    [_thumbnailDisposable dispose];
    
    _thumbnailDisposable = thumbnailDisposable;
}

@end
