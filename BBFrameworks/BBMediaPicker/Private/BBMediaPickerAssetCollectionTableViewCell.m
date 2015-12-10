//
//  BBMediaPickerAssetCollectionTableViewCell.m
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

#import "BBMediaPickerAssetCollectionTableViewCell.h"
#import "BBMediaPickerAssetCollectionThumbnailView.h"
#import "UIImage+BBKitExtensions.h"
#import "BBMediaPickerTheme.h"
#import "BBMediaPickerModel.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionTableViewCell ()
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView1;
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView2;
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView3;
@property (weak,nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *leftEdgeInsetLayoutConstraint;
@end

@implementation BBMediaPickerAssetCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    BBWeakify(self);
    [[RACObserve(self, model.model.theme)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         BBMediaPickerTheme *theme = self.model.model.theme ?: [BBMediaPickerTheme defaultTheme];
         
         [self.thumbnailView1 setTheme:theme];
         [self.thumbnailView2 setTheme:theme];
         [self.thumbnailView3 setTheme:theme];
         
         [self.titleLabel setFont:theme.assetCollectionCellTitleFont];
         [self.titleLabel setTextColor:theme.assetCollectionCellTitleColor];
         
         [self.subtitleLabel setFont:theme.assetCollectionCellSubtitleFont];
         [self.subtitleLabel setTextColor:theme.assetCollectionCellSubtitleColor];
         
         [self.leftEdgeInsetLayoutConstraint setConstant:theme.assetCollectionSeparatorEdgeInsets.left];
     }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_model cancelAllThumbnailRequests];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.model.model.theme.assetCollectionCellAccessoryImage) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setAccessoryView:[[UIImageView alloc] initWithImage:self.model.model.theme.assetCollectionCellAccessoryImage]];
    }
    else {
        [self setAccessoryType:selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    }
    
    [self.thumbnailView1.layer setBorderWidth:selected ? self.model.model.theme.selectionBorderWidth : 0.0];
}

- (void)setModel:(BBMediaPickerAssetCollectionModel *)model {
    _model = model;
    
    [self.titleLabel setText:_model.title];
    [self.subtitleLabel setText:_model.subtitle];
    [self.typeImageView setImage:[_model.typeImage BB_imageByRenderingWithColor:_model.model.theme.assetCollectionForegroundColor]];
    
    BBWeakify(self);
    [_model requestThumbnailImageOfSize:self.thumbnailView1.thumbnailImageView.frame.size thumbnailIndex:0 completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView1.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:self.thumbnailView2.thumbnailImageView.frame.size thumbnailIndex:1 completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView2.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:self.thumbnailView3.thumbnailImageView.frame.size thumbnailIndex:2 completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView3.thumbnailImageView setImage:thumbnailImage];
    }];
}

+ (CGFloat)rowHeight; {
    return 60.0;
}

@end
